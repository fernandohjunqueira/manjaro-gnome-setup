PAMAC_CONF="/etc/pamac.conf"
PACMAN_CONF="/etc/pacman.conf"
MAX_PARALLEL_DOWNLOADS=5

source ./global.sh

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


echo
print_step "Configuring package manager"


# Enable downloading in parallel for Pacman
enable_pacman "ParallelDownloads"

# Set number of parallel downloads on Pacman
set_number_pacman "ParallelDownloads" $MAX_PARALLEL_DOWNLOADS

if [ $? -eq 0 ]; then
    print_success "Enabled parallel downloads on pacman."
else
    print_error "Failed to enable parallel downloads on pacman."
fi


# Enable AUR in pamac
enable_pamac "EnableAUR"

# Enable checking for updates for AUR packages in pamac
enable_pamac "CheckAURUpdates"

if [ $? -eq 0 ]; then
    print_success "Enabled AUR packages on pamac."
else
    print_error "Failed to enable AUR packages on pamac."
fi


# Set number os maximum parallel downloads
set_number_pamac "MaxParallelDownloads" $MAX_PARALLEL_DOWNLOADS

if [ $? -eq 0 ]; then
    print_success "Enabled parallel downloads on pamac."
else
    print_error "Failed to enable parallel downloads on pamac."
fi