#!/bin/bash

set -e

echo "Welcome to the Provisioner Demo!" | sudo tee /tmp/welcome.txt
uname -a | sudo tee -a /tmp/welcome.txt
cat /tmp/welcome.txt