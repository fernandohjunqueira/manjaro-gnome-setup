source ./global.sh

print_instruction "1. Create the vault from Obsidian Sync"
print_instruction "2. Turn all the sync options"
print_instruction "3. Activate the custom theme"
print_instruction "4. Set correct font size"

echo "Close the window when you're done."
obsidian > /dev/null 2>&1

# TODO clone custom theme from GitHub