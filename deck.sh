#!/bin/bash

# Configure passwd
set_passwd() {
  read -s -p "Enter password for user 'deck': " PASSWD
  echo "deck:$PASSWD" | chpasswd
}

# Configure SSH
enable_ssh() {
  sudo systemctl enable sshd
  sudo systemctl start sshd

}

# Configure SSH keys
set_ssh_keys() {
  # Create SSH directory and authorized_keys file
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh
  touch ~/.ssh/authorized_keys
  chmod 600 ~/.ssh/authorized_keys

  # Add GitHub keys
  read -p "Enter your GitHub username: " GITHUB_USERNAME
  curl github.com/"$GITHUB_USERNAME".keys >>~/.ssh/authorized_keys
}

# Install decky dependencies
install_decky_loader() {
  read -p "stable or pre-release? [stable/pre]: " CHANNEL

  if [ "$CHANNEL" == "stable" ]; then
    curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh | sh
  elif [ "$CHANNEL" == "pre" ]; then
    curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_prerelease.sh | sh
  else
    echo "Invalid option. Exiting..."
    exit 1
  fi
}

set_chrome_for_gfn() {
  flatpak --user override --filesystem=/run/udev:ro com.google.chrome
}

set_passwd
set_ssh_keys
enable_ssh
install_decky_loader
set_chrome_for_gfn
