#!/bin/bash -e

# This script is intended to be run by Travis CI. If running elsewhere, invoke
# it with: TRAVIS_PULL_REQUEST=false [path to script]

# shellcheck disable=SC1090
source "$(dirname "$0")"/../scripts/resources.sh

is_pull_request "$0"

echo "Install Bluemix CLI"
curl -L https://clis.ng.bluemix.net/download/bluemix-cli/latest/linux64 > Bluemix_CLI.tar.gz
tar -xvf Bluemix_CLI.tar.gz
sudo ./Bluemix_CLI/install_bluemix_cli

echo "Install kubectl"
curl -LO https://storage.googleapis.com/kubernetes-release/release/"$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)"/bin/linux/amd64/kubectl
chmod 0755 kubectl
sudo mv kubectl /usr/local/bin

echo "Configuring bx to disable version check"
bx config --check-version=false
echo "Checking bx version"
bx --version
echo "Install the Bluemix container-service plugin"
bx plugin install container-service -r Bluemix

if [[ -n "$DEBUG" ]]; then
  bx --version
  bx plugin list
fi
