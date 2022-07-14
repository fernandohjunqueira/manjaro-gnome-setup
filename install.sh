#!/bin/bash

INSTALL=(
    code
    keepassxc
    neovim
    nodejs
    npm
    obsidian
    tangram
    telegram-desktop
    timeshift
    tmux
)

source ./global.sh

install() {
    for PACKAGE in ${INSTALL[@]}
    do
        is_installed $PACKAGE; 
        if [ $? -ne 0 ]
        then
            sudo pamac install $PACKAGE --no-confirm
            if [ $? -eq 0 ];
            then
                print_success "Installed $PACKAGE."
            else
                print_error "Could not install $PACKAGE."
            fi
            echo
        else
            print_info "$PACKAGE is already installed."
        fi
    done
}

echo
print_step "Installing apps"
install