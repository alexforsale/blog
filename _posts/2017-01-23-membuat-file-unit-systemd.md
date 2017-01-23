---
layout: post
title: Membuat file unit systemd
tags: [random, blog, apache2, jekyll, systemd]
---

File unit systemd, yang mirip seperti file `.desktop` (yang juga sebenarnya terinspirasi dari file `.ini`-nya `W*nd*ws`) adalah file yang digunakan oleh systemd dan biasanya berupa service (`.service`), mount point (`.mount`), devices (`.device`) ataupun socket (`.socket`).

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
Environment="PATH=/home/alexforsale/.gem/ruby/2.4.0/bin/bundle"
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

blogpath=/data/source/alexforsale.github.io

cd $blogpath

/home/alexforsale/.gem/ruby/2.4.0/bin/bundle exec /home/alexforsale/.gem/ruby/2.4.0/bin/jekyll build --watch -s /data/source/alexforsale.github.io/ -d /srv/http

```

Save file tersebut, dan tes dengan jalankan perintah `systemctl start build-blog.service`, jika semuanya berjalan lancar hasilnya seperti ini:

```
● build-blog.service - build blog
   Loaded: loaded (/usr/lib/systemd/system/build-blog.service; disabled; vendor preset: disabled)
   Active: activating (start) since Mon 2017-01-23 20:08:03 WIB; 21s ago
 Main PID: 26513 (bash)
    Tasks: 5 (limit: 4915)
   CGroup: /system.slice/build-blog.service
           ├─26513 /bin/bash /home/alexforsale/bin/build-blog.sh
           └─26514 /home/alexforsale/.gem/ruby/2.4.0/bin/jekyll build --watch -s /data/source/alexforsale.github.io/ -d /srv/http

Jan 23 20:08:03 archlinux systemd[1]: Starting build blog...
Jan 23 20:08:04 archlinux bash[26513]: Configuration file: /data/source/alexforsale.github.io/_config.yml
Jan 23 20:08:04 archlinux bash[26513]:             Source: /data/source/alexforsale.github.io/
Jan 23 20:08:04 archlinux bash[26513]:        Destination: /srv/http
Jan 23 20:08:04 archlinux bash[26513]:  Incremental build: disabled. Enable with --incremental
Jan 23 20:08:04 archlinux bash[26513]:       Generating...
Jan 23 20:08:05 archlinux bash[26513]:                     done in 1.369 seconds.
Jan 23 20:08:05 archlinux bash[26513]:  Auto-regeneration: enabled for '/data/source/alexforsale.github.io/'

```

Jika melakukan modifikasi pada file `/usr/lib/systemd/system/build-blog.service`, pastikan sebelum start servicenya lakukan reload daemon terlebih dahulu dengan perintah `systemctl daemon-reload`. Untuk membuat service ini berjalan setiap reboot, jalankan perintah `systemctl enable build-blog.service`
