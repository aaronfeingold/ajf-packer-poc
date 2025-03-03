#!/bin/bash
set -e

# Remove git repositories and temporary files
rm -rf ~/ansible-repo

# Clean package cache to reduce image size
sudo dnf clean all

# Clear bash history
cat /dev/null > ~/.bash_history
history -c

echo "Cleanup complete"
