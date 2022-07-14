#!/bin/bash

REMOVE=(
    firefox-gnome-theme-maia
    lollypop
)

source ./global.sh

remove() {
    for PACKAGE in ${REMOVE[@]}
    do
        is_installed $PACKAGE; 
        if [ $? -eq 0 ]
        then
            sudo pamac remove $PACKAGE --no-confirm
            if [ $? -eq 0 ];
            then
                print_success "Removed $PACKAGE."
            else
                print_error "Could not remove $PACKAGE."
            fi
            echo
        else
            print_info "$PACKAGE is not installed."
        fi
    done
}

echo
print_step "Removing unused apps installed by default"
# Remove unused apps installed by default
remove

echo
print_step "Removing orphan packages"
# Remove oprhan packages
sudo pamac remove --orphans --no-confirm

if [ $? -eq 0 ]; then
    print_success "Orphans removed."
fi