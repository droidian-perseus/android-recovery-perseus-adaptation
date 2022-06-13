#!/bin/bash

### Dark mode ###
echo ""
echo "Enable dark mode?"
read -p "Answering \"no\" will switch back to light mode. [Y/n] " DARK
if [ "$DARK" == "y" ] || [ "$DARK" == "Y" ]; then
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
else
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
fi

### Automated Waydroid install ###
echo ""
read -p "Install Waydroid? [Y/n] " WAYDROID
if [ "$WAYDROID" == "y" ] || [ "$WAYDROID" == "Y" ]; then
    ### Check network access and update repos    
    wget -q --spider https://1.1.1.1
    if [ $? -eq 0 ]; then
        echo "Updating repos..."
        sudo apt update
    else
       echo "You appear to be offline."
       echo "You should establish an internet connection and try again."
       exit 1
    fi
    sudo apt install curl wget lxc python3 -y
    sudo apt install ca-certificates -y
    export DISTRO="bookworm" && \
    sudo curl -# --proto '=https' --tlsv1.2 -Sf https://repo.waydro.id/waydroid.gpg --output /usr/share/keyrings/waydroid.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/waydroid.gpg] https://repo.waydro.id/ $DISTRO main" > ~/waydroid.list && \
    sudo mv ~/waydroid.list /etc/apt/sources.list.d/waydroid.list && \
    sudo apt update
    sudo apt -y install waydroid
    sudo waydroid init -s GAPPS -c https://waydroid.bardia.tech/OTA/system -v https://waydroid.bardia.tech/OTA/vendor
    sudo systemctl start waydroid-container
    echo ""
    echo "Installed Waydroid."
else
    echo "Skipping Waydroid."
fi
