#!/bin/bash
#
# Author: Fernando Henrique
# GitHub: https://github.com/fernandohjunqueira
#
# Usage: $ ./main.sh

source ./global.sh

echo
print_step "Starting execution"

bash ./pamac.sh
bash ./update.sh
bash ./remove.sh
bash ./install.sh

# ---------- INDIVIDUAL CONFIG ---------- #

# Timeshift
echo
print_step "Configure timeshift"
bash ./config/timeshift.sh

# KeePassXC
echo
print_step "Configure keepassxc"
bash ./config/keepassxc.sh

# Code - OSS
echo
print_step "Configure code"
bash ./config/code.sh

# Obsidian
echo
print_step "Configure obsidian"
bash ./config/obsidian.sh


print_success "Done."