---
layout: post
title: Set up android build environment di Arch
tags: [blog, arch, linux, android]
---

Compiling [AOSP (Android Open Source Project)](https://source.android.com/) sampai saat ini memang hanya bisa dilakukan di gnu/linux dan mac OS, dan untuk gnu/linux dokumentasi mereka distribusi yang disarankan adalah ubuntu. Dan saya sudah berkali kali compiling menggunakan ubuntu, sempat juga mencoba di fedora, opensuse, namun belum pernah sekalipun mencoba dengan distro arch (ini karena baru dua kali saya menggunakan arch).

Jadi dikesempatan ini, kita berikan ujicoba untuk arch, melihat juga dokumentasi mengenai compiling aosp di arch sudah lumayan banyak. Bagi yang menggunakan ubuntu bisa melihat dokumentasi saya [setting up android build environment di ubuntu](https://alexforsale.github.io/oprekans/android/).

Patokan dasarnya adalah dokumentasi resmi dari [aosp](https://source.android.com/source/initializing.html), dan dokumentasi dari arch [wiki](https://wiki.archlinux.org/index.php/android), serta tambahan dokumentasi dari [omnirom](https://docs.omnirom.org/Setting_Up_A_Compile_Environment), karena saya source yang ingin saya compile tidak murni dari aosp, namun merupakan custom rom yang difork dari source aosp.

Hal yang pertama kali perlu dilakukan untuk arch adalah menggunakan repository multilib, yang sudah saya lakukan setelah install arch, jika belum hal ini tidak terlalu rumit, cukup hapus tanda `#` di `/etc/pacman.conf` khusus bagian `[multilib]` dan satu baris dibawahnya.

Package yang perlu didownload dari repository official:

```
gcc-multilib git gnupg flex bison gperf sdl wxgtk squashfs-tools curl ncurses zlib schedtool perl-switch zip unzip libxslt python2-virtualenv bc rsync lib32-zlib lib32-ncurses lib32-readline xml2 lzop pngcrush schedtool squashfs-tools lzop imagemagick
```

Package yang perlu didownload dari AUR:

```
ncurses5-compat-libs lib32-ncurses5-compat-libs
```

Package `maven` dan `gradle` disarankan oleh dokumentasi arch, keduanya berkaitan dengan java yang dan dikatakan dapat meningkatkan kecepatan proses compiling. Gunakan pacman dengan tambahan `--needed` sehingga tidak perlu install package yang sudah terinstall.
