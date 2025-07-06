#!/bin/bash

# ================================================================= #
#                XYCoolcraft | Tools Performance VPS                #
# ================================================================= #

# --- Variabel Warna ---
# Variabel ini digunakan untuk memberi warna pada output teks.
MERAH='\033[0;31m'
HIJAU='\033[0;32m'
COKELAT='\033[0;33m' # Menggunakan warna Kuning yang lebih umum didukung
BIRU='\033[0;34m'
NC='\033[0m' # No Color (untuk mereset warna ke default)

# --- Konfigurasi Token ---
# Ganti "XAYZCOLD" dengan token rahasia yang Anda inginkan.
TOKEN_BENAR="XAYZCOLD"

# --- Fungsi untuk meminta konfirmasi dari pengguna ---
# Fungsi ini akan menampilkan pesan dan menunggu jawaban Y/N.
# Mengembalikan status 'true' (0) jika jawaban "yes" dan 'false' (1) jika "no".
konfirmasi_aksi() {
    local pesan_prompt="$1"
    while true; do
        read -p "$(echo -e ${BIRU}"$pesan_prompt [ (Y)es / (N)o ]: "${NC})" jawaban
        case $jawaban in
            [Yy]* | [Yy][Ee][Ss] ) return 0;; # Jika input Y, y, Yes, yes, dll.
            [Nn]* | [Nn][Oo]     ) return 1;; # Jika input N, n, No, no, dll.
            * ) echo "Input tidak valid. Silakan jawab 'yes' atau 'no'.";;
        esac
    done
}

# --- Fungsi untuk menampilkan layar otentikasi token ---
# Fungsi ini bertanggung jawab untuk tampilan awal dan validasi token.
minta_token() {
    clear
    echo -e "${COKELAT}"
    echo "||============================================||"
    echo "||                                            ||"
    echo "||                                            ||" 
    echo "||                                            ||"
    echo "||     XYCoolcraft | Tools Performance VPS      ||"
    echo "||                                            ||"
    echo "||                                            ||"
    echo "||                                            ||"
    echo "||============================================||"
    echo "||                                            ||"
    echo "||                                            ||"
    echo "||         PLEASE ENTER THE TOKEN🔐:          ||"
    echo "||                                            ||"
    echo "||                                            ||"
    echo "||============================================||${NC}"
    read -p ">> " TOKEN_MASUKAN

    # Memeriksa apakah token yang dimasukkan benar
    if [ "$TOKEN_MASUKAN" == "$TOKEN_BENAR" ]; then
        clear
        echo -e "${HIJAU}"
        echo "###"
        echo "/\\ KEY TOKEN SUCCESSFULL✅"
        echo "###${NC}"
        sleep 2 # Jeda 2 detik agar pesan bisa dibaca
    else
        clear
        echo -e "${MERAH}"
        echo "❌❌❌❌❌❌"
        echo "\\/ KEY TOKEN WRONG❌"
        echo "❌❌❌❌❌❌${NC}"
        exit 1 # Keluar dari skrip jika token salah
    fi
}

# --- Fungsi untuk mendeteksi OS dan menampilkan logo ASCII ---
# Mendeteksi OS dari file /etc/os-release dan menampilkan logo yang sesuai.
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
            echo "OS Terdeteksi: $os_id"
            ;;
    esac
    echo -e "${NC}"
    echo
}


# --- Fungsi untuk menampilkan menu utama ---
# Membersihkan layar dan menampilkan semua opsi yang tersedia.
tampilkan_menu() {
    clear
    tampilkan_logo_os
    echo -e "${BIRU}"
    echo "||==================================================================||"
    echo ""
    echo "           MENU KIT TOOLS PERFOMANCE VPS"
    echo "--------------------------------------------------------------------"
    echo " 1. Update System Operation And Software"
    echo " 2. Check Version MySQL"
    echo " 3. Clear Cache (Membersihkan RAM)"
    echo " 4. Check RAM Usage"
    echo " 5. Check Disk Usage"
    echo " 6. Restart Server"
    echo " 7. Evaluation Performance Disk"
    echo " 8. Evaluation Performance CPU"
    echo " 9. Exit"
    echo "--------------------------------------------------------------------"
    echo "||==================================================================||${NC}"
}

# --- Pengecekan Hak Akses Root ---
# Beberapa perintah memerlukan akses root, jadi skrip akan berhenti jika tidak dijalankan sebagai root.
if [[ $EUID -ne 0 ]]; then
   echo -e "${MERAH}Error: Skrip ini harus dijalankan sebagai root!${NC}"
   exit 1
fi

# --- Alur Utama Skrip ---
# 1. Jalankan fungsi otentikasi token terlebih dahulu.
minta_token

# 2. Masuk ke loop menu utama yang akan terus berjalan sampai pengguna memilih 'Exit'.
while true; do
    tampilkan_menu
    read -p "Pilih menu [1-9]: " pilihan

    # Menangani jika pengguna hanya menekan Enter tanpa memilih.
    if [ -z "$pilihan" ]; then
        echo -e "${MERAH}Pilihan tidak boleh kosong! Kembali ke menu...${NC}"
        sleep 2
        continue
    fi

    # Menentukan perintah yang akan dijalankan berdasarkan pilihan.
    case $pilihan in
        1) CMD="apt-get update && apt-get upgrade -y" ;;
        2) CMD="mysql -V" ;; # -V (kapital) adalah flag yang benar untuk versi
        3) CMD="sync; echo 3 > /proc/sys/vm/drop_caches" ;;
        4) CMD="free -m" ;;
        5) CMD="df -h" ;;
        6) CMD="reboot" ;;
        7) CMD="echo 'Testing disk write speed...'; dd if=/dev/zero of=tmpfile bs=1M count=512 conv=fdatasync; rm -f tmpfile" ;;
        8) CMD="echo 'Testing CPU performance...'; dd if=/dev/zero bs=1M count=1024 | md5sum" ;;
        9) echo -e "${HIJAU}Terima kasih telah menggunakan tools ini!${NC}"; exit 0 ;;
        *)
            echo -e "${MERAH}Pilihan tidak valid!${NC}"
            sleep 2
            continue # Kembali ke awal loop jika pilihan salah
            ;;
    esac

    # Meminta konfirmasi sebelum menjalankan perintah
    if konfirmasi_aksi "Apakah Anda yakin ingin melanjutkan?"; then
        echo -e "${HIJAU}--- Menjalankan Perintah ---${NC}"
        # Menjalankan perintah yang sudah dipilih
        eval $CMD
        echo -e "${HIJAU}--- Selesai ---${NC}"
        echo "Tekan Enter untuk kembali ke menu..."
        read # Menunggu pengguna menekan Enter sebelum menampilkan menu lagi
    else
        echo -e "${COKELAT}Operasi dibatalkan. Kembali ke menu...${NC}"
        sleep 2
    fi
done
