# Gunakan image resmi PHP dengan Apache sebagai base
FROM php:8.1-apache

# Instal dependensi sistem yang dibutuhkan oleh PHP dan aplikasi
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libonig-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Instal ekstensi PHP yang dibutuhkan aplikasi Anda
# Berdasarkan database.php, Anda menggunakan mysqli
RUN docker-php-ext-install pdo pdo_mysql mysqli gd zip mbstring exif

# Aktifkan Apache rewrite module (penting jika aplikasi Anda menggunakan URL bersih)
RUN a2enmod rewrite

# Konfigurasi DocumentRoot Apache ke /var/www/html
# Dan izinkan .htaccess (AllowOverride All) jika aplikasi Anda menggunakannya
COPY apache-conf.conf /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default.conf

# Salin semua kode aplikasi dari konteks build ke dalam container
# Pastikan Dockerfile ini di root proyek Anda, sehingga '.' mencakup semua file
COPY . /var/www/html/

# Atur izin file agar Apache (www-data) dapat membaca dan menulis jika diperlukan
# Ini sangat penting untuk menghindari 403 Forbidden atau error permission
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \;

# Ekspor port 80 (Apache default)
EXPOSE 80

# Mulai Apache saat kontainer diluncurkan
CMD ["apache2-foreground"]