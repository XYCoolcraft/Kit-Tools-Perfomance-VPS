#!/bin/bash

# ================================================================= #
#                XYCoolcraft | Tools Performance VPS                #
#                   Versi 5.0 - Tanpa Efek Spinner                  #
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
    echo ""
    for (( i=0; i<${#text}; i++ )); do
        printf "${HIJAU}%s${NC}" "${text:$i:1}"
        sleep 0.1
    done
    echo ""; sleep 2
}

# --- Fungsi Eksekusi Perintah ---
# Satu fungsi untuk semua jenis perintah yang butuh konfirmasi
jalankan_perintah() {
    local PERINTAH="$1"
    read -p "$(echo -e ${COKELAT}Apakah Anda yakin? [y/N]: ${NC})" jawaban
    if [[ "$jawaban" =~ ^[Yy]$ ]]; then
        echo -e "${HIJAU}--- Menjalankan Perintah ---${NC}"
        eval "$PERINTAH" # Jalankan dan tampilkan output langsung
        echo -e "${HIJAU}--- Selesai ---${NC}"
        read -p "Tekan Enter untuk kembali..."
    else
        echo -e "${MERAH}Operasi dibatalkan.${NC}"; sleep 2
    fi
}

install_package() {
    local package_name="$1"
    if command -v "$package_name" &> /dev/null; then
        echo -e "${HIJAU}'$package_name' sudah terinstall.${NC}"; sleep 2; return
    fi
    if [ -z "$INSTALL_CMD" ]; then
        echo -e "${MERAH}Tidak ditemukan package manager (apt/dnf/yum)!${NC}"; sleep 3; return
    fi

    read -p "$(echo -e ${COKELAT}Install '$package_name'? [y/N]: ${NC})" jawaban
    if [[ "$jawaban" =~ ^[Yy]$ ]]; then
        echo -e "${HIJAU}Memulai instalasi $package_name...${NC}"
        eval "$INSTALL_CMD $package_name"
        if [ $? -eq 0 ]; then
            animasi_selesai
        else
            echo -e "${MERAH}Instalasi gagal!${NC}"; sleep 2
        fi
    else
        echo -e "${MERAH}Instalasi dibatalkan.${NC}"; sleep 2
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
--- Real-Time Monitoring ---
 1. View System Monitoring
 2. System Framework at Work
 3. Real-Time All Systems

--- System Maintenance ---
 4. Update System Operation And Software
 5. Clear Cache (Recommended to eliminate Lag on VPS)
 6. Check RAM & Disk Usage
 7. Evaluation Performance Disk & CPU
 8. Restart Server

--- Installers ---
 9. Install Monitoring
 10. Install Gear Monitoring
 11. Exit
--------------------------------------------------------------------
||==================================================================||
MENU
        echo -e "${NC}"
        read -p "Pilih menu [1-11]: " pilihan

        case $pilihan in
            1) if command -v htop &> /dev/null; then htop; else clear; echo -e "${MERAH}====================================================\nANDA BELUM MENGINSTALL PLUGIN 'HTOP'!!!\nHARAP INSTALL TERLEBIH DAHULU DARI MENU 9!!...\n====================================================${NC}"; sleep 4; fi ;;
            2) top ;;
            3) if command -v glances &> /dev/null; then glances; else clear; echo -e "${MERAH}========================================================\nANDA BELUM MENGINSTALL PLUGIN 'GLANCES'!!!\nHARAP INSTALL TERLEBIH DAHULU DARI MENU 10!!...\n========================================================${NC}"; sleep 4; fi ;;
            
            # Semua perintah di bawah ini sekarang menggunakan 'jalankan_perintah'
            4) jalankan_perintah "apt-get update && apt-get -y upgrade || $INSTALL_CMD update -y" ;;
            5) jalankan_perintah "sync; echo 3 > /proc/sys/vm/drop_caches" ;;
            6) jalankan_perintah "free -m && echo '---' && df -h" ;;
            7) jalankan_perintah "dd if=/dev/zero of=tmpfile bs=1M count=128 conv=fdatasync; rm -f tmpfile && dd if=/dev/zero bs=1M count=256 | md5sum" ;;
            8) jalankan_perintah "reboot" ;;

            9) install_package "htop" ;;
            10) install_package "glances" ;;
            
            11) echo -e "${HIJAU}Terima kasih!${NC}"; exit 0 ;;
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
