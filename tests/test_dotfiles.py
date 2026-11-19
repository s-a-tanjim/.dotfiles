import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest


REPO = Path(__file__).resolve().parents[1]
MOCK = r'''#!/usr/bin/env python3
import json, os, pathlib, sys
tool = pathlib.Path(sys.argv[0]).name
args = sys.argv[1:]
with open(os.environ['TEST_LOG'], 'a') as log:
    log.write(json.dumps([tool, *args]) + '\n')
if tool == 'fzf':
    choices = sys.stdin.read().splitlines()
    selection = os.environ.get('TEST_SELECTION', '')
    if not selection or selection not in choices:
        sys.exit(130)
    sys.stdout.write(selection + '\n')
elif tool == 'aws':
    if args == ['configure', 'list-profiles']:
        print('dev\nprod')
    elif args[:3] == ['configure', 'get', 'region']:
        print('eu-central-1')
else:
    print('Unexpected mutating command: ' + tool, file=sys.stderr)
    sys.exit(97)
'''


class DotfilesTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='dotfiles-test-')
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.mock_bin = self.root / 'bin'
        self.mock_bin.mkdir()
        self.log = self.root / 'commands.jsonl'
        self.env = dict(os.environ)
        for key in list(self.env):
            if key.startswith('AWS_') or key in ('FZF_DEFAULT_OPTS', 'FZF_DEFAULT_OPTS_FILE'):
                self.env.pop(key)
        self.env.update(
            PATH=f'{self.mock_bin}:{os.environ["PATH"]}',
            TEST_LOG=str(self.log),
            GIT_CONFIG_GLOBAL='/dev/null', GIT_CONFIG_SYSTEM='/dev/null',
        )
        for command in ('fzf', 'tmux', 'aws'):
            self.mock(command, MOCK)

    def mock(self, name, content):
        file = self.mock_bin / name
        file.write_text(content)
        file.chmod(0o755)

    def run_command(self, args, *, expected=0, env=None):
        result = subprocess.run(args, cwd=self.root, env=env or self.env,
                                text=True, capture_output=True, timeout=15)
        self.assertEqual(result.returncode, expected, result.stdout + result.stderr)
        return result

    def calls(self):
        return [json.loads(line) for line in self.log.read_text().splitlines()] if self.log.exists() else []

    def shell(self, code, shell='bash', expected=0):
        flags = ['--noprofile', '--norc'] if shell == 'bash' else ['-f']
        return self.run_command([shell, *flags, '-c',
                                 'source "$1"; ' + code, 'test', str(REPO / '.bash_functions')],
                                expected=expected)

    def link(self, source, destination, *, dry_run=False, before='', expected=0):
        return self.run_command(['bash', '-c',
                                 'source "$1"; ' + before + 'create_link_with_backup "$2" "$3" "$4"',
                                 'test', str(REPO / 'installer/linkers.sh'), str(source),
                                 str(destination), '--dry-run' if dry_run else ''], expected=expected)

    def test_link_preserves_directory_and_is_idempotent(self):
        source = self.root / 'repo config'
        source.mkdir()
        destination = self.root / 'config'
        destination.mkdir()
        (destination / 'keep.txt').write_text('original')
        self.link(source, destination)
        backups = list(self.root.glob('config.bak.*'))
        self.assertEqual(len(backups), 1)
        self.assertEqual((backups[0] / 'keep.txt').read_text(), 'original')
        self.assertEqual(destination.resolve(), source)
        self.link(source, destination)
        self.assertEqual(list(self.root.glob('config.bak.*')), backups)

    def test_link_preserves_broken_symlink_and_old_backups(self):
        source = self.root / 'source'
        source.write_text('new')
        destination = self.root / 'config'
        destination.symlink_to('missing')
        (self.root / 'config.bak').write_text('older')
        self.link(source, destination)
        backup = next(self.root.glob('config.bak.*'))
        self.assertTrue(backup.is_symlink())
        self.assertEqual(os.readlink(backup), 'missing')
        self.assertEqual((self.root / 'config.bak').read_text(), 'older')

    def test_link_generates_unique_backups_in_one_process(self):
        source = self.root / 'source'
        source.write_text('new')
        destination = self.root / 'config'
        destination.write_text('first')
        self.run_command(['bash', '-c', '''source "$1"
date() { printf 'fixed'; }
create_link_with_backup "$2" "$3"
unlink "$3"
printf second > "$3"
create_link_with_backup "$2" "$3"
''', 'test', str(REPO / 'installer/linkers.sh'), str(source), str(destination)])
        self.assertEqual(sorted(p.read_text() for p in self.root.glob('config.bak.*')), ['first', 'second'])

    def test_link_failure_restores_original(self):
        source = self.root / 'source'
        source.write_text('new')
        destination = self.root / 'config'
        destination.write_text('original')
        self.link(source, destination, before='ln() { return 1; }; ', expected=1)
        self.assertEqual(destination.read_text(), 'original')
        self.assertFalse(destination.is_symlink())

    def test_link_dry_run_does_not_create_parents_or_backups(self):
        source = self.root / 'source'
        source.write_text('new')
        destination = self.root / 'missing/config'
        self.link(source, destination, dry_run=True)
        self.assertFalse(destination.parent.exists())
        destination = self.root / 'config'
        destination.write_text('original')
        self.link(source, destination, dry_run=True)
        self.assertEqual(destination.read_text(), 'original')
        self.assertEqual(list(self.root.glob('config.bak.*')), [])

    def test_install_dry_run_never_runs_mutating_commands(self):
        for name in ('sudo', 'curl', 'git', 'vim', 'mv', 'ln', 'mkdir', 'cp', 'fc-cache'):
            self.mock(name, MOCK)
        result = self.run_command(['bash', str(REPO / 'install.sh'), '--dry-run'])
        self.assertIn('latest stable Neovim release', result.stdout)
        self.assertIn('tmux plugins', result.stdout)
        self.assertEqual(self.calls(), [])

    def test_installer_stops_when_package_installation_fails(self):
        self.mock('sudo', MOCK)
        self.mock('curl', MOCK)
        self.run_command(['bash', str(REPO / 'installer/ubuntu.sh')], expected=97)
        self.assertEqual(self.calls(), [['sudo', 'apt', 'update']])

    def test_aws_profile_selection_and_cancellation(self):
        for shell in ('bash', 'zsh'):
            with self.subTest(shell=shell):
                self.env['TEST_SELECTION'] = 'prod'
                result = self.shell('awsprofile && printf "%s:%s:%s" "$AWS_PROFILE" "$AWS_DEFAULT_PROFILE" "$AWS_PROFILE_REGION"', shell)
                self.assertIn('prod:prod:eu-central-1', result.stdout)
                self.env.pop('TEST_SELECTION')
                result = self.shell('export AWS_PROFILE=dev; awsprofile; printf "%s" "$AWS_PROFILE"', shell)
                self.assertEqual(result.stdout, 'dev')

    def test_aws_environment_credentials_block_switching(self):
        self.env.update(AWS_ACCESS_KEY_ID='test-only', AWS_PROFILE='dev', TEST_SELECTION='prod')
        for shell in ('bash', 'zsh'):
            result = self.shell('awsprofile', shell, expected=1)
            self.assertIn('environment credentials override profiles', result.stderr)
        self.assertEqual(self.calls(), [])

    def test_doctor_reports_missing_identity_and_config_links(self):
        self.env['XDG_CONFIG_HOME'] = str(self.root / 'unconfigured')
        result = self.run_command(['bash', str(REPO / 'bin/dot'), 'doctor'], expected=1)
        self.assertIn('Git user.email is missing', result.stdout)
        self.assertIn(str(self.root / 'unconfigured/nvim'), result.stdout)
        self.assertFalse((self.root / 'unconfigured').exists())

    def test_doctor_reads_identity_from_included_config(self):
        local_config = self.root / 'identity'
        local_config.write_text('[user]\nname = Test\nemail = test@example.invalid\n')
        global_config = self.root / 'gitconfig'
        global_config.write_text(f'[include]\npath = {local_config}\n')
        self.env.update(GIT_CONFIG_GLOBAL=str(global_config),
                        XDG_CONFIG_HOME=str(self.root / 'unconfigured'))
        result = self.run_command(['bash', str(REPO / 'bin/dot'), 'doctor'], expected=1)
        self.assertIn('OK    Git user.email is configured', result.stdout)
        self.assertNotIn('test@example.invalid', result.stdout)

    def test_prompt_customizations_survive_generated_config(self):
        generated = self.root / 'generated-p10k.zsh'
        generated.write_text('''unset -m 'POWERLEVEL9K_*'
typeset -g POWERLEVEL9K_BACKGROUND=123
typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off
typeset -ga POWERLEVEL9K_KUBECONTEXT_CLASSES=('*' DEFAULT)
typeset -ga POWERLEVEL9K_AWS_CLASSES=('*' DEFAULT)
typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND=kubectl
typeset -g POWERLEVEL9K_AWS_SHOW_ON_COMMAND=aws
''')
        self.run_command(['zsh', '-f', '-c', '''
typeset -gi prompt_loads=0
test_generated=$2
# Only load the generated prompt fixture; skip machine-specific startup scripts.
source() {
  case "$1" in
    */.p10k.zsh)
      (( prompt_loads += 1 ))
      builtin source "$test_generated" ;;
  esac
}
functions[.]=${functions[source]}
p10k() { :; }
compdef() { :; }
tty() { print -r -- /dev/null; }
builtin source "$1"
print -r -- "loads=$prompt_loads transient=$POWERLEVEL9K_TRANSIENT_PROMPT"
[[ $prompt_loads == 1 && $POWERLEVEL9K_TRANSIENT_PROMPT == same-dir &&
   $POWERLEVEL9K_KUBECONTEXT_PROD_FOREGROUND == 196 &&
   $POWERLEVEL9K_AWS_PROD_FOREGROUND == 196 &&
   $POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND == *kctx* &&
   $POWERLEVEL9K_AWS_SHOW_ON_COMMAND == *awsprofile* &&
   $POWERLEVEL9K_BACKGROUND == 123 ]]
''', 'test', str(REPO / '.zshrc'), str(generated)])


if __name__ == '__main__':
    unittest.main()
