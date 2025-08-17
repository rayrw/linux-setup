#!/bin/bash

gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface clock-format 24h
gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Alt>m']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-group "['<Alt>Tab']"
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:ctrl_shifted_capslock']"
gsettings set org.gnome.desktop.peripherals.mouse speed -0.50427350427350426
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click false
gsettings set org.gnome.mutter.keybindings toggle-tiled-left "['<Alt>h']"
gsettings set org.gnome.mutter.keybindings toggle-tiled-right "['<Alt>l']"
gsettings set org.gnome.shell.keybindings switch-to-application-1 "['<Alt>a']"
gsettings set org.gnome.shell.keybindings switch-to-application-2 "['<Alt>s']"
gsettings set org.gnome.shell.keybindings switch-to-application-3 "['<Alt>d']"
gsettings set org.gnome.shell.keybindings switch-to-application-4 "['<Alt>f']"
gsettings set org.gnome.shell.keybindings toggle-message-tray "['<Super>m']"

flatpak install flathub app.zen_browser.zen
flatpak install flathub org.mozilla.Thunderbird

# Ref: https://rpmfusion.org/Configuration
# Ref: https://rpmfusion.org/Howto/Multimedia
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
sudo dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf install -y intel-media-driver
sudo dnf install -y rpmfusion-nonfree-release-tainted
sudo dnf --repo=rpmfusion-nonfree-tainted install -y "*-firmware"

if [ ! -f ~/.local/share/fonts/HackNerdFontMono-Regular.ttf ]; then
  # Ref: https://blog.khmersite.net/p/installing-nerd-font-on-fedora/
  curl -o /tmp/Hack.zip -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip
  unzip /tmp/Hack.zip -d ~/.local/share/fonts/
  fc-cache -vf ~/.local/share/fonts/
fi

if [ ! -f ~/.zshrc ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  sudo dnf install -y zsh
  echo 'alias vi=nvim' >>~/.zshrc
fi

sudo dnf install -y alacritty
sudo dnf install -y neovim
sudo dnf install -y stow

if [ ! -d ~/.tmux/plugins/tmux-resurrect ]; then
  mkdir -p ~/.tmux/plugins
  git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/plugins/tmux-resurrect
fi

if [ ! -d ~/Developer/rayrw/dotfiles ]; then
  mkdir -p ~/Developer/rayrw
  git clone https://github.com/rayrw/dotfiles.git ~/Developer/rayrw/dotfiles
  pushd ~/Developer/rayrw/dotfiles
  stow . -t ~
  popd
fi

gsettings set org.gnome.shell favorite-apps "['app.zen_browser.zen.desktop', 'org.mozilla.Thunderbird.desktop', 'Alacritty.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop', 'org.gnome.Calendar.desktop', 'org.gnome.TextEditor.desktop', 'org.gnome.Calculator.desktop']"
