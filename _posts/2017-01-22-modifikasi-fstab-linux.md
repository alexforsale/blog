---
layout: post
title: Modifikasi fstab linux (arch dan ubuntu)
tags: [blog, arch, ubuntu, linux, fstab]
---

Kasusnya seperti ini: saya saat ini memiliki 2 distro gnu/linux yang berbeda, arch dan ubuntu (kemungkinan bertambah melihat partisi `W*nd*ws` yang semakin menyusut dan berteriak "just kill me already!"), dan juga saya memiliki satu partisi khusus /home, saya tidak ingin menggunakan username yang berbeda ditiap distro (username saya selalu sama dimana - mana). Tapi menggunakan username yang sama dengan sharing partisi /home di distro gnu/linux sama saja seperti bom bunuh diri. File konfigurasi user dari banyak software biasanya disimpan di folder ~ (/home/$USER), akan jadi masalah jika satu software digunakan di beberapa distro dan masing - masing berbeda konfigurasi. Masalah berikutnya adalah file media, saya termasuk penikmat musik dan film, walaupun kebanyakan dari file media saya taruh di storage removable (external HDD), tapi nyatanya lebih sering saya akses, dan terlalu banyak klik untuk mencapai file - file tersebut. Masalah terakhir, harddisk pc saya ini cukup kecil, jadi kemungkinan ada file double yang tersimpan di folder ~ sebisa mungkin harus dikurangi, jika file - file tersebut bersifat dokumen, atau tidak berpengaruh terhadap fungsi software atau OS, lebih baik langsung ke storage external.

Jadi bagaimana solusinya? Untuk masalah yang pertama, supaya dapat tetap menggunakan username yang sama tanpa folder home yang sama, saya harus edit file `/etc/fstab`. Secara default-nya saat kita install distro baru, jika menggunakan partisi yang berbeda untuk /home, partisi tersebut otomatis akan dimount di /home. Yang saya lakukan adalah, memindahkan mounting tersebut ke tempat lain (saya pilih /data), baru dari situ saya mount bind /home ke /data/(nama distro). Distro pertama yang saya install (ubuntu) sudah terlanjur mount /home dipartisi tersebut, sehingga saya perlu menyalin secara manual terlebih dahulu isi /home/$USER di ubuntu ke /home/ubuntu/$USER (tidak langsung pindahkan untuk jaga - jaga seandainya ada masalah nantinya, dan tentunya file `/etc/fstab` yang asli pun perlu disalin sebelum dimodifikasi).

Tadinya baris `/etc/fstab` untuk mounting /home seperti ini:

```
# /home was on /dev/sda6 during installation
UUID=06c1b622-6537-4998-a392-28df2dd79519 /home           ext4    defaults        0       2
```

Saya ubah menjadi:

```
# /home was on /dev/sda6 during installation
UUID=06c1b622-6537-4998-a392-28df2dd79519 /data           ext4    defaults        0       2

# the /home now bind to /data/ubuntu
/data/ubuntu /home none bind 0 0

```
Untuk mengidentifikasi partisi sebaiknya menggunakan UUID, karena lebih permanen dibandingkan 'dev/sda' atau dengan label partisi. Sekarang ubuntu akan menaruh /home/$USER di /data/ubuntu/$USER, [fungsinya sama seperti perintah `mount --bind` di terminal](http://serverfault.com/questions/613179/how-do-i-do-mount-bind-in-etc-fstab). Hal yang sama saya lakukan juga untuk file `/etc/fstab` di arch. Cek dan croscek UUID dikedua distro menggunakan perintah `blkid` (membutuhkan elevasi root).

Langkah selanjutnya untuk mounting storage external, beberapa distro memiliki path yang berbeda untuk automount removable storage, di ubuntu berada di /media/$USER/(nama-storage) dan di arch berada di /run/media/$USER/(nama-storage). Hanya bertambah penulisan 4 karakter tapi untuk jangka panjangnya berpengaruh sekali. Jadi saya memutuskan untuk mount external HDD saya di /mnt untuk kedua distro ini.

```
# Toshiba external hdd
# make sure ntfs-3g package is installed
UUID=636683E80CB77EED 				/mnt/TOSHIBA 	ntfs-3g 	exec,permissions,auto 		0 0
```

Seperti yang tertulis dicomment, package `ntfs-3g` dibutuhkan, tidak semua distro otomatis menginstall ini disaat instalasi OS. Selanjutnya di external HDD tersebut saya membuat beberapa folder bernama Documents, Music, Downloads, Pictures, dan Videos. Folder - folder tersebut nantinya juga akan di mount bind seperti ini:

```
# mount bind Documents
/mnt/TOSHIBA/Documents 				/home/alexforsale/Documents 	ntfs-3g 			bind 	0 0

# mount bind Downloads
/mnt/TOSHIBA/Downloads 				/home/alexforsale/Downloads 	ntfs-3g 			bind	0 0

# mount bind Music
/mnt/TOSHIBA/Music 				/home/alexforsale/Music 	ntfs-3g 			bind 	0 0

# mount bind Pictures
/mnt/TOSHIBA/Pictures 				/home/alexforsale/Pictures 	ntfs-3g 			bind 	0 0

# mount bind Videos
/mnt/TOSHIBA/Videos 				/home/alexforsale/Videos 	ntfs-3g 			bind 	0 0
```

Semua mounting diatas seperti sudah cukup jelas, folder - folder seperti Music, Videos, dan Pictures di mount agar aplikasi - aplikasi default dari OS-nya (seperti music player, video player, image viewer dan sebagainya) dapat mencari file media yang sesuai didalam folder /home, dan untuk mempermudah proses penyimpanan file media tersebut (seperti misalnya screenshot dan lainnya).

Save file `/etc/fstab` tersebut dan reboot OS-nya untuk menjalankan file tersebut, atau bisa saja langsung di test dengan perintah `mount -a` tetapi pastikan terlebih dahulu semua mount point yang dicantumkan difile tersebut ada. Dan *pastikan* user id dan gid di kedua OS tersebut sama, untuk username saya seperti ini:

```
[alexforsale@archlinux ~]$ id $USER
uid=1000(alexforsale) gid=1000(alexforsale) groups=1000(alexforsale),10(wheel)
[alexforsale@archlinux ~]$ groups $USER
wheel alexforsale
[alexforsale@archlinux ~]$ 
```

Karena jika berbeda nantinya akan ada masalah permission untuk mengakses file yang dishare di fstab. Biasanya untuk uid dan guid selalu 1000:1000 jika untuk user pertama yang dibuat, lebih detail mengenai users dan groups bisa dibaca di [wiki archlinux](https://wiki.archlinux.org/index.php/Users_and_groups) yang sudah sangat lengkap.

