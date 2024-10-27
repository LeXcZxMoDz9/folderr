#!/bin/bash

ADMIN_WHATSAPP_NUMBER="79105052657"

WHATSAPP_FILE="/var/whatsapp_number.txt"
LICENSE_FILE="/var/license.txt"
ERROR_FILE="/var/error_count.txt"

# Inisialisasi file kesalahan jika tidak ada
if [[ ! -f "$ERROR_FILE" ]]; then
    echo "0" > "$ERROR_FILE"
fi

# Definisi warna untuk tampilan teks
ORANGE='\033[33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# Fungsi untuk menyimpan konfigurasi
save_config() {
    echo "DISABLE_ANIMATIONS=${DISABLE_ANIMATIONS}" > /var/www/pterodactyl/config/installer_config
}

# Fungsi untuk memuat konfigurasi
load_config() {
    if [[ -f /var/www/pterodactyl/config/installer_config ]]; then
        source /var/www/pterodactyl/config/installer_config
    else
        DISABLE_ANIMATIONS=0
    fi
}

# Fungsi untuk menampilkan animasi teks
animate_text() {
    local text="$1"
    for ((i=0; i<${#text}; i++)); do
        printf "%s" "${text:$i:1}"
        sleep 0.03  # Memberikan jeda agar terlihat seperti animasi
    done
    echo ""
}

# Fungsi untuk menampilkan animasi loading
loading_animation() {
    local spinstr='|/-\'
    local i=0
    while [ "$i" -lt 20 ]; do  # Membatasi jumlah iterasi agar tidak infinite
        printf " [%c] Loading..." "${spinstr:i++%${#spinstr}:1}"
        sleep 0.1
        printf "\r"
    done
}

# Mulai script dengan membersihkan terminal
load_config
clear
echo -e "${RED}Starting Installer...${RESET}"

# Menu installer
echo -e "${BLUE}Pilih opsi:${RESET}"
echo -e "1. Install Theme Elysium"
echo -e "2. Install Theme Nebula"
echo -e "3. Install Enigma Premium Theme (enigmarimake)"
echo -e "4. Hapus Semua Theme"
echo -e "7. Matikan semua animasi installer"
echo -e "8. Keluar"
read -p "Pilih Opsi (1-8): " OPTION

# Case untuk setiap opsi
case "$OPTION" in
    1)
        # Menginstal Tema Elysium
        echo "Menginstal Elysium Theme..."
        REPO_URL="https://github.com/LeXcZxMoDz9/folderr.git"
        TEMP_DIR="folderr"

        git clone "$REPO_URL" "$TEMP_DIR" || { echo "Gagal mengkloning repositori."; exit 1; }

        # Menyimpan dan mengekstrak file ZIP
        sudo mv "$TEMP_DIR/ElysiumTheme.zip" /var/www/
        unzip -o /var/www/ElysiumTheme.zip -d /var/www/
        rm -rf "$TEMP_DIR" /var/www/ElysiumTheme.zip
        cd /root
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg || true
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
        sudo apt update
        sudo apt install -y nodejs
        apt install npm -y
        npm i -g yarn
        cd /var/www/pterodactyl
        yarn
        yarn build:production
        php artisan migrate
        php artisan view:clear

        echo "Elysium Theme berhasil diinstal!"
        ;;

    2)
        # Install Nebula Theme
        echo "Menginstal Nebula Theme..."
        cd /var/www/pterodactyl || exit
        if [[ ! -f "blueprint.sh" ]]; then
            echo "Blueprint belum diinstal. Instal dengan memilih opsi 11 terlebih dahulu."
            exit 1
        fi
        REPO_URL="https://github.com/LeXcZxMoDz9/folderr.git"
        git clone "$REPO_URL" || { echo "Gagal mengkloning repositori."; exit 1; }

        # Menyimpan dan mengekstrak file
        sudo mv "folderr/nebulaptero.zip" /var/www/
        unzip -o /var/www/nebulaptero.zip -d /var/www/pterodactyl
        rm -rf folderr nebulaptero.zip

        blueprint -install nebula || { echo "Instalasi Nebula gagal."; exit 1; }
        echo "Nebula Theme berhasil diinstal!"
        ;;

    3)
        # Install Enigma Premium Theme
        echo "Menginstal Enigma Premium Theme..."
        REPO_URL="https://github.com/LeXcZxMoDz9/folderr.git"
        TEMP_DIR="folderr"

        git clone "$REPO_URL" "$TEMP_DIR" || { echo "Gagal mengkloning repositori."; exit 1; }

        # Menyimpan dan mengekstrak file ZIP
        sudo mv "$TEMP_DIR/enigmarimake.zip" /var/www/
        unzip -o /var/www/enigmarimake.zip -d /var/www/
        rm -rf "$TEMP_DIR" /var/www/enigmarimake.zip

        # Menjalankan perintah yang diperlukan
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
        sudo apt-get update
        sudo apt-get install -y nodejs npm zip unzip git curl wget
        npm i -g yarn
        cd /var/www/pterodactyl
        yarn
        npx update-browserslist-db@latest || { echo "Gagal memperbarui browserslist DB."; exit 1; }
        yarn build:production || { echo "Gagal melakukan build produksi."; exit 1; }

        echo "Enigma Premium Theme berhasil diinstal!"
        ;;

    4)
        # Hapus Theme Elysium
        echo "Menghapus Semua Thema..."
        cd /var/www/pterodactyl
        php artisan down
        curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv
        chmod -R 755 storage/* bootstrap/cache
        composer install --no-dev --optimize-autoloader
        php artisan view:clear
        php artisan config:clear
        php artisan migrate --seed --force
        chown -R www-data:www-data /var/www/pterodactyl/*
        php artisan up || { echo "Gagal Menghapus Semua Thema."; exit 1; }
        echo "Semua Thema Berhasil Dihapus!"
        ;;

    7)
        # Mematikan animasi
        DISABLE_ANIMATIONS=1
        save_config
        echo -e "${YELLOW}Semua animasi telah dimatikan.${RESET}"
        ;;

    8)
        # Keluar dari installer
        echo -e "${BLUE}Keluar dari Installer.${RESET}"
        exit 0
        ;;

    *)
        echo -e "${RED}Pilihan tidak valid.${RESET}"
        ;;
esac

animate_text "Proses Selesai."
