#!/bin/sh

sudo pacman -S --needed base-devel git

if ! command -v yay &> /dev/null
then
    echo "Installing yay"
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si
    rm -rf /tmp/yay
fi

dev_tools=(
    rustup
)

zsh_stuff=(
    zsh
    zsh-pure-prompt
    zsh-syntax-highlighting
)

vim_stuff=(
    neovim
    vim
    vim-plug
)

cli_tools=(
    exa
    fd
    fzf
    tokei
    ripgrep
    zoxide
)

fonts=(
    noto-fonts
    noto-fonts-cjk
    ttf-fira-code
)

window_stuff=(
    bspwm
    sxhkd
    polybar
    rofi
    xorg
    xorg-xinit
)

general_stuff=(
    networkmanager
    pulseaudio
)

driver_stuff=(
    intel-ucode
    mesa
    vulkan-radeon
    xf86-video-amdgpu
)

gui_apps=(
    firefox
    code
)

echo "Installing all packages"
yay -S --needed $dev_tools $zsh_stuff $vim_stuff $cli_tools $fonts $window_stuff $general_stuff $driver_stuff $gui_apps

echo "Installing rust"
rustup install stable

echo "Cloning filetruck"
git clone https://github.com/EamonnLaffey/filetruck.git /tmp/filetruck
cd /tmp/filetruck
echo "Installing filetruck"
cargo install --path .
export PATH=$PATH:$HOME/.cargo/bin

echo "Clone dotfiles"
git clone https://github.com/EamonnLaffey/dotfiles.git /tmp/dotfiles
cd /tmp/dotfiles
echo "Dropping off files"
./dropoff_linux.sh

