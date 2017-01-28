---
layout: page
title: linux
subtitle: Oprekan Linux
image: /oprekans/linux/img/linux.jpg
social-share: true
comments: true
---


Semua OS yang terpasang diharddisk saya saat ini:

- Ubuntu
- Arch
- debian

## Ubuntu

<img src="https://github.com/alexforsale/blog/blob/gh-pages/_oprekans/linux/img/ubuntu/Screenshot-ubuntu.png?raw=true" alt="Ubuntu" />

Yang merupakan distro utama saya, karena merupakan salah satu distro awal yang pernah saya coba. Menjadi pilihan untuk penggunaan sehari - hari karena stabilitas, dan karena stabilitas ini juga saya tidak terlalu banyak utak - atik disini, jika tidak rusak, jangan diperbaiki. Penggunaan *PPA* juga sebisa mungkin dihindari karena alasan yang sama. Hampir bisa dibilang sempurna andai saja transisi setiap cycle-nya tidak bermasalah, untuk saat ini masih ditunggu transisi dari *16.10*, dan ini juga yang membuat saya memiliki pilihan kedua.

## archlinux

<img src="https://github.com/alexforsale/blog/blob/gh-pages/_oprekans/linux/img/arch/Screenshot-arch.png?raw=true" alt="archlinux" />

Sebuah distro dengan semangat "do it yourself", [dokumentasi mereka yang sangat komprehensif](https://wiki.archlinux.org/) membuat user-nya selalu mencoba memperbaiki sendiri sebelum bertanya ke forum, searching di-internet, dan jika tidak bisa, kembali ke coba perbaiki sendiri sebelum bertanya keforum, membuat setiap upaya interaksi didalam distro ini dijamin menambah pengetahuan tentang *linux*. Dan ini saya belum menyinggung masalah rolling release-nya. Sengaja menggunakan *gnome* karena walaupun banyak pilihan untuk *DE*, saya selalu kembali ke *gnome*.

## debian

<img src="https://github.com/alexforsale/blog/blob/gh-pages/_oprekans/linux/img/debian/Screenshot-debian.png?raw=true" alt="debian" />

Distro yang saya pilih untuk melakukan hobi saya yang lain: compiling android dari source ([AOSP](https://source.android.com/source/initializing.html)). Sengaja pilih debian karena menggunakan 2 partisi yang berbeda untuk distro yang sama terasa sangat *redundant*. Dan juga karena *pastinya* jika saya memilih *archlinux* waktu saya akan habis untuk mengoprek OS-nya. *Xfce* juga dipilih untuk alasan yang sama.

<img src="https://github.com/alexforsale/blog/blob/master/_oprekans/linux/img/partisi.png?raw=true" alt="partisi" />

Bisa dilihat skema partisi yang saya gunakan diatas, dua unallocated spaces tadinya bekas partisi primary yang digunakan oleh windows, partisi yang menurut saya sudah cukup seimbang. Pilihan 4G untuk swap masih perlu dipertanyakan. Yang cukup rumit adalah mounting untuk partisi `/home`, jika saya menggunakan cara mounting biasa, `/dev/sda6/` dijadikan `/home`, saya akan menemukan banyak masalah *pastinya* jika menggunakan username yang sama. Sedangkan username saya **harus** __alexforsale__. [Jadinya saya menggunakan `mount --bind` yang cukup rumit di `/etc/fstab/` setiap OS-nya](https://alexforsale.github.io/blog/2017-01-22-modifikasi-fstab-linux/).


