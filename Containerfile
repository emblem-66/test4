FROM quay.io/fedora/fedora-bootc:latest
RUN uname -r \
# && sed -i 's/#AutomaticUpdatePolicy=none/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf \
# && sed -i 's/enabled=1/enabled=0/' \
#    /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:phracek:PyCharm.repo \
#    /etc/yum.repos.d/fedora-cisco-openh264.repo \
#    /etc/yum.repos.d/google-chrome.repo \
#    /etc/yum.repos.d/rpmfusion-nonfree-nvidia-driver.repo \
#    /etc/yum.repos.d/rpmfusion-nonfree-steam.repo \
# && dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
# && echo -e "[Unit]\nDescription=Update Flatpaks\n[Service]\nType=oneshot\nExecStart=/usr/bin/flatpak remote-modify --disable fedora ; /usr/bin/flatpak remote-modify --enable flathub ; /usr/bin/flatpak uninstall --unused -y --noninteractive ; /usr/bin/bash -c 'curl -sSL https://raw.githubusercontent.com/emblem-66/Linux-Stuff/refs/heads/main/flatpak/packages | xargs -r flatpak install -y --noninteractive' ; /usr/bin/bash -c 'cat ~/.flatpak-apps.list | xargs -r flatpak install -y --noninteractive' ; /usr/bin/flatpak update -y --noninteractive\n[Install]\nWantedBy=default.target\n" | tee /etc/systemd/system/flatpak-update.service \
# && echo -e "[Unit]\nDescription=Update Flatpaks\n[Timer]\nOnCalendar=*:0/4\nPersistent=true\n[Install]\nWantedBy=timers.target\n" | tee /etc/systemd/system/flatpak-update.timer \
# && git clone https://github.com/somepaulo/MoreWaita.git /usr/share/icons/MoreWaita/ \
 && dnf clean all \
 && dnf update \
 && dnf install -y dnf5-plugins \
# && dnf install -y rootfiles \
 && dnf group install -y critical-path-base \
 && dnf group install -y critical-path-gnome \
# && dnf group install -y core \
# && dnf group install -y base-graphical  \
# && dnf remove -y \
#    firefox* \
#    gnome-shell-extension* \
#    gnome-tour \
#    yelp* \
#    gnome-software-rpm-ostree \
#    virtualbox-guest-additions \
#    malcontent-control \
#    fedora-chromium-config* \
 && dnf install -y \
#    adw-gtk3-theme \
    tailscale \
    syncthing \
    distrobox \
 && dnf install -y \
    gdm \
    gnome-shell \
    nautilus \
 && dnf install -y langpacks-en firewalld openssh tailscale git curl wget rsync \
 && systemctl set-default graphical.target \
 && systemctl enable \
#    rpm-ostreed-automatic.timer \
#    flatpak-update.timer \
    sshd.service \
    tailscaled.service \
    firewalld.service \
 && systemctl mask remount-fs.service \
 && dnf clean all \
 && rpm-ostree cleanup -m \
 && rm -rf /var/* /tmp/* \
 && ostree container commit \
 && bootc container lint
RUN rpm -qa | sort
