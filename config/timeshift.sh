source ./global.sh

print_info "Set up snapshot options on GUI. Close the window when you're done."

# Open GUI to set up snapshot options
sudo timeshift-gtk

# Create first snapshot after closing the GUI
sudo timeshift --create --comment "Initial snapshot"