#!/bin/bash

# ================================================================= #
#                XYCoolcraft | Tools Performance VPS                #
#               Versi 6.0 - Integrasi AI & Panel Manager            #
# ================================================================= #

# --- Variabel Warna ---
MERAH='\033[0;31m'
HIJAU='\033[0;32m'
COKELAT='\033[0;33m'
BIRU='\033[0;34m'
NC='\033[0m'

# --- Konfigurasi Token ---
TOKEN_BENAR="XAYZCOLD"

# --- Fungsi Global & Pengecekan Awal (Disederhanakan untuk contoh) ---
# ... (Fungsi cek_root, deteksi_installer, minta_token, dll. dari versi sebelumnya ada di sini) ...
# (Saya akan singkat di sini agar fokus pada fitur baru)

# --- Fungsi Eksekusi Perintah ---
jalankan_perintah() {
    local PERINTAH="$1"
    read -p "$(echo -e ${COKELAT}Apakah Anda yakin? [y/N]: ${NC})" jawaban
    if [[ "$jawaban" =~ ^[Yy]$ ]]; then
        echo -e "${HIJAU}--- Menjalankan Perintah ---${NC}"
        eval "$PERINTAH"
        echo -e "${HIJAU}--- Selesai ---${NC}"
        read -p "Tekan Enter untuk kembali..."
    else
        echo -e "${MERAH}Operasi dibatalkan.${NC}"; sleep 2
    fi
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
--- AI Assistant (ChatGPT) ---
 1. Install & Configure AI (ShellGPT)
 2. Run AI Assistant (ChatGPT)

--- Game Panel Management (Pterodactyl) ---
 3. Install Pterodactyl Panel
 4. Install Pterodactyl Wings
 5. Start Wings Service
 6. View Wings Service Status

--- Real-Time Monitoring ---
 7. View System Monitoring (htop)
 8. System Framework at Work (top)
 9. Real-Time All Systems (glances)
 10. Install Monitoring Tools (htop, glances)

--- System Maintenance ---
 11. Update System
 12. Clear Cache
 13. Check RAM & Disk
 14. Restart Server
 15. Exit
--------------------------------------------------------------------
||==================================================================||
MENU
        echo -e "${NC}"
        read -p "Pilih menu [1-15]: " pilihan

        case $pilihan in
            # --- Bagian AI ---
            1) jalankan_perintah "pip install shell-gpt && sgpt --install-integration" ;;
            2) if command -v sgpt &> /dev/null; then sgpt; else echo -e "${MERAH}AI (sgpt) belum terinstall. Pilih menu 1 terlebih dahulu.${NC}"; sleep 3; fi ;;

            # --- Bagian Panel Pterodactyl ---
            3) jalankan_perintah "bash <(curl -s https://pterodactyl-installer.se/install.sh)" ;;
            4) jalankan_perintah "bash <(curl -s https://pterodactyl-installer.se/wings.sh)" ;;
            5) jalankan_perintah "systemctl start wings" ;;
            6) jalankan_perintah "systemctl status wings" ;;

            # --- Bagian Monitoring & Maintenance (Contoh) ---
            7) if command -v htop &> /dev/null; then htop; else echo -e "${MERAH}htop belum terinstall.${NC}"; sleep 2; fi ;;
            8) top ;;
            9) if command -v glances &> /dev/null; then glances; else echo -e "${MERAH}glances belum terinstall.${NC}"; sleep 2; fi ;;
            10) jalankan_perintah "apt-get install -y htop glances" ;; # Disederhanakan
            11) jalankan_perintah "apt-get update && apt-get upgrade -y" ;;
            12) jalankan_perintah "sync; echo 3 > /proc/sys/vm/drop_caches" ;;
            13) jalankan_perintah "free -m && echo '---' && df -h" ;;
            14) jalankan_perintah "reboot" ;;
            15) echo -e "${HIJAU}Terima kasih!${NC}"; exit 0 ;;
            *) echo -e "${MERAH}Pilihan tidak valid!${NC}"; sleep 2 ;;
        esac
    done
}

# --- Alur Utama ---
# Untuk demonstrasi, kita langsung ke menu
# (Di versi lengkap, panggil cek_root, minta_token, dll. di sini)
menu_utama
