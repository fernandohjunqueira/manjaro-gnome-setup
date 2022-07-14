# ---------- COLORS ---------- #

RED='\e[1;91m'
GREEN='\e[1;92m'
YELLOW='\e[1;93m'
BLUE='\e[1;94m'
MAGENTA='\e[1;95m'
CYAN='\e[1;96m'
NOCOLOR='\e[0m'

print_step() {
    echo -e "${MAGENTA}$1${NOCOLOR}"
}

print_success() {
    echo -e "${GREEN}$1${NOCOLOR}"
}

print_info() {
    echo -e "${YELLOW}$1${NOCOLOR}"
}

print_error() {
    echo -e "${RED}$1${NOCOLOR}"
}

is_installed() {
    pamac list | awk '{print $1}' | grep -q $1
}

enter_to_continue() {
    read -n 1
}