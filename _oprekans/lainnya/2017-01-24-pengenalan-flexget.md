---
layout: oprekans
title: Pengenalan Flexget
subtitle: Seri Pertama dari Tutorial Flexget
social-share: true
comments: true
---

## Flexget

*Flexget* adalah sebuah tool multiguna, bisa dimodifikasi sepenuhnya oleh user, yang fungsi utamanya adalah otomatisasi. *Flexget* memiliki support untuk semua OS (mac, windows, linux/bsd). Salah satu kelemahan *Flexget* yang juga sebenarnya merupakan kelebihan utamanya adalah konfigurasinya, tidak ada file konfigurasi yang bisa langsung digunakan begitu saja, dan bentuk konfigurasinya yang merupakan file `.yml` (yaml markup) yang cukup rumit untuk pertama kalinya.

Sebelumnya saya sudah pernah menggunakan *Flexget* di *ubuntu* dan hasilnya sangat memuaskan, konfigurasi saya sebelumnya bisa dilihat di[github](https://github.com/alexforsale/flexget), dan sebenarnya masih bisa digunakan, hanya saja terlalu banyak fitur yang saya masukkan disitu.

Saya akan memulai satu seri post - post yang akan mencoba memperkenalkan fitur - fitur yang disediakan oleh *Flexget*, walaupun sebenarnya dokumentasi mereka sudah sangat lengkap. Tapi yang akan saya post disini adalah contoh - contoh konfigurasi yang pastinya sudah saya coba sebelumnya.

## Instalasi

Disini saya akan install *Flexget* di *ubuntu*, yang merupakan OS utama yang saya gunakan. *Flexget* membutuhkan beberapa software yang harus diinstall sebelumnya

### Python

*Flexget* membutuhkan *Python2.7*, *3.3* atau lebih baru agar bisa dijalankan, cek versi yang sudah terinstall dengan.

```
python -V
```

Install versi yang diperlukan, gunakan versi 2.7 jika ingin menggunakan `deluge`.

### PIP

Package manager *Python*, biasanya nama package-nya `python-pip` atau `python3-pip`, untuk distro *debian*-based install seperti ini.

```
sudo apt-get install python-pip
```

### Upgrade Setuptool

Pastikan selalu menggunakan versi yang terbaru, instalasinya menggunakan `pip`

```
sudo pip install --upgrade setuptools

```

_Note_: Cek detail dari instalasi *setuptools* diatas, biasanya versi *pip* yang diinstall dari OS memiliki versi yang lama, contohnya seperti instalasi saya:

```
You are using pip version 8.1.2, however version 9.0.1 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
```

Lakukan seperti apa yang disarankan, jalankan perintah `pip install --upgrade pip`, cek versi setelahnya dengan `pip -V`

### Install Flexget

Ada beberapa metode untuk instalasi flexget, yang pertama dengan menggunakan `virtualenv`, yang menciptakan environment *python* yang terisolasi. Kedua adalah dengan instalasi global, sehingga bisa diakses oleh semua user, yang biasanya aman kecuali seandainya ada beberapa package - package *python* membutuhkan satu library dengan versi yang berbeda. Cara terakhir adalah dengan cloning repository git [*flexget*](https://github.com/Flexget/Flexget). Dengan cara ini kita bisa memastikan selalu mendapatkan versi yang *bleeding edge*, namun perlu diingat, update repository-nya harus dilakukan sendiri menggunakan `git pull`, dan pastikan `bin/flexget` didalam repo tersebut masuk kedalam environment *PATH*.

#### Instalasi global

```
sudo pip install flexget
```

#### Instalasi melalui virtualenv

Note: saya tidak pernah menggunakan cara ini, namun berikut ini dari [dokumentasi](https://www.flexget.com/InstallWizard/Linux) resmi-nya

```
sudo pip install virtualenv
```

```
virtualenv ~/flexget/
```

Note: Jika ingin menggunakan `deluge`

```
virtualenv --system-site-packages ~/flexget/
```

Install *flexget*

```
cd ~/flexget/
bin/pip install flexget
```

##### Menjalankan *flexget* dari virtualenv

```
source ~/flexget/bin/activate
```

Setelah aktifasi tersebut *flexget* dapat dijalankan dari mana saja, perhatikan juga aktifasi ini hanya berlaku di terminal window yang sama saja, tetapi *flexget* masih bisa dijalankan dengan 

```
~/flexget/bin/flexget [options]
```

Bentuk kedua ini yang dipakai untuk dipanggil dari `crontab`, jika schedulingnya menggunakan `crontab`.

#### Instalasi dari source

Ini cara yang saya gunakan saat ini, checkout terlebih dahulu repository-nya di folder yang ditentukan (saya menggunakan `/data/source` untuk semua repository git).

```
cd ke-path-yang-disukai
git clone https://github.com/Flexget/Flexget.git flexget
```

Repository-nya akan berada difolder tersebut dengan nama *flexget*. Buat sebuah environment virtual dengan `virtualenv` ke folder tersebut

```
virtualenv flexget
```

Install dengan menggunakan `pip`, pastikan perintahnya `bin/pip/` untuk menggunakan `pip` yang terpasang dari `virtualenv` tadi.

```
cd flexget
bin/pip install -e .

```

Perhatikan ada `.` diperintah tersebut. Setelah perintah diatas selesai, *flexget* berada difolder `bin/flexget` dan dapat dijalankan dengan perintah

```
~/flexget/bin/flexget
```

Untuk mudahnya dapat dibuat *symlink* dari *flexget* ke path yang termasuk dalam environment `$PATH`

## [Scheduling](https://www.flexget.com/InstallWizard/Linux/Scheduling)

Fase ini sebenarnya bisa ditunda setidaknya sampai ada file konfigurasi yang berjalan. Database *SQLite* dari file konfigurasi tersebut akan berada di folder yang sama, jadi pastikan user yang menjalankan flexget memiliki hak akses kesitu.

### Menggunakan systemd/timers

Untuk OS yang menggunakan *systemd* bisa secara langsung menjalankan perintah yang akan dieksekusi setiap jam-nya dengan perintah

```
systemd-run --on-active="1h" --uid=`id -u` --gid=`id -g` `which flexget`
```

Akan diminta password root karena system service membutuhkan akses tersebut, nama service akan diberikan setelahnya dan dapat dicek dengan melihat scheduler *systemd* di `systemctl list-timers`

### Menggunakan cron

Cek terlebih dahulu full path dari *flexget*

```
which flexget
```

Lalu edit crontab, editor yang digunakan bisa diubah dengan `export EDITOR=nano` atau editor lain, dan edit crontab dengan perintah

```
crontab -e
```

Masukkan baris ini 

```
@hourly /usr/local/bin/flexget --cron execute
```

Sesuaikan path *flexget*-nya sesuai dengan path yang dicek sebelumnya. Baris diatas akan menjalankan *flexget* setiap jam-nya.

### Mode daemon

Dengan mode ini, *flexget* dapat dischedule dari dalam file konfigurasi, ganti baris cron diatas menjadi

```
@reboot /usr/local/bin/flexget daemon start -d
```

