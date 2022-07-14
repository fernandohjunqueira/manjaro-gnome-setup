#!/bin/bash
#
# Author: Fernando Henrique
# GitHub: https://github.com/fernandohjunqueira
#
# Usage: $ ./script.sh

# --- VARIABLES --------------------------- #

PAMAC_CONF="/etc/pamac.conf"
PACMAN_CONF="/etc/pacman.conf"
MAX_PARALLEL_DOWNLOADS=5

ZSHRC="/home/$USER/.zshrc"

# Packages installed by default that must be removed
REMOVE=(
    firefox-gnome-theme-maia
    lollypop
)

# Packages to be installed
INSTALL=(
    code
    commit
    #blanket
    #freetube
    gnome-characters
    keepassxc
    neovim
    nodejs
    npm
    obsidian
    #rhythmbox
    speedtest-cli
    #tangram
    telegram-desktop
    timeshift
    #tmux
    ttf-apple-emoji
    #wike
)

# Password aliases for KeePassXC
declare -A ALIASES=(
    ["xcusp"]="USP"
    ["xcgithub"]="GitHub"
)

# ----------------------------------------- #

# --- COLORS AND PRINTING ----------------- #

RED='\e[1;91m'
GREEN='\e[1;92m'
YELLOW='\e[1;93m'
BLUE='\e[1;94m'
MAGENTA='\e[1;95m'
CYAN='\e[1;96m'
NOCOLOR='\e[0m'
STEP_COUNTER=1

print() {
    echo -e $2 "$1"
}

print_success() {
    echo -e "${GREEN}$1${NOCOLOR}"
}

print_error() {
    echo -e "${RED}$1${NOCOLOR}"
}

print_header() {
    echo
    echo -e "${MAGENTA}$1${NOCOLOR}"
}

print_alert() {
    echo -e "${YELLOW}$1${NOCOLOR}"
}

print_instruction() {
    echo -e $2 "${CYAN}Step $STEP_COUNTER: $1${NOCOLOR}"
    STEP_COUNTER=$(($STEP_COUNTER+1))
}

print_result() {
    if [ $? -eq 0 ]; then
        print_success "$1"
    else
        print_error "FAILED: $1"
    fi
}

reset_step_counter(){
    STEP_COUNTER=1
}

# --- PAMAC AND PACMAN -------------------- #

enable_pamac() {
    sudo sed -i "s/#$1/$1/" $PAMAC_CONF
}

enable_pacman() {
    sudo sed -i "s/#$1/$1/" $PACMAN_CONF
}

set_number_pamac() {
    sudo sed -i "s/$1 = [0-9]\+/$1 = $2/" $PAMAC_CONF
}

set_number_pacman() {
    sudo sed -i "s/$1 = [0-9]\+/$1 = $2/" $PACMAN_CONF
}

# --- REMOVE APPS INSTALLED BY DEFAULT ---- #

TO_BE_REMOVED=()

build_to_be_removed() {
    pamac list | awk '{print $1}' > /tmp/installed

    for PACKAGE in ${REMOVE[@]}
    do
        grep -q $PACKAGE /tmp/installed
        if [ $? -eq 0 ]
        then
            TO_BE_REMOVED+=($PACKAGE)
        else
            print "Not installed: $PACKAGE"
        fi
    done
}

remove_installed() {
    if [ ${#TO_BE_REMOVED[@]} -gt 0 ]
    then
        sudo pamac remove ${TO_BE_REMOVED[@]} --no-confirm > /dev/null 2>&1
    else
        print_success "No packages to be removed."
    fi
}

print_removed() {
    pamac list | awk '{print $1}' > /tmp/installed

    for PACKAGE in ${TO_BE_REMOVED[@]}
    do
        grep -q $PACKAGE /tmp/installed
        if [ $? -ne 0 ];
        then
            print_success "Removed $PACKAGE."
        else
            print_error "Failed to remove $PACKAGE."
        fi
    done
}

clean_orphans() {
    sudo pamac remove --orphans --no-confirm > /dev/null 2>&1
    while [ $? -eq 0 ]
    do
        sudo pamac remove --orphans --no-confirm > /dev/null 2>&1
    done
    print_success "Cleaned orphan files."
}

# --- INSTALL APPS ------------------------ #

TO_BE_INSTALLED=()

build_to_be_installed() {
    pamac list | awk '{print $1}' > /tmp/installed

    for PACKAGE in ${INSTALL[@]}
    do
        grep -q $PACKAGE /tmp/installed
        if [ $? -ne 0 ]
        then
            TO_BE_INSTALLED+=($PACKAGE)
        else
            print "Already installed: $PACKAGE"
        fi
    done
}

install_listed() {
    if [ ${#TO_BE_INSTALLED[@]} -gt 0 ]
    then
        sudo pamac install ${TO_BE_INSTALLED[@]} --no-confirm > /dev/null 2>&1
    else
        print_success "No packages to be installed."
    fi
}

print_installed() {
    pamac list | awk '{print $1}' > /tmp/installed

    for PACKAGE in ${TO_BE_INSTALLED[@]}
    do
        grep -q $PACKAGE /tmp/installed
        if [ $? -eq 0 ];
        then
            print_success "Installed $PACKAGE"
        else
            print_error "Failed to install $PACKAGE."
        fi
    done
}

# --- KEEPASSXC --------------------------- #

# Write password aliases to the .zshrc file
write_alias(){
    echo "# Custom KeePassXC Aliases" >> $ZSHRC
    for ALIAS in "${!ALIASES[@]}"
    do 
        echo "alias $ALIAS=\"keepassxc-cli clip $1 ${ALIASES[$ALIAS]}\"" >> $ZSHRC
        print_success "Created alias '$ALIAS' for ${ALIASES[$ALIAS]} password."
    done
}

# ----------------------------------------- #
# --- RUNNING ----------------------------- #
# ----------------------------------------- #

print_header "STARTING SCRIPT"

# --- PAMAC AND PACMAN -------------------- #

print_header "PAMAC AND PACMAN"

# AUR on Pamac
enable_pamac "EnableAUR"
print_result "Enable AUR packages on Pamac"

enable_pamac "CheckAURUpdates"
print_result "Enable checking for AUR updates on Pamac"


# Downloading in parallel
set_number_pamac "MaxParallelDownloads" $MAX_PARALLEL_DOWNLOADS
print_result "Set Pamac's parallel downloads number to $MAX_PARALLEL_DOWNLOADS"

enable_pacman "ParallelDownloads"
print_result "Enable parallel downloads for Pacman"

set_number_pacman "ParallelDownloads" $MAX_PARALLEL_DOWNLOADS
print_result "Set Pacman's parallel downloads number to $MAX_PARALLEL_DOWNLOADS"


# Update repositories
print_alert "Updating the system and installed packages... This may take some minutes."
sudo pamac update -a --no-confirm > /dev/null 2>&1; #--force-refresh
print_result "Update system and apps"

# --- REMOVE APPS INSTALLED BY DEFAULT ---- #

print_header "REMOVING PACKAGES INSTALLED BY DEFAULT"

build_to_be_removed;
remove_installed;
print_removed;
print_alert "Cleaning orphan files... This may take some minutes.";
clean_orphans;

# --- INSTALL APPS ------------------------ #

print_header "INSTALLING PACKAGES"

build_to_be_installed
print_alert "Installing packages... This may take some minutes."
install_listed
print_installed

print_alert "Installing nodemon... This may take some minutes."
sudo npm i -g nodemon > /dev/null 2>&1
print_result "Installed nodemon globally."

# --- FIREFOX THEME ----------------------- #

print_header "CONFIGURING FIREFOX THEME"

git clone https://github.com/rafaelmardojai/firefox-gnome-theme.git > /dev/null 2>&1
rm -rf /home/$USER/.mozilla/firefox/*.default-release/chrome/firefox-gnome-theme
rm -rf /home/$USER/.mozilla/firefox/*.default/chrome/firefox-gnome-theme
./firefox-gnome-theme/scripts/install.sh -t 'Adw-dark' > /dev/null 2>&1
rm -rf firefox-gnome-theme

print_result "Install GNOME Theme for Firefox"

# --- CUSTOM KEYBINDINGS ------------------ #

print_header "SETTING CUSTOM KEYBINDINGS"

# Open gnome-terminal with Ctrl+Alt+T
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Open Terminal';
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'gnome-terminal';
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Control><Alt>T';

print_result "Enable Ctrl+Alt+T to open the terminal."

# TODO: Keybinds to open dashboard apps <Super>Num

# --- COMMIT EDITOR AS DEFAULT ------------ #

print_header "SETTING COMMIT EDITOR AS DEFAULT"

git config --global core.editor "/usr/bin/re.sonny.Commit";

print_result "Commit editor set as default editor by git"

# ----------------------------------------- #
# --- MANUAL SETUP------------------------- #
# ----------------------------------------- #

print_header "STARTING MANUAL SETUP"

echo "Pay attention to the prompt."
echo -e "Follow all the instructions displayed in ${CYAN}cyan${NOCOLOR}."
sleep 5

# --- KERNEL CHOICE ----------------------- #

choose_kernel() {
    print_header "UPDATE KERNEL"
    
    print_instruction "Install the latest kernel"
    print_instruction "When you're done, close the settings window to continue..."
    manjaro-settings-manager > /dev/null 2>&1

    reset_step_counter;
}

#choose_kernel

# --- KEEPASSXC --------------------------- #

setuo_keepassxc() {
    print_header "KEEPASSXC SETUP"

    echo "Follow the instructions below to set up the database"

    print_instruction "Insert the database file name (extension included): "
    read -e FILENAME

    PATH="/home/$USER/Documents/$FILENAME"
    print_instruction "Move the file to the following path: $PATH"

    print_instruction "When you're done, press any key to continue..."
    read -n 1

    write_alias $PATH

    reset_step_counter;
}

#setup_keepassxc;

# --- CODE -------------------------------- #

setup_code() {
    print_header "CODE SETUP"

    print_alert "Installing GNOME theme for code... This may take some time."
    code --install-extension rafaelmardojai.vscode-gnome-theme > /dev/null 2>&1;
    print_success "GNOME theme for code installed."

    print_instruction "Enable the GNOME theme on the GUI."
    print_instruction "Hide the activity bar at View > Appearance"
    print_instruction "Hide menu bar at View > Appearance"

    code;

    print_instruction "When you're done, press any key to continue..."
    read -n 1

    reset_step_counter;
}

#setup_code

# --- TELEGRAM ---------------------------- #

setup_telegram() {
    print_header "CODE SETUP"

    print_instruction "Scan the QR Code"
    print_instruction "Change font-size"
    print_instruction "Configure native notifications"
    print_instruction "Set night mode ON"
    print_instruction "Chose a color theme"

    echo "Close the window when you're done."

    telegram-desktop > /dev/null 2>&1

    print_instruction "When you're done, press any key to continue..."
    read -n 1

    reset_step_counter;
}

#setup_telegram;

# --- OBSIDIAN ---------------------------- #

setup_obsidian() {
    print_header "OBSIDIAN SETUP"

    print_instruction "Create the vault from Obsidian Sync"
    print_instruction "Turn all the sync options"
    print_instruction "Activate the custom theme"
    print_instruction "Set correct font size"

    print_instruction "When you're done, close the Obsidian window to continue..."
    obsidian > /dev/null 2>&1

    # TODO clone custom theme from GitHub

    reset_step_counter;
}

#setup_obsidian;

# --- P10K TERMINAL ----------------------- #

p10k configure;

# --- TIMESHIFT --------------------------- #

setup_timeshift() {
    print_header "TIMESHIFT SETUP"

    print_instruction "Follow the instructions on the GUI to set up the snapshot config file"
    print_instruction "Close the app window after clicking 'Finish' button"

    sudo timeshift-gtk

    # Create first snapshot after closing the GUI
    print_alert "Creating first snapshot... This may take a while."
    sudo timeshift --create --comment "Initial snapshot" > /dev/null 2>&1
    print_result "Snapshot created"
}

#setup_timeshift;

# --- END OF SCRIPT ----------------------- #
print_header "POST-INSTALLATION COMPLETED"