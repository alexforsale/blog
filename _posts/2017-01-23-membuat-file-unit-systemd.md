---
layout: post
title: Membuat file unit systemd
tags: [random, blog, apache2, jekyll, systemd]
---

File unit systemd, yang mirip seperti file `.desktop` (yang juga sebenarnya terinspirasi dari file `.ini`-nya `W*nd*ws`) adalah file yang digunakan oleh systemd dan biasanya berupa service (`.service`), mount point (`.mount`), devices (`.device`) ataupun socket (`.socket`).

### arch

Saya akan membuat satu file unit yang berfungsi untuk menjalankan script build jekyll (yang akan generate blog saya ke `/srv/http`, untuk lebih lengkapnya baca post saya sebelumnya [disini](https://alexforsale.github.io/2017-01-21-jekyll-dan-apache/)), script tersebut saya simpand di `~/bin/build-blog.sh`. Berdasarkan dokumentasi [systemd](https://wiki.archlinux.org/index.php/Systemd) yang saya baca, file unit akan dicari di salah satu dari dua directory ini (berdasarkan prioritas dari terendah sampai tertinggi):

- `/usr/lib/systemd/system/`
- `/etc/systemd/system/`

File unitnya saya buat di `/usr/lib/systemd/system/` dengan nama `build-blog.service` menggunakan nano.

```
sudo nano /usr/lib/systemd/system/build-blog.service
```

Dan isinya:

```
[Unit]
Description= build blog

[Service]
Type=oneshot
ExecStart=/home/alexforsale/bin/build-blog.sh
RemainAfterExit=yes
User=alexforsale
Group=alexforsale

[Install]
WantedBy=multi-user.target
```

- Description di bagian `[Unit]` sepertinya sudah cukup jelas. 
- `Environment` ini untuk menentukan path ke executables yang digunakan (dalam hal ini, `bundle` dan `jekyll`), check melalui perintah `which bundle` dan `which jekyll`.
- Untuk `type=oneshot` berarti unit ini hanya akan melakukan satu 'job' lalu exit.
- `ExecStart` adalah file yang akan dieksekusi.
- `RemainAfterExit` di set `yes` berarti systemd akan tetap menganggap service ini aktif setelah prosesnya selesai
- `User` dan `Group` disini untuk memastikan unit ini berjalan tidak sebagai root, tapi sebagai user.
- `WantedBy` untuk menentukan *targets* dari systemd, yang mirip seperti runlevel, jalankan perintah `systemctl list-units --type=target` untuk melihat list target yang ada.

File unit sudah dibuat, tinggal membuat script untuk generate blog jekyll ini di `~/bin/build-blog.sh`.

```
#!/bin/bash 
# 
# Christian Alexander <alexforsale@yahoo.com>
# executable script untuk service systemd 
# https://alexforsale.github.io/2017-01-23-membuat-file-unit-systemd/
# 

blogpath=/data/source/alexforsale.github.io
GEM_HOME=$(/usr/bin/ls -t -U | /usr/bin/ruby -e 'puts Gem.user_dir')

cd $blogpath

$GEM_HOME/bin/bundle exec $GEM_HOME/bin/jekyll build --watch -s $blogpath -d /home/alexforsale/public_html

```

```
chmod a+x ~/bin/build-blog.sh
```
Save file tersebut, dan tes dengan jalankan perintah `systemctl start build-blog.service`, jika semuanya berjalan lancar tidak akan ada message apapun, ketik *CTRL-C* untuk kembali ke prompt. Cek status dari service tersebut dengan ketik `systemctl status build-blog.service`, semestinya hasilnya seperti ini:

```
13:21 $ systemctl status build-blog.service 
● build-blog.service - build blog
   Loaded: loaded (/usr/lib/systemd/system/build-blog.service; disabled; vendor preset: disabled)
   Active: activating (start) since Thu 2017-01-26 13:21:21 WIB; 26s ago
 Main PID: 6938 (build-blog.sh)
    Tasks: 5 (limit: 4915)
   CGroup: /system.slice/build-blog.service
           ├─6938 /bin/bash /home/alexforsale/bin/build-blog.sh
           └─6943 /home/alexforsale/.gem/ruby/2.4.0/bin/jekyll build --watch -s /data/source/alexforsale.github.io -d /home/alexforsae/public_html

Jan 26 13:21:21 archlinux systemd[1]: Starting build blog...
Jan 26 13:21:22 archlinux build-blog.sh[6938]: Configuration file: /data/source/alexforsale.github.io/_config.yml
Jan 26 13:21:22 archlinux build-blog.sh[6938]:             Source: /data/source/alexforsale.github.io
Jan 26 13:21:22 archlinux build-blog.sh[6938]:        Destination: /home/alexforsale/public_html
Jan 26 13:21:22 archlinux build-blog.sh[6938]:  Incremental build: disabled. Enable with --incremental
Jan 26 13:21:22 archlinux build-blog.sh[6938]:       Generating...
Jan 26 13:21:23 archlinux build-blog.sh[6938]:                     done in 1.732 seconds.
Jan 26 13:21:24 archlinux build-blog.sh[6938]:  Auto-regeneration: enabled for '/data/source/alexforsale.github.io'
```

Jika melakukan modifikasi pada file `/usr/lib/systemd/system/build-blog.service`, pastikan sebelum start servicenya lakukan reload daemon terlebih dahulu dengan perintah `systemctl daemon-reload`. Untuk membuat service ini berjalan setiap reboot, jalankan perintah `systemctl enable build-blog.service`

### ubuntu

Beberapa perbedaan untuk ubuntu, simpan file `/usr/lib/systemd/system/build-blog.service` di `/etc/systemd/system/build-blog.service` karena ada perbedaan lokasi, sedangkan untuk isi dari `~/bin/build-blog.sh`pun harus disesuaikan, edit menjadi seperti ini:

```
#!/bin/bash
# 
# Christian Alexander <alexforsale@yahoo.com>
# executable script untuk service systemd
# https://alexforsale.github.io/2017-01-23-membuat-file-unit-systemd/
# 

blogpath=/data/source/alexforsale.github.io
#GEM_HOME=$(ls -t -U | ruby -e 'puts Gem.user_dir')

cd $blogpath

bundle exec jekyll build --watch -s $blogpath -d /home/alexforsale/public_html

```

