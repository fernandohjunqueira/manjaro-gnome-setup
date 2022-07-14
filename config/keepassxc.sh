source ./global.sh

print_info "Follow the instructions below to set up the database"

print_instruction "1. Enter the database file name: " -n
read FILENAME

print_instruction "2. Move the file to the following path: /home/$USER/Documents/$FILENAME"

echo "Press any key when you're done..."
enter_to_continue

PATH="/home/$USER/Documents/$FILENAME"
ZSHRC="/home/$USER/.zshrc"

declare -A ALIASES=(
    ["xcusp"]="USP"
    ["xcgithub"]="GitHub"
)

echo "# Custom KeePassXC Alias" >> $ZSHRC

for ALIAS in "${!ALIASES[@]}"
do 
    echo "alias $ALIAS=\"keepassxc-cli clip $PATH ${ALIASES[$ALIAS]}\"" >> $ZSHRC
    print_success "Created alias '$ALIAS' for ${ALIASES[$ALIAS]} password."
done