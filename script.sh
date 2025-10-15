#!/bin/bash
set -xeuo pipefail

jq -r .packages[] /usr/share/rpm-ostree/treefile.json > /usr/local/share/packages

rpm -qa | sort

#rpm -qa 'qemu-user-static*' | xargs dnf remove -y

