---
layout: post
title: Command line email dengan msmtp dan yahoo mail
tags: [blog, linux, mail, yahoo, gmail, smtp, msmtp]
---

Package yang perlu diinstall: [msmtp](https://www.archlinux.org/packages/?name=msmtp) dan opsional, [msmtp-mta](https://www.archlinux.org/packages/?name=msmtp-mta) yang akan membuat alias `sendmail` ke msmtp. Dan [s-nail](https://www.archlinux.org/packages/?name=s-nail) agar kita bisa mengirim email dengan perintah `mail` (di arch saya package s-nail sudah terinstall). Semua package tersebut diinstall menggunakan *pacman*.

File konfigurasi untuk msmtp bisa disimpan di `~/.msmtprc` (untuk konfigurasi per-user), atau secara system-wide di `/etc/msmtprc`. Disini saya menyimpannya di `~/.msmtprc` karena hanya akan digunakan oleh user saya saja.

Didalam file konfigurasinya kita bisa membuat lebih dari satu account, dan bisa dipilih dengan perintah `msmtp -a` atau `--account=`. Pertama kita buat terlebih dahulu file `~/.msmtprc`, bisa menggunakan *nano* atau editor lain.

```
nano ~/.msmtprc
```

Isi dengan:

```
# Set default values for all following accounts.
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        ~/.msmtp.log

# Gmail
account        gmail
host           smtp.gmail.com
port           587
from           username@gmail.com
user           username
password       plain-text-password

# Yahoo service
account        yahoo
host           smtp.mail.yahoo.com
port           587
from           username@yahoo.com
user           username
password       plain-text-password

# Set a default account
account default : yahoo #ganti gmail jika ingin menggunakan gmail
```

File konfigurasi ini permissionnya harus readable/writeable oleh ownernya, jadi set permissionnya dengan cara:

```
chmod 600 ~/.msmtprc
```
Disini saya sediakan dua account (yahoo dan gmail) yang keduanya memang saya gunakan. Masukkan username serta password-nya. Pilihan lain jika tidak ingin memasukkan password secara plain-text (karena bisa dibaca oleh orang lain yang membuka file ini misalnya), hapus kolom password dan ganti dengan baris ini:

Di bagian account yahoo:

```
passwordeval    "gpg --quiet --for-your-eyes-only --no-tty --decrypt ~/.msmtp-yahoo.gpg"
```

Dan di bagian account gmail

```
passwordeval    "gpg --quiet --for-your-eyes-only --no-tty --decrypt ~/.msmtp-gmail.gpg"
```

Jika sebelumnya gpg belum pernah digunakan, kita harus generate key terlebih dahulu dengan perintah `gpg --gen-key`, jalankan semua instruksi yang diminta, dan biasanya ada dialog box muncul meminta untuk membuat password khusus, ini bukan password email, kalau menggunakan gnome itu muncul dari gnome-keyring, bisa dicheck nantinya setelah selesai menjalankan `gpg --gen-key` buka `seahorse` dan lihat dibagian pgp key.

Dan untuk memasukkan passwordnya kedalam file `~/.msmtp-gmail.gpg` kita gunakan perintah ini:

```
echo -e "password\n" | gpg --encrypt -o ~/.msmtp-gmail.gpg
```

Untuk password yahoo:

```
echo -e "password\n" | gpg --encrypt -o ~/.msmtp-yahoo.gpg
```

ganti kata "password" dengan password-nya, tapi jangan hapus "\n"-nya.

#### Test Kirim Mail

Jalankan perintah ini:

```
echo "hello there." | msmtp -a default username@domain.com
```

Tentunya ganti terlebih darhulu username@domain.com dengan alamat email yang ingin dikirim, dan jika melakukan enkripsi password dengan *passwordeval* diatas, akan muncul lagi dialog box yang meminta passphrase yang sebelumnya dibuat ketika dialog box pertama muncul. Bisa juga cek kirim ke email sendiri untuk memastikan.

Karena saya menggunakan 2 account, saya mencoba mengirim email dari masing - masing account ke account lainnya.

{% include image.html
    img="/img/post/msmtp-yahoo.png"
    title="screenshot" %}

Jika package [msmtp-mta](https://www.archlinux.org/packages/?name=msmtp-mta) juga terinstall, perintah *msmtp* bisa diganti dengan *sendmail*.
