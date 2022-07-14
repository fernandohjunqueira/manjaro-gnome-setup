source ./global.sh

# Upgrade the system and the installed packages
echo
print_step "Updating the system and installed packages"
sudo pamac update -a --no-confirm #--force-refresh

if [ $? -eq 0 ]; then
    print_success "System and packages updated."
else
    print_error "Failed to update the system."
fi
