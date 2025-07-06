#!/bin/bash

# ================================================================= #
#                XYCoolcraft | Tools Performance VPS                #
#                   Versi Diperbaiki & Stabil                     #
# ================================================================= #

# --- Variabel Warna ---
MERAH='\033[0;31m'
HIJAU='\033[0;32m'
COKELAT='\033[0;33m' # Kuning/Cokelat
BIRU='\033[0;34m'
NC='\033[0m' # No Color

# --- Konfigurasi Token ---
TOKEN_BENAR="XAYZCOLD"

# --- Fungsi untuk memastikan skrip dijalankan sebagai root ---
cek_root() {
    # Periksa apakah User ID (EUID) adalah 0 (root)
    if [[ $EUID -ne 0 ]]; then
       echo -e "${MERAH}Error: Skrip ini harus dijalankan sebagai root!${NC}"
       exit 1
    fi
}

# --- Fungsi otentikasi token ---
minta_token() {
    clear
    # Tampilan menggunakan echo dengan heredoc untuk kerapian
    echo -e "${COKELAT}"
cat << "EOF"
||============================================||
||                                            ||
||                                            ||
||     XYCoolcraft | Tools Performance VPS      ||
||                                            ||
||                                            ||
||============================================||
||                                            ||
||         PLEASE ENTER THE TOKEN🔐:          ||
||                                            ||
||============================================||
EOF
    echo -ne "${NC}>> " # -ne agar kursor tetap di baris yang sama
    read -r TOKEN_MASUKAN

    if [ "$TOKEN_MASUKAN" == "$TOKEN_BENAR" ]; then
        clear
        echo -e "${HIJAU}\n###\n/\\ KEY TOKEN SUCCESSFULL✅\n###\n${NC}"
        sleep 2
    else
        clear
        echo -e "${MERAH}\n❌❌❌❌❌❌\n\\/ KEY TOKEN WRONG❌\n❌❌❌❌❌❌\n${NC}"
        exit 1
    fi
}

# --- Fungsi untuk menampilkan logo OS ---
tampilkan_logo_os() {
    local os_id="unknown"
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        os_id=$ID
    fi
    # ASCII art disederhanakan dan diberi warna
    echo -e "${HIJAU}"
    case $os_id in
        ubuntu) echo "Ubuntu" ;;
        debian) echo "Debian" ;;
        centos|rhel|almalinux|rocky) echo "CentOS/RHEL" ;;
        *) echo "OS: $os_id" ;;
    esac
    # Anda bisa menambahkan ASCII art yang lebih kompleks di sini jika mau
    echo -e "${NC}"
}

# --- Fungsi utama untuk menampilkan menu dan memproses pilihan ---
menu_utama() {
    while true; do
        clear
        tampilkan_logo_os
        # Menu menggunakan echo dengan heredoc
        echo -e "${BIRU}"
cat << "MENU"
||==================================================================||
           MENU KIT TOOLS PERFOMANCE VPS
--------------------------------------------------------------------
 1. Update System Operation And Software
 2. Check Version MySQL
 3. Clear Cache (Membersihkan RAM)
 4. Check RAM Usage
 5. Check Disk Usage
 6. Restart Server
 7. Evaluation Performance Disk
 8. Evaluation Performance CPU
 9. Exit
--------------------------------------------------------------------
||==================================================================||
MENU
        echo -e "${NC}"
        read -p "Pilih menu [1-9]: " pilihan

        case $pilihan in
            1) jalankan_perintah "apt-get update && apt-get upgrade -y" ;;
            2) jalankan_perintah "mysql -V || echo 'MySQL client tidak terinstall.'" ;;
            3) jalankan_perintah "sync; echo 3 > /proc/sys/vm/drop_caches" ;;
            4) jalankan_perintah "free -m" ;;
            5) jalankan_perintah "df -h" ;;
            6) jalankan_perintah "reboot" ;;
            7) jalankan_perintah "echo 'Testing disk write speed...'; dd if=/dev/zero of=tmpfile bs=1M count=256 conv=fdatasync; rm -f tmpfile" ;;
            8) jalankan_perintah "echo 'Testing CPU performance...'; dd if=/dev/zero bs=1M count=1024 | md5sum" ;;
            9) echo -e "${HIJAU}Terima kasih telah menggunakan tools ini!${NC}"; exit 0 ;;
            *) echo -e "${MERAH}Pilihan tidak valid!${NC}"; sleep 2 ;;
        esac
    done
}

# --- Fungsi untuk konfirmasi dan menjalankan perintah ---
jalankan_perintah() {
    local PERINTAH_UNTUK_DIJALANKAN="$1"
    read -p "$(echo -e ${COKELAT}Apakah Anda yakin ingin melanjutkan? [y/N]: ${NC})" jawaban
    # Default ke "No" jika pengguna hanya menekan Enter
    if [[ "$jawaban" =~ ^[Yy]$ ]]; then
        echo -e "${HIJAU}--- Menjalankan Perintah ---${NC}"
        eval "$PERINTAH_UNTUK_DIJALANKAN"
        echo -e "${HIJAU}--- Selesai ---${NC}"
        read -p "Tekan Enter untuk kembali ke menu..."
    else
        echo -e "${MERAH}Operasi dibatalkan.${NC}"
        sleep 2
    fi
}


# --- Alur Eksekusi Utama ---
cek_root
minta_token
menu_utama
