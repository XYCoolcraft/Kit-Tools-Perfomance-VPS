#!/bin/bash

# ================================================================= #
#                XYCoolcraft | Tools Performance VPS                #
#               Versi 7.0 - Final dengan Semua Fitur                #
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
    if command -v apt-get &> /dev/null; then
        INSTALL_CMD="apt-get install -y"
    elif command -v dnf &> /dev/null; then
        INSTALL_CMD="dnf install -y"
    elif command -v yum &> /dev/null; then
        INSTALL_CMD="yum install -y"
    else
        INSTALL_CMD=""
    fi
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
    local text="INSTALL TELAH SELESAI⚡🔥"
    echo ""; for (( i=0; i<${#text}; i++ )); do printf "${HIJAU}%s${NC}" "${text:$i:1}"; sleep 0.1; done; echo ""; sleep 2
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

# Fungsi BARU untuk mengecek jumlah server
cek_jumlah_server() {
    echo -e "${BIRU}Mengecek jumlah Panel dan Server...${NC}"
    local panel_count=0
    local server_count=0
    # Cek Pterodactyl Panel
    if [ -d "/var/www/pterodactyl" ]; then
        panel_count=1
    fi
    # Cek server di dalam Wings
    if [ -d "/var/lib/pterodactyl/volumes" ]; then
        # Menghitung jumlah direktori di dalam folder volumes
        server_count=$(find /var/lib/pterodactyl/volumes/* -maxdepth 0 -type d 2>/dev/null | wc -l)
    fi
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
        echo -e "${HIJAU}OS: $(. /etc/os-release && echo $NAME)${NC}"
        echo -e "${BIRU}"
cat << "MENU"
||==================================================================||
           MENU KIT TOOLS PERFOMANCE VPS
--------------------------------------------------------------------
--- Panel Management (Pterodactyl) ---
 1. Cek Jumlah Panel & Server Terpasang
 2. Install Pterodactyl Panel
 3. Install Pterodactyl Wings
 4. Start/Status Wings Service

--- AI Assistant (ChatGPT) ---
 5. Install & Configure AI (ShellGPT)
 6. Run AI Assistant (ChatGPT)

--- Real-Time Monitoring ---
 7. View System Monitoring
 8. System Framework at Work
 9. Real-Time All Systems
 10. Install Monitoring Tools

--- System Maintenance ---
 11. Update System & Software
 12. Check MySQL Version
 13. Clear Cache
 14. Check RAM & Disk
 15. Restart Server
 16. Exit
--------------------------------------------------------------------
||==================================================================||
MENU
        echo -e "${NC}"
        read -p "Pilih menu [1-16]: " pilihan

        case $pilihan in
            # --- Panel ---
            1) cek_jumlah_server ;;
            2) jalankan_perintah "bash <(curl -s https://pterodactyl-installer.se/install.sh)" ;;
            3) jalankan_perintah "bash <(curl -s https://pterodactyl-installer.se/wings.sh)" ;;
            4) jalankan_perintah "systemctl status wings || systemctl start wings" ;;

            # --- AI ---
            5) jalankan_perintah "apt-get install -y python3-pip && pip install shell-gpt && sgpt --install-integration" ;;
            6) if command -v sgpt &> /dev/null; then sgpt; else echo -e "${MERAH}AI (sgpt) belum terinstall. Pilih menu 5.${NC}"; sleep 3; fi ;;

            # --- Monitoring ---
            7) if command -v htop &> /dev/null; then htop; else echo -e "${MERAH}htop belum terinstall.${NC}"; sleep 2; fi ;;
            8) top ;;
            9) if command -v glances &> /dev/null; then glances; else echo -e "${MERAH}glances belum terinstall.${NC}"; sleep 2; fi ;;
            10) install_package "htop glances" ;;

            # --- Maintenance ---
            11) jalankan_perintah "apt-get update && apt-get -y upgrade || $INSTALL_CMD update -y" ;;
            12) jalankan_perintah "mysql -V || echo 'MySQL client tidak terinstall.'" ;;
            13) jalankan_perintah "sync; echo 3 > /proc/sys/vm/drop_caches" ;;
            14) jalankan_perintah "free -m && echo '---' && df -h" ;;
            15) jalankan_perintah "reboot" ;;
            16) echo -e "${HIJAU}Terima kasih!${NC}"; exit 0 ;;
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
