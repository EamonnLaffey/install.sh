#!/bin/bash

# Pre-req: Must have user account
# $ pacman -S sudo
# $ visudo
# uncomment %wheel ALL=(ALL) ALL
# $ useradd -m -G wheel -s /bin/bash eamonn
# $ passwd eamonn

sudo ln -sf /usr/share/zoneinfo/Australia/Melbourne /etc/localtime
sudo hwclock --systohc
sudo locale-gen

sudo pacman -S --needed base-devel git

if ! hash yay 2>/dev/null; then
    echo "Installing yay"
    cd /tmp || exit
    git clone https://aur.archlinux.org/yay.git
    cd /tmp/yay || exit
    makepkg -si
    rm -rf /tmp/yay
fi

packages=(
    # dev tools
    rustup

    # zsh stuff
    zsh
    zsh-pure-prompt
    zsh-syntax-highlighting

    # vim stuff
    neovim
    vim
    vim-plug

    # cli tools
    exa
    fd
    fzf
    tokei
    ripgrep
    zoxide

    # fonts
    noto-fonts
    noto-fonts-cjk
    ttf-fira-code

    # window stuff
    bspwm
    sxhkd
    polybar
    rofi
    xorg
    xorg-xinit
    xclip

    # general stuff
    networkmanager
    pulseaudio
    ntp
    openssh

    # driver stuff
    intel-ucode
    mesa
    vulkan-radeon
    xf86-video-amdgpu

    # gui apps
    firefox
    code
)

echo "Installing all packages"
yay -S --needed "${packages[@]}"

echo "Installing rust"
rustup install stable

echo "Cloning filetruck"
cd /tmp || exit
git clone https://github.com/EamonnLaffey/filetruck.git
cd /tmp/filetruck || exit
echo "Installing filetruck"
cargo install --path .
export PATH=$PATH:$HOME/.cargo/bin
rm -rf /tmp/filetruck

echo "Cloning dotfiles"
cd /tmp || exit
git clone https://github.com/EamonnLaffey/dotfiles.git
cd /tmp/dotfiles || exit
echo "Dropping off files"
./dropoff_linux.sh
rm -rf /tmp/dotfiles

echo "Sync clock with the netwroks"
sudo ntpd -qg

sudo systemctl enable NetworkManager.service
# use nmcli or nmtui to set network config
