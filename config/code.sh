source ./global.sh

print_info "Installing GNOME theme for code"
code --install-extension rafaelmardojai.vscode-gnome-theme
print_success "GNOME theme for code installed"

print_info "1. Enable the GNOME theme on the GUI."
print_info "2. Hide the activity bar at View > Appearance"
print_info "3. Hide menu bar at View > Appearance"

code

echo "When you're done, press any key to continue..."
enter_to_continue