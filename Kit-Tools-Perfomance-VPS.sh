#!/bin/bash

# ================================================================= #
#                XYCoolcraft | Tools Performance VPS                #
#                   Versi 9.1 - Dengan Logo OS ASCII                #
# ================================================================= #

# --- Variabel Warna ---
MERAH='\033[0;31m'
HIJAU='\033[0;32m'
COKELAT='\033[0;33m'
BIRU='\033[0;34m'
NC='\033[0m'

# --- Konfigurasi Token ---
TOKEN_BENAR="XAYZCOLD"

# --- Fungsi Global & Pengecekan Awal ---
cek_root() {
    if [[ $EUID -ne 0 ]]; then
       echo -e "${MERAH}Error: Skrip ini harus dijalankan sebagai root!${NC}"; exit 1
    fi
}

deteksi_installer() {
    if command -v apt-get &> /dev/null; then PKG_MANAGER="apt-get";
    elif command -v dnf &> /dev/null; then PKG_MANAGER="dnf";
    elif command -v yum &> /dev/null; then PKG_MANAGER="yum";
    else PKG_MANAGER=""; fi
    if [ -n "$PKG_MANAGER" ]; then INSTALL_CMD="$PKG_MANAGER install -y";
    else INSTALL_CMD=""; fi
}

# --- Fungsi Tampilan & Animasi ---
minta_token() {
    clear; echo -e "${COKELAT}"; cat << "EOF"
||============================================||
||                                            ||
||     XYCoolcraft | Tools Performance VPS    ||
||                                            ||
||============================================||
||         PLEASE ENTER THE TOKEN🔐:          ||
||============================================||
EOF
    echo -ne "${NC}>> "; read -r TOKEN_MASUKAN
    if [ "$TOKEN_MASUKAN" == "$TOKEN_BENAR" ]; then
        clear; echo -e "${HIJAU}\n###\n/\\ KEY TOKEN SUCCESSFULL✅\n###\n${NC}"; sleep 2
    else
        clear; echo -e "${MERAH}\n❌❌❌❌❌❌\n\\/ KEY TOKEN WRONG❌\n❌❌❌❌❌❌\n${NC}"; exit 1
    fi
}

animasi_selesai() {
    local text="PROSES TELAH SELESAI⚡🔥"
    echo ""; for (( i=0; i<${#text}; i++ )); do printf "${HIJAU}%s${NC}" "${text:$i:1}"; sleep 0.1; done; echo ""; sleep 2
}

# FUNGSI BARU (DIKEMBALIKAN) UNTUK MENAMPILKAN LOGO OS
tampilkan_logo_os() {
    local os_id="unknown"
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        os_id=$ID
    fi

    echo -e "${HIJAU}" # Memberi warna hijau pada logo
    case $os_id in
        ubuntu)
            echo '
    _
  / _|
 | |_ ___  _ __ __ _ _ __   __ _
 |  _/ _ \|  __/ _` |  _ \ / _` |
 | || (_) | | | (_| | | | | (_| |
 |_| \___/|_|  \__,_|_| |_|\__,_|
                                '
            ;;
        debian)
            echo '
   _
  / \   _ __  _ __
 / _ \ |  _ \|  _ \
/ ___ \| | | | | | |
\/   \/|_| |_|_| |_|
                   '
            ;;
        centos|rhel|almalinux|rocky)
            echo '
   ____ ____  _   _ ____ _____
  / ___/ ___|| \ | / ___|_   _|
 | |  | |    |  \| \___ \ | |
 | |__| |___ | |\  |___) || |
  \____\____||_| \_|____/ |_|
                             '
            ;;
        *)
            # Fallback jika OS tidak dikenali
            echo "OS: $NAME"
            ;;
    esac
    echo -e "${NC}"
}


# --- Fungsi Eksekusi & Logika ---
jalankan_perintah() {
    local PERINTAH="$1"; read -p "$(echo -e ${COKELAT}Apakah Anda yakin? [y/N]: ${NC})" jawaban
    if [[ "$jawaban" =~ ^[Yy]$ ]]; then
        echo -e "${HIJAU}--- Menjalankan Perintah ---${NC}"; eval "$PERINTAH"; echo -e "${HIJAU}--- Selesai ---${NC}"; read -p "Tekan Enter untuk kembali..."
    else
        echo -e "${MERAH}Operasi dibatalkan.${NC}"; sleep 2
    fi
}

install_package() {
    local package_name="$1"; if command -v "$package_name" &> /dev/null; then echo -e "${HIJAU}'$package_name' sudah terinstall.${NC}"; sleep 2; return; fi
    if [ -z "$INSTALL_CMD" ]; then echo -e "${MERAH}Tidak ditemukan package manager!${NC}"; sleep 3; return; fi
    read -p "$(echo -e ${COKELAT}Install '$package_name'? [y/N]: ${NC})" jawaban
    if [[ "$jawaban" =~ ^[Yy]$ ]]; then
        echo -e "${HIJAU}Memulai instalasi $package_name...${NC}"; eval "$INSTALL_CMD $package_name"
        if [ $? -eq 0 ]; then animasi_selesai; else echo -e "${MERAH}Instalasi gagal!${NC}"; sleep 2; fi
    else
        echo -e "${MERAH}Instalasi dibatalkan.${NC}"; sleep 2
    fi
}

cek_jumlah_server() {
    echo -e "${BIRU}Mengecek jumlah Panel dan Server...${NC}"; local panel_count=0; local server_count=0
    if [ -d "/var/www/pterodactyl" ]; then panel_count=1; fi
    if [ -d "/var/lib/pterodactyl/volumes" ]; then server_count=$(find /var/lib/pterodactyl/volumes/* -maxdepth 0 -type d 2>/dev/null | wc -l); fi
    echo "-----------------------------------------"
    echo -e "${HIJAU}Jumlah Panel Pterodactyl Terdeteksi: $panel_count${NC}"
    echo -e "${HIJAU}Jumlah Server (Wings) Terdeteksi: $server_count${NC}"
    echo "-----------------------------------------"
    read -p "Tekan Enter untuk kembali..."
}


# --- Fungsi Menu Utama ---
menu_utama() {
    while true; do
        clear
        # PERUBAHAN DI SINI: Memanggil fungsi logo OS
        tampilkan_logo_os
        
        echo -e "${BIRU}"
cat << "MENU"
||==================================================================||
           MENU KIT TOOLS PERFOMANCE VPS
--------------------------------------------------------------------
--- Game Panel Management (Pterodactyl) ---
 1. Cek Jumlah Panel & Server Terpasang
 2. Install Pterodactyl Panel
 3. Install Pterodactyl Wings
 4. Uninstall Pterodactyl Panel
 5. Uninstall Pterodactyl Wings
 --- Wings Service Control ---
 6. Start Wings Service
 7. Stop Wings Service
 8. Restart Wings Service
 9. View Wings Service Status

--- AI Assistant (ChatGPT) ---
 10. Install & Configure AI (ShellGPT)
 11. Perbaiki/Update Instalasi AI
 12. Uninstall AI (ShellGPT)
 13. Run AI Assistant (ChatGPT)

--- Real-Time Monitoring & Installers ---
 14. View System Monitoring
 15. System Framework at Work
 16. Real-Time All Systems
 17. Install Monitoring Tools

--- System Maintenance ---
 18. Update Package Lists
 19. Upgrade System Software
 20. Check MySQL Version
 21. Clear Cache
 22. Check RAM & Disk
 23. Evaluation Perfomance Disk
 24. Evaluation Perfomance CPU
 25. Restart Server
 26. Exit
--------------------------------------------------------------------
||==================================================================||
MENU
        echo -e "${NC}"
        read -p "Pilih menu [1-26]: " pilihan

        case $pilihan in
            1) cek_jumlah_server ;;
            2) jalankan_perintah "bash <(curl -s https://pterodactyl-installer.se/install.sh)" ;;
            3) jalankan_perintah "bash <(curl -s https://pterodactyl-installer.se/wings.sh)" ;;
            4) jalankan_perintah "bash <(curl -s https://pterodactyl-installer.se/uninstall-panel.sh)" ;;
            5) jalankan_perintah "bash <(curl -s https://pterodactyl-installer.se/uninstall-wings.sh)" ;;
            6) jalankan_perintah "systemctl start wings" ;;
            7) jalankan_perintah "systemctl stop wings" ;;
            8) jalankan_perintah "systemctl restart wings" ;;
            9) jalankan_perintah "systemctl status wings" ;;
            10) jalankan_perintah "apt-get install -y python3-pip && pip install shell-gpt && sgpt --install-integration" ;;
            11) jalankan_perintah "pip uninstall -y shell-gpt && pip install shell-gpt 'cachetools<5.0.0'" && animasi_selesai ;;
            12) jalankan_perintah "pip uninstall -y shell-gpt && rm -rf ~/.config/shell_gpt" ;;
            13) if command -v sgpt &> /dev/null; then sgpt; else echo -e "${MERAH}AI (sgpt) belum terinstall. Pilih menu 10.${NC}"; sleep 3; fi ;;
            14) if command -v htop &> /dev/null; then htop; else echo -e "${MERAH}htop belum terinstall.${NC}"; sleep 2; fi ;;
            15) top ;;
            16) if command -v glances &> /dev/null; then glances; else echo -e "${MERAH}glances belum terinstall.${NC}"; sleep 2; fi ;;
            17) install_package "htop glances" ;;
            18) jalankan_perintah "$PKG_MANAGER update" ;;
            19) jalankan_perintah "$PKG_MANAGER upgrade -y" ;;
            20) jalankan_perintah "mysql -V || echo 'MySQL client tidak terinstall.'" ;;
            21) jalankan_perintah "sync; echo 3 > /proc/sys/vm/drop_caches" ;;
            22) jalankan_perintah "free -m && echo '---' && df -h" ;;
            23) jalankan_perintah "echo '--> Disk Performance Test <--'; dd if=/dev/zero of=tmpfile bs=1M count=128 conv=fdatasync; rm -f tmpfile" ;;
            24) jalankan_perintah "echo '--> CPU Performance Test <--'; dd if=/dev/zero bs=1M count=256 | md5sum" ;;
            25) jalankan_perintah "reboot" ;;
            26) echo -e "${HIJAU}Terima kasih!${NC}"; exit 0 ;;
            *) echo -e "${MERAH}Pilihan tidak valid!${NC}"; sleep 2 ;;
        esac
    done
}


# ================================================================= #
# ---                         ALUR UTAMA                          ---
# ================================================================= #
cek_root
deteksi_installer
minta_token
menu_utama
