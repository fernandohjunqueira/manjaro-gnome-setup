source ./global.sh

print_info "Follow the instructions below to set up the database"

echo -n "Enter the database file name: "
read FILENAME

print_info "Move the file to the following path: /home/$USER/Documents/$FILENAME"

echo "When you're done, press any key to continue..."
enter_to_continue

PATH="/home/$USER/Documents/$FILENAME"
ZSHRC="/home/$USER/.zshrc"

echo "# Custom KeePassXC Alias" >> $ZSHRC
echo "alias xcusp=\"keepassxc-cli clip $PATH USP\"" >> $ZSHRC
echo "alias xcgithub=\"keepassxc-cli clip $PATH GitHub\"" >> $ZSHRC

# TODO Add more aliases if needed