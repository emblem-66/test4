#!/bin/bash
set -xeuo pipefail

rpm -qa |sort

rpm -qa 'qemu-user-static*' | xargs dnf remove -y

rpm -qa '*backgrounds*' | xargs dnf remove -y

dnf remove -y firefox*

dnf remove -y sway

rpm -qa |sort
