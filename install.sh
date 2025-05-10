#!/bin/bash

# Check if the OS is Ubuntu using /etc/os-release
if [[ -f /etc/os-release ]]; then
  . /etc/os-release
  if [[ "$NAME" == "Ubuntu" ]]; then
    echo "Ubuntu detected. Running ubuntu installer..."
    ./installer/ubuntu.sh
    ./installer/linkers.sh
  else
    echo "OS not supported."
  fi
else
  echo "Unable to determine the OS. /etc/os-release not found."
fi
