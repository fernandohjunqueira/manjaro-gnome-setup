source ./global.sh

print_info "Follow the instructions below to set up the database"

print_instruction "1. Enter the database file name: " -n
read FILENAME

print_instruction "2. Move the file to the following path: /home/$USER/Documents/$FILENAME"

echo "Press any key when you're done..."
enter_to_continue

PATH="/home/$USER/Documents/$FILENAME"
ZSHRC="/home/$USER/.zshrc"

echo "# Custom KeePassXC Alias" >> $ZSHRC
echo "alias xcusp=\"keepassxc-cli clip $PATH USP\"" >> $ZSHRC
echo "alias xcgithub=\"keepassxc-cli clip $PATH GitHub\"" >> $ZSHRC

# TODO Add more aliases if needed