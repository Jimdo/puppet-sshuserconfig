#!/bin/sh
# Helper script to install a specific version of Puppet
# Usage: puppet-installer.sh <distro name> <Puppet version>

set -e

DISTRO=$1
VERSION=$2

CURRENT=$(apt-cache policy puppet | awk '/Installed:/ {print $2}' 2>/dev/null)
if test "$CURRENT" = "$VERSION"; then
    echo "Puppet version $VERSION already installed."
    exit 0
fi

echo "Removing any Puppet gem installations ..."
sudo gem uninstall -a -x puppet facter 2>/dev/null || true

echo "Installing Puppet version $VERSION ..."
wget -q https://apt.puppetlabs.com/puppetlabs-release-$DISTRO.deb
sudo dpkg -i puppetlabs-release-$DISTRO.deb
sudo apt-get update
sudo apt-get install -y "puppet=$VERSION"
