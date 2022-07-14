source ./global.sh

PATH="~/Documents/Passwords.kbdx"

print_info "Follow the instructions below to set up the database"

echo -n "Enter the database file name: "
read FILENAME

print_info "Move the file to the following path: /home/$USER/Documents/$FILENAME"

echo "When you're done, press any key to continue..."
enter_to_continue

# TODO define aliases