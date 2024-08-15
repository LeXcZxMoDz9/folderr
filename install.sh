#!/bin/bash

# Inisialisasi file kesalahan jika tidak ada
if [[ ! -f "$ERROR_FILE" ]]; then
    echo "0" > "$ERROR_FILE"
fi

# Tampilkan teks setelah loading selesai
display_text
# Definisi warna untuk tampilan teks
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RESET='\033[0m'  # Reset warna teks ke default

# Fungsi untuk menyimpan konfigurasi
save_config() {
    echo "DISABLE_ANIMATIONS=${DISABLE_ANIMATIONS}" > /var/www/pterodactyl/config/installer_config
}

# Fungsi untuk memuat konfigurasi
load_config() {
    if [ -f /var/www/pterodactyl/config/installer_config ]; then
        source /var/www/pterodactyl/config/installer_config
    else
        DISABLE_ANIMATIONS=0
    fi
}

# Fungsi untuk menampilkan teks dengan atau tanpa animasi
animate_text() {
    local text="$1"
    if [ "$DISABLE_ANIMATIONS" -eq 1 ]; then
        echo "$text"
    else
        for ((i=0; i<${#text}; i++)); do
            echo -en "${text:$i:1}"
            sleep 0.05
        done
        echo ""
    fi
}

# Memuat konfigurasi
load_config

#!/bin/bash

# Fungsi untuk menampilkan animasi loading
loading_animation() {
    local delay=0.1
    local spinstr='|/-\'
    local loading_text="LOADING..."
    local i=0
    while [ $i -lt ${#loading_text} ]; do
        local temp=${spinstr#?}
        printf " [%c] %s" "$spinstr" "${loading_text:0:i+1}"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\r"
        i=$((i + 1))
    done
    sleep 0.05
    printf "\r\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
}

# Fungsi untuk menampilkan teks animasi
animate_text() {
    local text=$1
    for ((i=0; i<${#text}; i++)); do
        printf "%s" "${text:$i:1}"
        sleep 0.05
    done
    echo ""
}

# Menampilkan teks dengan animasi
animate_text "LICENSE ANDA BENAR, TERIMAKASIH TELAH MEMBELI INSTALLER INI,"
animate_text "OPSI ADA DIBAWAH INI"

# Animasi loading dan menghapus
loading_animation
echo -ne "\033[K"  # Menghapus teks loading dari baris
sleep 0.05

# Menampilkan opsi tanpa animasi
echo "1. INSTALL THEME ELYSIUM"
echo "2. INSTALL ADDON AUTO SUSPEND PTERODACTYL"
echo "3. INSTALL NEBULA THEME" 
echo "4. UBAH BACKROUND PTERODACTYL"
echo "5. INSTALL GOOGLE ANALITIC PTERODACTYL"
echo "6. ADMIN PANEL THEME PTERODACTYL"
echo "7. ENIGMA PREMIUM PTERODACTYL"
echo "8. HAPUS BACKROUND PTERODACTYL"
echo "9. HAPUS THEME/ADDON"
echo "10. MATIKAN SEMUA ANIMASI INSTALLER"
echo "11. KELUAR DARI INSTALLER"
read -p "PILIH OPSI (1-11): " OPTION
case "$OPTION" in
    1)
        # Masukkan token GitHub langsung di sini
        GITHUB_TOKEN="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"

        # Clone repositori menggunakan token
        REPO_URL="https://${GITHUB_TOKEN}@github.com/LeXcZxMoDz9/folderr.git"
        TEMP_DIR="folderr"

        # Mengkloning repositori
        git clone "$REPO_URL"

        sudo mv "$TEMP_DIR/ElysiumTheme.zip" /var/www/

        # Mengekstrak file ZIP dengan opsi untuk menggantikan file tanpa konfirmasi
        unzip -o /var/www/ElysiumTheme.zip -d /var/www/
        rm -r folderr
        rm /var/www/ElysiumTheme.zip
        
        # Menjalankan perintah
        sudo mkdir -p /etc/apt/keyrings

        # Menyimpan output dan tidak meminta konfirmasi
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg || true

        # Menambahkan repository
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

        # Update dan install nodejs
        sudo apt update
        sudo apt install -y nodejs
        apt install npm
        npm i -g yarn
        cd /var/www/pterodactyl
        yarn
        yarn build:production
        php artisan migrate
        php artisan view:clear
        animate_text "Tema Elysium berhasil diinstal."

        # Ganti dengan token dan URL file
        FILE_URL="https://raw.githubusercontent.com/LeXcZxMoDz9/folderr/main/ElysiumTheme.zip"
        DESTINATION="/var/www/pterodactyl/ElysiumTheme.zip"

        # Mengunduh file dengan token
        curl -L -o "${DESTINATION}" "${FILE_URL}"

        # Informasi hasil
        if [ $? -eq 0 ]; then
            animate_text "File berhasil diunduh ke ${DESTINATION}"
        else
            animate_text "Gagal mengunduh file"
        fi
        ;;
    2)
        # Masukkan token GitHub langsung di sini
        GITHUB_TOKEN="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"

        # Clone repositori menggunakan token
        REPO_URL="https://${GITHUB_TOKEN}@github.com/LeXcZxMoDz9/folderr.git"
        TEMP_DIR="folderr"

        # Mengkloning repositori
        git clone "$REPO_URL"

        sudo mv "$TEMP_DIR/autosuspens.zip" /var/www/

        # Mengekstrak file ZIP dengan opsi untuk menggantikan file tanpa konfirmasi
        unzip -o /var/www/autosuspens.zip -d /var/www/
        rm -r folderr
        rm /var/www/autosuspens.zip
        
        cd /var/www/pterodactyl
        bash installer.bash

        animate_text "AUTO SUSPEND BERHASIL DIINSTALL"

        # Ganti dengan token dan URL file
        FILE_URL="https://raw.githubusercontent.com/LeXcZxMoDz9/folderr/main/autosuspens.zip"
        DESTINATION="/var/www/pterodactyl/autosuspens.zip"

        # Mengunduh file dengan token
        curl -H "Authorization: token ${GITHUB_TOKEN}" -L -o "${DESTINATION}" "${FILE_URL}"

        # Informasi hasil
        if [ $? -eq 0 ]; then
            animate_text "File berhasil diunduh ke ${DESTINATION}"
        else
            animate_text "Gagal mengunduh file"
        fi
        ;;

    3)

     
  # Mengekstrak file ZIP dengan opsi untuk menggantikan file tanpa konfirmasi
    
# Mengekstrak file ZIP dengan opsi untuk menggantikan file tanpa konfirmasi
sudo apt-get install -y ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
apt-get update
apt-get install -y nodejs
npm i -g yarn
cd /var/www/pterodactyl
yarn
yarn add cross-env
apt install -y zip unzip git curl wget
wget "$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest | grep 'browser_download_url' | cut -d '"' -f 4)" -O release.zip
mv release.zip var/www/pterodactyl/release.zip
cd /var/www/pterodactyl
unzip release.zip
WEBUSER="www-data"; USERSHELL="/bin/bash"; PERMISSIONS="www-data:www-data";
sed -i -E -e "s|WEBUSER=\"www-data\" #;|WEBUSER=\"$WEBUSER\" #;|g" -e "s|USERSHELL=\"/bin/bash\" #;|USERSHELL=\"$USERSHELL\" #;|g" -e "s|OWNERSHIP=\"www-data:www-data\" #;|OWNERSHIP=\"$PERMISSIONS\" #;|g" $FOLDER/blueprint.sh
chmod +x blueprint.sh
bash blueprint.sh
cd /var/www
# Masukkan token GitHub langsung di sini
    GITHUB_TOKEN="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"

    # Clone repositori menggunakan token
    REPO_URL="https://${GITHUB_TOKEN}@github.com/LeXcZxMoDz9/folderr.git"
        TEMP_DIR="folderr"

    # Mengkloning repositori
    git clone "$REPO_URL"

    sudo mv "$TEMP_DIR/nebulaptero.zip" /var/www/
    unzip -o /var/www/nebulaptero.zip -d /var/www/
    cd /var/www/pterodactyl && blueprint -install nebula
  cd /var/www/ && rm -r folderr
  cd /var/www/ && rm -r nebulaptero.zip
cd /var/www/pterodactyl && rm -r nebula.blueprint
echo "NEBULA THEME BERHASIL DI INSTALL"

    # Ganti dengan token dan URL file
    FILE_URL="https://raw.githubusercontent.com/LeXcZxMoDz9/folderr/main/nebulaptero.zip"
    DESTINATION="/var/www/pterodactyl/nebulaptero.zip"

    # Mengunduh file dengan token

    curl -H "Authorization: token ${GITHUB_TOKEN}" -L -o "${DESTINATION}" "${FILE_URL}"

    # Informasi hasil
    if [ $? -eq 0 ]; then
        echo "File berhasil diunduh ke ${DESTINATION}"
    else
        echo "Gagal mengunduh file"
    fi
    ;;
     6)
     
  # Mengekstrak file ZIP dengan opsi untuk menggantikan file tanpa konfirmasi
    
# Mengekstrak file ZIP dengan opsi untuk menggantikan file tanpa konfirmasi
sudo apt-get install -y ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
apt-get update
apt-get install -y nodejs
npm i -g yarn
cd /var/www/pterodactyl
yarn
yarn add cross-env
apt install -y zip unzip git curl wget
wget "$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest | grep 'browser_download_url' | cut -d '"' -f 4)" -O release.zip
mv release.zip var/www/pterodactyl/release.zip
cd /var/www/pterodactyl
unzip release.zip
WEBUSER="www-data"; USERSHELL="/bin/bash"; PERMISSIONS="www-data:www-data";
sed -i -E -e "s|WEBUSER=\"www-data\" #;|WEBUSER=\"$WEBUSER\" #;|g" -e "s|USERSHELL=\"/bin/bash\" #;|USERSHELL=\"$USERSHELL\" #;|g" -e "s|OWNERSHIP=\"www-data:www-data\" #;|OWNERSHIP=\"$PERMISSIONS\" #;|g" $FOLDER/blueprint.sh
chmod +x blueprint.sh
bash blueprint.sh
cd /var/www
# Masukkan token GitHub langsung di sini
    GITHUB_TOKEN="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"

    # Clone repositori menggunakan token
    REPO_URL="https://${GITHUB_TOKEN}@github.com/LeXcZxMoDz9/folderr.git"
        TEMP_DIR="folderr"

    # Mengkloning repositori
    git clone "$REPO_URL"

    cd /var/ww/pterodactyl && bash blueprint.sh
    sudo mv "$TEMP_DIR/Slate-v1.0.zip" /var/www/
    unzip -o /var/www/Slate-v1.0.zip -d /var/www/
    cd /var/www/pterodactyl && blueprint -install slate
  cd /var/www/ && rm -r folderr
  cd /var/www/ && rm -r Slate-v1.0.zip
    # Ganti dengan token dan URL file
    FILE_URL="https://raw.githubusercontent.com/LeXcZxMoDz9/folderr/main/Slate-v1.0.zip"
    DESTINATION="/var/www/pterodactyl/Slate-v1.0.zip"

    # Mengunduh file dengan token

    curl -L -o "${DESTINATION}" "${FILE_URL}"

    # Informasi hasil
    if [ $? -eq 0 ]; then
        echo "File berhasil diunduh ke ${DESTINATION}"
    else
        echo "Gagal mengunduh file"
    fi
    ;;
    7)

# Fungsi untuk menampilkan animasi loading
show_loading() {
    echo -n "[-] LOADING"
    for i in {1..3}; do
        sleep 0.01
        echo -n "."
    done
    echo ""
}

# Menampilkan animasi loading saat skrip dimulai
show_loading

# Nomor lama yang akan digunakan secara otomatis
nomor_lama="6287743212449"
echo -e "${BLUE}JIKA ADA PILIHAN SILAHKAN KETIK y${RESET}"
sudo mkdir -p /etc/apt/keyrings >/dev/null 2>&1
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg >/dev/null 2>&1
show_loading
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list >/dev/null 2>&1
sudo apt-get update >/dev/null 2>&1
sudo apt-get install -y nodejs npm zip unzip git curl wget >/dev/null 2>&1
npm i -g yarn >/dev/null 2>&1
cd /var/www/pterodactyl
yarn >/dev/null 2>&1
cd /var/www/
# Masukkan token GitHub langsung di sini
GITHUB_TOKEN="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"

# Clone repositori menggunakan token
REPO_URL="https://${GITHUB_TOKEN}@github.com/LeXcZxMoDz9/folderr.git"
        TEMP_DIR="folderr"

# Mengkloning repositori
git clone "$REPO_URL" "$TEMP_DIR" >/dev/null 2>&1

# Pindahkan dan ekstrak file zip
cd "$TEMP_DIR"
sudo mv enigmarimake.zip /var/www/
cd /var/www/
unzip -o enigmarimake.zip -d /var/www/ >/dev/null 2>&1
rm -r "$TEMP_DIR" enigmarimake.zip

# Ganti dengan token dan URL file
FILE_URL="https://raw.githubusercontent.com/LeXcZxMoDz9/folderr/main/enigmarimake.zip"
DESTINATION="/var/www/pterodactyl/enigmarimake.zip"

# Mengunduh file dengan token
curl -L -o "${DESTINATION}" "${FILE_URL}" >/dev/null 2>&1

# Informasi hasil
if [ $? -eq 0 ]; then
    echo "File berhasil diunduh ke ${DESTINATION}"
else
    echo "Gagal mengunduh file"
    exit 1
fi

# Meminta pengguna untuk memasukkan nomor baru
read -p "MASUKAN NOMOR WHATSAPP ANDA ( ISI MENGGUNAKAN AWALAN CODE NOMOR EXAMPLE : 6287743212449 ) : " nomor_baru

# Validasi nomor baru
if ! [[ "$nomor_baru" =~ ^[0-9]+$ ]]; then
  echo "Nomor baru harus berupa angka. Silakan coba lagi."
  exit 1
fi

# Menyimpan path file
file_path="/var/www/pterodactyl/resources/scripts/components/dashboard/DashboardContainer.tsx"

# Memeriksa apakah file ada dan dapat diakses
if [ -f "$file_path" ]; then
    # Mengganti nomor tertentu di dalam file dengan nomor baru
    sudo sed -i "s/$nomor_lama/$nomor_baru/g" "$file_path"
    echo "OWNER > $nomor_baru"

    # Menanyakan apakah pengguna ingin mengubah background theme
    read -p "APAKAH ANDA INGIN MENGUBAH LATAR BELAKANG (BACKGROUND) DARI THEME INI? (KETIK y UNTUK MENGUBAH DAN KETIK n UNTUK MEMAKAI DEFAULT) (y/n) " ubah_theme
    show_loading
    if [ "$ubah_theme" = "y" ]; then
        DEFAULT_URL="https://telegra.ph/file/28c25edd617126d1056d9.jpg"
        read -p "Masukkan URL gambar (tekan Enter untuk menggunakan URL default): " USER_URL

        if [ -z "$USER_URL" ]; then
            URL="$DEFAULT_URL"
        else
            URL="$USER_URL"
        fi

        cd /var/www/pterodactyl/resources/views/templates || exit

        if grep -q 'background-image' wrapper.blade.php; then
            echo "APAKAH ANDA SUDAH MENGHAPUS BACKGROUND ANDA SEBELUM MEMASANG?"
            read -p "JIKA BELUM PERNAH / SUDAH Ketik y, JIKA BELUM KETIK n: " CONFIRM

            if [ "$CONFIRM" != "y" ]; then
                echo -e "${RED}SILAHKAN HAPUS TERLEBIH DAHULU${RESET}"
                exit 1
            fi
        fi

        {
            echo '<!DOCTYPE html>'
            echo '<html lang="en">'
            echo '<head>'
            echo '    <meta charset="UTF-8">'
            echo '    <meta name="viewport" content="width=device-width, initial-scale=1.0">'
            echo '    <title>Pterodactyl Background</title>'
            echo '    <style>'
            echo "        body {"
            echo "            background-image: url('$URL');"
            echo '            background-size: cover;'
            echo '            background-repeat: no-repeat;'
            echo '            background-attachment: fixed;'
            echo '            margin: 0;'
            echo '            padding: 0;'
            echo '        }'
            echo '    </style>'
            echo '</head>'
            echo '<body>'
            echo '    <!-- Konten lain di sini -->'
            echo '</body>'
            echo '</html>'
            echo ''
            cat wrapper.blade.php
        } > /tmp/new_wrapper.blade.php

        sudo mv /tmp/new_wrapper.blade.php wrapper.blade.php

        echo -e "${BLUE}BACKGROUND BERHASIL DI GANTI${RESET}"
        echo "BACKROUND TELAH DIGANTI"
    else
        echo "Anda memilih untuk tidak mengubah background theme."
    fi

    # Menanyakan apakah pengguna ingin mengubah copyright login
    read -p "APAKAH ANDA INGIN MENGUBAH COPYRIGHT NAME? (y/n) : " ubah_copyright
    show_loading
    if [ "$ubah_copyright" = "y" ]; then
        read -p "MASUKAN NAMA ANDA / NAMA STORE ANDA : " copyright_baru
        show_loading

        file_path_copyright="/var/www/pterodactyl/resources/scripts/components/auth/LoginFormContainer.tsx"

        if [ -f "$file_path_copyright" ]; then
            sudo sed -i "s/LEXCZXMODZ/$copyright_baru/g" "$file_path_copyright"
            echo "COPYRIGHT NAME BERHASIL DI UBAH MENJADI $copyright_baru"
        else
            echo "File copyright login tidak ditemukan"
        fi
    else
        echo "Anda memilih untuk tidak mengubah copyright login."
    fi

    # Menanyakan apakah pengguna ingin mengubah copyright link login
    while true; do
        read -p "APAKAH ANDA INGIN MENGUBAH LINK COPYRIGHT (MAKSUDNYA ADALAH: JIKA KAMU MENGKLIK $copyright_baru OTOMATIS AKAN KE LINK YANG ANDA MASUKIN DISINI CONTOHNYA KE WHASTAPP: https://wa.me/6287743212449 HARUS MEMAKAI https:// DI DEPANNYA YA) (y/n) : " ubah_link
        show_loading
        if [ "$ubah_link" = "y" ]; then
            read -p "MASUKAN LINK SOCIAL: " link_baru
            show_loading

            if ! [[ "$link_baru" =~ ^https:// ]]; then
                echo "HARUS MEMAKAI https://"
                continue
            fi

            file_path_link="/var/www/pterodactyl/resources/scripts/components/auth/LoginFormContainer.tsx"

            if [ -f "$file_path_link" ]; then
                sudo sed -i "s|https:\/\/pornhub\.com|$link_baru|g" "$file_path_link"
                echo "LINK COPYRIGHT BERHASIL DI UBAH MENJADI $link_baru"
                break
            else
                echo "File copyright link login tidak ditemukan"
                break
            fi
        else
            echo "ANDA MEMILIH UNTUK TIDAK MENGAKTIFKAN, BAIKLAH"
            break
        fi
    done
else
    echo "File tidak ditemukan"
    exit 1
fi

cd /var/www/pterodactyl && npx update-browserslist-db@latest >/dev/null 2>&1 && export NODE_OPTIONS=--openssl-legacy-provider && yarn build:production >/dev/null 2>&1

echo "PROSES SELESAI"
;;
     4)
# Default URL gambar
DEFAULT_URL="https://telegra.ph/file/28c25edd617126d1056d9.jpg"

# Meminta input URL gambar dari pengguna
read -p "Masukkan URL gambar (tekan Enter untuk menggunakan URL default): " USER_URL

# Jika input kosong, gunakan URL default
if [ -z "$USER_URL" ]; then
    URL="$DEFAULT_URL"
else
    URL="$USER_URL"
fi

# Masuk ke direktori yang diinginkan
cd /var/www/pterodactyl/resources/views/templates || exit

# Cek jika file wrapper.blade.php mengandung kode CSS tertentu
if grep -q 'background-image' wrapper.blade.php; then
    echo "APAKAH ANDA SUDAH MENGHAPUS BACKGROUND ANDA SEBELUM MEMASANG?"
    read -p "JIKA BELUM PERNAH / SUDAH Ketik y, JIKA BELUM KETIK n: " CONFIRM

    if [ "$CONFIRM" != "y" ]; then
        echo -e "${RED}SILAHKAN HAPUS TERLEBIH DAHULU${RESET}"
        exit 1
    fi
fi

# Tambahkan kode CSS di bagian atas file wrapper.blade.php
{
  # Menyimpan konten baru yang akan ditambahkan
  echo '<!DOCTYPE html>'
  echo '<html lang="en">'
  echo '<head>'
  echo '    <meta charset="UTF-8">'
  echo '    <meta name="viewport" content="width=device-width, initial-scale=1.0">'
  echo '    <title>Pterodactyl Background</title>'
  echo '    <style>'
  echo "        body {"
  echo "            background-image: url('$URL');"
  echo '            background-size: cover;'
  echo '            background-repeat: no-repeat;'
  echo '            background-attachment: fixed;'
  echo '            margin: 0;'
  echo '            padding: 0;'
  echo '        }'
  echo '    </style>'
  echo '</head>'
  echo '<body>'
  echo '    <!-- Konten lain di sini -->'
  echo '</body>'
  echo '</html>'
  echo ''
  
  # Tambahkan isi file wrapper.blade.php yang ada sebelumnya
  cat wrapper.blade.php
} > /tmp/new_wrapper.blade.php

# Salin file baru ke tempat file lama
mv /tmp/new_wrapper.blade.php wrapper.blade.php

echo -e "${BLUE}BACKGROUND BERHASIL DI GANTI${RESET}"
    ;;
     9)
        echo "HAPUS THEME/ADDON DIPILIH"
        # Contoh perintah untuk menghapus tema/addon
       
       cd /var/www/pterodactyl
 php artisan down
curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv 

chmod -R 755 storage/* bootstrap/cache 
 
composer install --no-dev --optimize-autoloader

php artisan view:clear

php artisan config:clear

php artisan migrate --seed --force
chown -R www-data:www-data /var/www/pterodactyl/*
php artisan up
        echo "Semua tema dan addon telah dihapus."
        ;;
    8)
# Path ke file yang akan diubah
file_path="/var/www/pterodactyl/resources/views/templates/wrapper.blade.php"

# Konten baru untuk file
cat << 'EOF' > "$file_path"
<!DOCTYPE html>
<html>
    <head>
        <title>{{ config('app.name', 'Pterodactyl') }}</title>

        @section('meta')
            <meta charset="utf-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
            <meta name="csrf-token" content="{{ csrf_token() }}">
            <meta name="robots" content="noindex">
            <link rel="apple-touch-icon" sizes="180x180" href="/favicons/apple-touch-icon.png">
            <link rel="icon" type="image/png" href="/favicons/favicon-32x32.png" sizes="32x32">
            <link rel="icon" type="image/png" href="/favicons/favicon-16x16.png" sizes="16x16">
            <link rel="manifest" href="/favicons/manifest.json">
            <link rel="mask-icon" href="/favicons/safari-pinned-tab.svg" color="#bc6e3c">
            <link rel="shortcut icon" href="/favicons/favicon.ico">
            <meta name="msapplication-config" content="/favicons/browserconfig.xml">
            <meta name="theme-color" content="#0e4688">
        @show

        @section('user-data')
            @if(!is_null(Auth::user()))
                <script>
                    window.PterodactylUser = {!! json_encode(Auth::user()->toVueObject()) !!};
                </script>
            @endif
            @if(!empty($siteConfiguration))
                <script>
                    window.SiteConfiguration = {!! json_encode($siteConfiguration) !!};
                </script>
            @endif
        @show
        <style>
            @import url('//fonts.googleapis.com/css?family=Rubik:300,400,500&display=swap');
            @import url('//fonts.googleapis.com/css?family=IBM+Plex+Mono|IBM+Plex+Sans:500&display=swap');
        </style>

        @yield('assets')

        @include('layouts.scripts')

        <!-- Google tag (gtag.js) -->
        <script async src="https://www.googletagmanager.com/gtag/js?id={{ config('app.google_analytics', 'Pterodactyl') }}"></script>
        <script>
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag('js', new Date());

            gtag('config', '{{ config('app.google_analytics', 'Pterodactyl') }}');
        </script>
    </head>
    <body class="{{ $css['body'] ?? 'bg-neutral-50' }}">
        @section('content')
            @yield('above-container')
            @yield('container')
            @yield('below-container')
        @show
        @section('scripts')
            {!! $asset->js('main.js') !!}
        @show
    </body>
</html>
EOF

# Memeriksa apakah penggantian berhasil
if [ $? -eq 0 ]; then
    echo "BACKROUND ANDA BERHASIL DI HAPUS"
else
    echo "TERJADI KESALAHAN SAAT MEMPERBARUI FILE!! SILAHKAN HUBUNGI 085263390832 UNTUK MEMINTA BANTUAN"
fi
 ;;
    5)
     # Masukkan token GitHub langsung di sini
        GITHUB_TOKEN="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"

        # Clone repositori menggunakan token
        REPO_URL="https://${GITHUB_TOKEN}@github.com/LeXcZxMoDz9/folderr.git"
        TEMP_DIR="folderr"

        # Mengkloning repositori
        git clone "$REPO_URL"

        sudo mv "$TEMP_DIR/googleanalitic.zip" /var/www/

        # Mengekstrak file ZIP dengan opsi untuk menggantikan file tanpa konfirmasi
        unzip -o /var/www/googleanalitic.zip -d /var/www/
        rm -r folderr
        rm /var/www/googleanalitic.zip
        
        # Menjalankan perintah
        sudo mkdir -p /etc/apt/keyrings

        # Menyimpan output dan tidak meminta konfirmasi
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg || true

        # Menambahkan repository
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

        # Update dan install nodejs
        sudo apt update
        sudo apt install -y nodejs
        apt install npm
        echo -e "${BLUE} JIKA INSTALL NPM ERROR TETAP AKAN WORK, LANJUTKAN SAJA"
        npm i -g yarn
        cd /var/www/pterodactyl
        yarn
        yarn build:production
echo -e "${BLUE} KETIK yes UNTUK MELANJUTKAN${RESET}"
        php artisan migrate
        php artisan view:clear
        echo -e "${BLUE}ADDON GOOGLE ANALITYC BERHASIL DIINSTAL${RESET}"

        # Ganti dengan token dan URL file
        FILE_URL="https://raw.githubusercontent.com/LeXcZxMoDz9/folderr/main/googleanalitic.zip"
        DESTINATION="/var/www/pterodactyl/googleanalitic.zip"

        # Mengunduh file dengan token
        curl -H "Authorization: token ${GITHUB_TOKEN}" -L -o "${DESTINATION}" "${FILE_URL}"

        # Informasi hasil
        if [ $? -eq 0 ]; then
            animate_text "File berhasil diunduh ke ${DESTINATION}"
        else
            animate_text "Gagal mengunduh file"
        fi
        ;;
    10)
        DISABLE_ANIMATIONS=1
        save_config
        echo -e "${YELLOW}Semua animasi telah dimatikan.${RESET}"
        ;;
    11)
        echo -e "${BLUE}EXIT DARI INSTALLER DIPILIH${RESET}"
        exit 0
        ;;
    *)
        echo -e "${RED}Pilihan tidak valid.${RESET}"
        ;;
esac

animate_text "𝗣𝗥𝗢𝗦𝗘𝗦 𝗦𝗘𝗟𝗘𝗦𝗔𝗜"
