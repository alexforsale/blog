---
layout: post
title: Are We Really Installing?
subtitle: Proyek necromancery, part II
tags: [archlinux, PC]
bigimg: /img/post/IMG_20171212_223908.jpg
description: 
---

###### By failing to prepare, you are preparing to fail ######
Quote tenar dari Benjamin Franklin. Simpelnya, untuk instalasi ini, yang diperlukan hanyalah:
- Media instalasi, USB Stick ukuran 2 GB sudah lebih dari cukup.
- Media untuk koneksi internet. Saya menggunakan modem portable Smartfren M2Y.
- http://wiki.archlinux.org, alternatif lain ada file text berisi instruksi instalasi ketika boot USB tersebut.

###### Instalasi dimulai! ######
Proses instalasi arch sebenarnya cukup simpel, sangat straightforward malah. Kesulitan pertama yang biasanya dihadapi, seperti koneksi internet jika menggunakan wireless dapat diatasi dengan menggunakan modem portable ini. Cukup sambungkan dengan kabel USB ke PC, jalankan `dhcpcd`.

Yang cukup menegangkan mungkin ketika melakukan partisi hard disk, hanya saja karena saya sudah pasti format semua partisinya, hal ini juga tidak menjadi masalah.

Pada Akhirnya, inilah skema partisinya hdd saya:

``` shell
alexforsale in ~ λ sudo fdisk -l
sudo fdisk -l
Disk /dev/sda: 74.5 GiB, 80026361856 bytes, 156301488 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: B7555012-678C-47F5-B5A0-74B557D91A5A

Device         Start       End   Sectors  Size Type
/dev/sda1         34      2081      2048    1M BIOS boot
/dev/sda2       2082  41945087  41943006   20G Linux filesystem
/dev/sda3   41945088 148437500 106492413 50.8G Linux filesystem
/dev/sda4  148439040 156301311   7862272  3.8G Linux swap
```

Semuanya sudah tercover jelas di wiki, perbedaan yang saya lakukan hanyalah ketika proses `pacstrap`, perintah yang saya jalankan adalah `pacstrap /mnt base base-devel`, karena ujung - ujung nya package `base-devel` ini pasti dibutuhkan.

##### Booting pertama #####
Cukup ikuti rekomendasi - rekomendasi yang dianjurkan oleh [wiki](https://wiki.archlinux.org/index.php/General_recommendations), sampai disini tentu tiap user memiliki preferensi yang berbeda dengan user lainnya. Install AUR-helper setelah menambahkan user, ini jelas sangat diperlukan.

Package pertama yang saya install setelah mengikuti semua rekomendasi umum dari wiki adalah package `emacs-nox`, karena saya masih tertarik untuk belajar emacs, dan satu - satunya cara untuk memperlancar adalah dengan (memaksa untuk) menggunakannya disetiap kesempatan.

#### Instalasi sudo ####
Pastikan untuk menggunakan perintah `EDITOR=emacs visudo` ketika melakukan edit.

#### zsh ####
Saya tertarik dengan zsh karena ini yang digunakan oleh installer, pastikan untuk mengeksekusi perintah `zsh-newuser-install` setelah untuk setup environment dan lainnya.

#### AUR-helper ####
Saya pertama kali menggunakan `yaourt` dan tidak ada rencana untuk mengganti dengan yang lain. Note: untuk pertama kali nya bisa langsung edit file config pacman, atau install manual menggunakan git. Saya menjalankan proses yang kedua, karena toh nantinya git akan diinstall juga.

``` shell
git clone http://aur.archlinux.org/package-query.git
cd package-query
makepkg -si
cd ..
cd yaourt
makepkg -si
```

#### Install linux header ####
Ini tentunya dibutuhkan untuk keperluan compiling.

#### Install firmware wireless ####

Yaourt dibutuhkan karena saya butuh untuk install firmware USB Wireless saya (RTL8188EU).
`yaourt -S 8188eu-dkms`

#### Ubah Nama Network interface ####
Ini sebenarnya tidak disarankan, hanya saja saya malas harus mengetik *wlp0s26u1u3* setiap kali, lebih nyaman jika nama interfacenya *wlan0, wlan1, eth0, eth1* dll. Ada banyak cara untuk mencapai ini, yang saya lakukan adalah: edit kernel parameter, `/etc/default/grub`. Tambahkan `net.ifnames=0` kebaris `GRUB_CMDLINE_LINUX_DEFAULT` lalu update grub dengan perintah `grub-mkconfig -o /boot/grub/grub.cfg`. Ini memastikan editan yang kita lakukan tidak akan tertimpa setiap kali grub di update.

#### Package lainnya ####
Yang pertama tentunya windows manager, PC setua ini sudah tidak memiliki kemampuan untuk mengangkat Desktop Environment yang sekecil apapun(*this is no exaggeration*). Pilihan saya adalah i3wm, sama saja sebenarnya dengan window manager lainnya.

Saya banyak menginstall package langsung dari source, jadi tentunya ada banyak repository git yang mesti saya simpan. Untuk ini saya terbiasa menyimpannya di `~/repo`, dengan subfolder *android* untuk repository android, dan *linux* untuk repository linux.

Setelah saya selesai mengkonfigurasi i3wm(semestinya ada post khusus hanya untuk ini.), saya mengucapkan selamat tinggal kepada `emacs-nox` dan menyambut kedatangan repository git emacs. Ini juga sebenarnya not recommended, hanya saja dengan cara ini (instalasi manual), saya memiliki kebebasan untuk memilih versi emacs yang saya mau, tanpa harus mengganggu kerja `pacman` (tidak harus freeze package yang fatal jika lupa, dan lainnya). Repository emacs bisa diclone dengan perintah `git clone git://git.sv.gnu.org/emacs.git`.

Tentunya ada banyak dependencies yang dibutuhkan oleh emacs, butuh beberapa menit untuk googling mekanisme-nya, hanya saja saya ambil versi simpelnya(yang juga not recommended): jalankan perintah `sudo pacman -S emacs` lihat semua package yang harus diinstall(selain emacs tentunya) copy semua dan batalkan instalasi emacs-nya. Jalankan perintah `sudo pacman -S` diikuti dengan semua package yang tadi dicopy. Bukan cara yang baik, tapi paling tidak sampai sekarang tidak(belum) ada masalah.

Setelah semuanya dijalankan:

``` shell
cd emacs
./autogen.sh
./configure --with-mailutils #install juga package mailutils untuk ini
make
sudo make install
```
{% include image.html
    img="/img/post/Screenshot-2017-12-13T20:28:54.png"
    title="screenshot" %}

