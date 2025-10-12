#!/bin/bash
set -xeuo pipefail

rpm -qa | sort

rpm -qa 'qemu-user-static*' | xargs dnf remove -y
rpm -qa '*backgrounds*' | xargs dnf remove -y
rpm -qa 'firefox*' | xargs dnf remove -y

rpm -qa | sort

dnf remove -y sway

rpm -qa | sort
