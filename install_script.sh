#!/bin/bash

if [ -z "$DISPLAY" ]; then
    echo "This script is intended to be run from a desktop terminal."
    exit 1
fi

# Drop sudo cache and ask again to confirm sudo
sudo -K
if ! sudo -v; then
    echo "sudo failed; aborting."
    exit 1
fi

# Use aptitude because apt-get doesn't store which packages are explicitly
# installed.
if ! which aptitude >/dev/null; then
    sudo apt-get install -y aptitude
fi

# Add Dropbox repo
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
echo "deb http://linux.dropbox.com/ubuntu $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/dropbox.list

# Add Chrome repo
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - `: Add repo key`

sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' `: Set Repository`

# Update package information
sudo aptitude update

# Upgrade everything
sudo aptitude full-upgrade -y

# Pre-accept EULAs (find more by debconf-show <package name>)
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula \
    select true | sudo debconf-set-selections

# Install APT packages
sudo aptitude install -y \
    apt-file \
    blueman \
    vim \
    curl \
    dropbox \
    etckeeper	`: track changes to /etc` \
    git git-doc git-gui \
    gitk \
    make \
    openssh-server \
    p7zip-full p7zip-rar \
    python-gpgme `: so Dropbox doesn\'t complain` \
    tree	`: when ls is simply not enough` \
    vlc \
    wine \
    google-chrome-stable \
    wireshark \
    nodejs \
    npm \
    jasmine-node \
    \


# Initialize apt-file's cache
if ! ls /var/cache/apt/apt-file | grep -q .; then
    sudo apt-file update
fi

# Don't hide any autostart items
sudo sed -i -e 's/NoDisplay=true/NoDisplay=false/' \
    /etc/xdg/autostart/*.desktop

# Purge some nonsense
sudo aptitude purge -y \
    unity-webapps-common

# Remove some bad settings
gsettings set com.canonical.Unity.Lenses remote-content-search 'none'
gsettings set com.canonical.unity.webapps integration-allowed false
gsettings set com.canonical.unity.webapps preauthorized-domains "[]"

# Otherwise set up preferred look/feel of desktop
gsettings set com.canonical.indicator.datetime show-date true
gsettings set com.canonical.indicator.datetime show-day true
gsettings set com.canonical.indicator.datetime show-locations true
gsettings set com.canonical.indicator.datetime timezone-name \
    'America/Chicago Omaha'
gsettings set com.canonical.indicator.power show-percentage true
gsettings set com.canonical.indicator.power show-time true
gsettings set com.canonical.unity-greeter play-ready-sound false
gsettings set com.canonical.Unity.Launcher favorites "[ \
    'application://vim.desktop', \
    'application://gnome-terminal.desktop', \
    'application://firefox.desktop', \
    'application://nautilus.desktop', \
    'application://gnome-system-monitor.desktop', \
    'unity://running-apps', \
    'unity://expo-icon', \
    'unity://desktop-icon', \
    'unity://devices']"

gsettings set org.freedesktop.ibus.panel lookup-table-orientation 0
gsettings set org.gnome.DejaDup prompt-check 'disabled'
gsettings set org.gnome.desktop.input-sources sources "[ \
    ('xkb', 'us'), \
    ('ibus', 'pinyin')]"
gsettings set org.gnome.desktop.background color-shading-type 'solid'
gsettings set org.gnome.desktop.background picture-options 'none'
gsettings set org.gnome.desktop.background primary-color '#000000000000'
gsettings set org.gnome.gnome-system-monitor cpu-stacked-area-chart true
gsettings set org.gnome.gnome-system-monitor show-all-fs true
gsettings set org.gnome.gnome-system-monitor show-tree true
gsettings set org.gnome.desktop.media-handling automount false
gsettings set org.gnome.desktop.media-handling automount-open false

# Settings without schema
echo Settings without schema
dconf write /org/compiz/profiles/unity/plugins/unityshell/icon-size 32

echo ################ END ##################
