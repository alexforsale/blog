---
layout: post
title: Dokumentasi modifikasi Arch
tags: [blog, arch, linux, install]
---

Akhirnya [arch](https://www.archlinux.org/) sudah terpasang diPC saya! Setelah sebelumnya sekali percobaan install gagal karena terus terang saja, yang bisa melakukan install archlinux manual tanpa kesalahan dalam sekali coba sangat hebat sekali. Inipun saya juga sudah membuat partisinya sebelum memulai, karena menggunakan parted atau fdisk untuk memodifikasi partisi masih sangat menakutkan bagi saya.

Kesulitan pertama adalah untuk menyambung ke internet menggunakan wifi. Terakhir kali saya harus melakukan koneksi via terminal juga waktu instalasi arch pertama kalinya (lebih dari setahun yang lalu kira - kira). Dan diperparah dengan nama interface yang panjang (wlp0s26u1u1) yang membuat saya tambah malas lagi. Untungnya ada file install.txt yang berada di folder root lumayan membantu untuk step - step install-nya.

Modifikasi awal yang saya lakukan adalah [memodifikasi file `/etc/fstab`](/post/2017-01-22-modifikasi-fstab-linux), [setup lagi jekyll dan apache](2017-01-21-jekyll-dan-apache) untuk keperluan blog ini (bisa dibilang tampilan di localhost sebagai soft publish untuk mengecek hasil akhir).

Sampai ke penulisan post ini, baru package nvidia, gnome, dan beberapa package networking yang terpasang. Rencananya post ini akan menjadi dokumentasi saya dalam *setting up archlinux*

### ~/.bashrc

Sepertinya yang perlu saya lakukan pertama kali adalah memodifikasi `~/.bashrc` di arch, yang sangat minimalistik:

```
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
```

Install package `bash_completion` dan tambahkan baris ini ke `~/.bashrc`:

```
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

```

Ini saya ambil dari `.bashrc` ubuntu, sangat berguna untuk TAB-completion sehingga meminimalisir pengetikan, masih ada beberapa lagi yang bisa diimpor dari `.bashrc` ubuntu, seperti:

```
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
```

Keterangan fungsi - fungsi-nya sudah jelas di comment, tambahan yang saya dapat dari [wiki arch tentang bash](https://wiki.archlinux.org/index.php/Bash):

- Tambah fitur untuk command not found (butuh package `pkgfile`) tambahkan:

```
source /usr/share/doc/pkgfile/command-not-found.bash
```

- Auto cd ke directory (jadi tinggal ketik langsung path-nya) tambahkan:

```
shopt -s autocd
```

Akan muncul harinya dimana saya belajar vi, tapi bukan hari ini:

```
export EDITOR=nano
```

### Gnome Terminal

Kebiasaan lama menekan kombinasi CTRL-ALT-T sepertinya masih dibutuhkan, jadi itu hal pertama yang perlu dilakukan untuk gnome-terminal. Setting-nya ada di All-settings - keyboard, lalu dipaling bawah ada tanda + besar, tinggal tambahkan gnome-terminal di command dan edit shortcut-nya. Untuk setting transparency sepertinya harus menggunakan AUR, dan karena tidak terlalu penting bisa ditunda sampai ada kebutuhan lain yang lebih mendesak dan harus menggunakan AUR.

### AUR

Penjelasan lebih detail mengenai [AUR bisa dilihat diwiki langsung](https://wiki.archlinux.org/index.php/Arch_User_Repository). Jadi untuk mencari package yang tidak dimaintain oleh repo arch resmi, kemungkinan besar ada di repo [AUR](https://aur.archlinux.org/), kita tinggal mencarinya saja. Kebanyakan tutorial menyarankan kita untuk menggunakan salah satu dari sekian banyak AUR helper yang tersedia, ada banyak pilihan untuk ini, saya memilih yaourt karena sebelumnya ini yang saya gunakan dulu.

Step opsional sebelumnya adalah menyiapkan folder khusus untuk menyimpan repository git AUR, saya memiliki folder /data/source/AUR yang sengaja dibuat untuk tempat cloning repository git dari AUR. Package yaourt membutuhkan package [package-query](https://aur.archlinux.org/packages/package-query/) yang tidak tersedia direpository official (bisa dicek diweb-nya), jadi clone package tersebut terlebih dahulu.

```
cd /data/source/AUR
git clone https://aur.archlinux.org/package-query.git
Cloning into 'package-query'...
remote: Counting objects: 33, done.
remote: Compressing objects: 100% (32/32), done.
remote: Total 33 (delta 1), reused 32 (delta 1)
Unpacking objects: 100% (33/33), done.
```

Masuk ke folder package-query dan jalankan perintah `makepkg` tanpa elevasi root (jika memang membutuhkan root akan diminta).

```
cd package-query
makepkg -si
```

- `-s`/`--syncdeps` secara otomatis meresolve dan install dependencies yang dibutuhkan menggunakan `pacman` disini password root akan diminta jika diperlukan.
- `-i`/`--install` otomatis install package-nya jika build berjalan sukses.

Beberapa flag lain yang mungkin berguna:

- `r`/`rmdeps` akan menghapus dependencies yang dibutuhkan hanya ketika proses build dijalankan, biasanya tidak diperlukan lagi jika build sukses, tapi mungkin diperlukan jika package tersebut diupdate nantinya.
- `-c`/`--clean` hapus file - file compiling setelah selesai build, karena memang tidak lagi dibutuhkan.

Jika proses build-nya selesai tanpa error, cd kembali ke AUR dan clone repository yaourt-nya

```
cd ..
[alexforsale@archlinux AUR]$ git clone https://aur.archlinux.org/yaourt.git
Cloning into 'yaourt'...
remote: Counting objects: 22, done.
remote: Compressing objects: 100% (19/19), done.
remote: Total 22 (delta 3), reused 22 (delta 3)
Unpacking objects: 100% (22/22), done.

```

Masuk kedalam folder yaourt, dan kembali jalankan perintah `makepkg`.

```
cd ../yaourt
makepkg -si
```

Cek packagenya dengan perintah `yaourt -V`

```
✘-1 /data/source/AUR/yaourt [master|…106] 
18:33 $ yaourt -V
yaourt 1.8.1
homepage: http://archlinux.fr/yaourt-en

```

Dan yaourt sudah terinstall.
