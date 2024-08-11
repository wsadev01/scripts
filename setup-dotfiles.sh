#!/usr/bin/env bash
#
# Alternative way to install packages, having a .packages and .packages-aur in your home c:
	$(lsusb -v | grep iSerial
aur_packages="../.packages-aur"
packages="../.packages"

git clone git@github.com:wsadev01/dotfiles /tmp/dotfiles
git clone git@github.com:wsadev01/global-dotfiles /tmp/global-dotfiles

rsync -avP /tmp/dotfiles/ /home/$USER/

rsync -avP /tmp/global-dotfiles/ /home/$USER/.config/global-dotfiles

restoration_usb_iserial="E0D55E6CE785E6A0C93500F9"
for device in /dev/sd[a-z]; do
    current_serial=$(udevadm info --query=all --name=$device | grep ID_SERIAL_SHORT | awk '{print $2}' | cut -d '=' -f2-)
    if [ "$current_serial" == "$restoration_usb_iserial" ]; then
        echo "Match found: $device has the serial number $saved_serial"

        break
		fi
done

echo "[+] Setting up YAY"
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si
sudo mv /usr/bin/yay /opt/
sudo ln -s /opt/yay /usr/bin/yay

if [ -f "$packages" ]; then
	echo "[+] Package not found, install them manually..."
	exit 1
fi

xargs -r sudo pacman -Sy --noconfirm < "$packages"

if [ -f "$aur_packages" ]; then
	echo "[+] Packages from AUR were not found, install them manually..."
	exit 1
fi

xargs -r yay -S < "$aur_package"

echo [
bash ~/.config/global-dotfiles/install.sh
