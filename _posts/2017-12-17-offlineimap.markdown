---
layout: post
title: offlineimap
subtitle: sync imaps server
tags: [email, sync]
description: 
---

Di post kemarin, saya mencoba untuk menggunakan [getmail sebagai mail retriever]({{ site.baseurl }}{% post_url 2017-12-14-mutt-dan-getmail %}), walaupun getmail berfungsi sebagai mana mestinya, tapi kurangnya fitur sync 2 arah membuat saya terus mencari alternatif lain.

Dan saya menemukan [offlineimap](http://www.offlineimap.org/), sesuai namanya software ini memungkinkan kita untuk membaca mail secara offline dan mampu sync 2 arah melalui IMAP.

## Instalasi

Cukup jalankan perintah `sudo pacman -S offlineimap`, dan offlineimap sudah terpasang. Tentunya kita perlu melakukan konfigurasi terlebih dahulu. offlineimap mendukung lebih dari satu account, namun karena saya hanya menggunakan satu account(untuk saat ini), konfigurasi yang saya gunakan hanya memakai satu account. Cek ke [wiki archlinux](https://wiki.archlinux.org/index.php/OfflineIMAP) atau dokumentasi [offlineimap](http://www.offlineimap.org/documentation.html) untuk informasi lebih lanjut.

Konfigurasi default untuk offlineimap berada di `~/.offlineimaprc`, ada dua file contoh yang bisa dijadikan acuan, `/usr/share/offlineimap/offlineimap.conf` berisi dokumentasi setiap settings secara mendetail, dan `/usr/share/offlineimap/offlineimap.conf.minimal` yang tanpa comment.

Masih mengacu ke post saya [sebelumnya]({{ site.baseurl }}{% post_url 2017-12-14-mutt-dan-getmail %}), konfigurasi yang saya lakukan adalah untuk Gmail.

```
[general]
# nama akun, saya pilih yang mudah diingat tentunya.
accounts = gmail

# jumlah sync yang diperbolehkan secara bersamaan untuk 1 account.
maxsyncaccounts = 1

# jenis user interface yang diinginkan.
ui = TTYUI

# file python yang digunakan, file ini akan dipakai oleh offlineimap.
pythonfile = ~/.offlineimap.py

[mbnames]
# untuk integrasi dengan mailbox mutt/neomutt, sesuaikan filename dengan lokasi file
# konfigurasi mutt/neomutt
enabled = yes
filename = ~/.mutt/mailboxes
header = "mailboxes "
peritem = "+%(accountname)s/%(foldername)s"
sep = " "
footer = "\n"

[Account gmail]
# nama repository yang dipakai
localrepository = gmail-local
remoterepository = gmail-remote

# sync otomatis secara berkala, dalam satuan menit
autorefresh = 5

# jumlah quick update yang dilakukan sebelum melakukan full sync(autorefresh harush dicantumkan)
quick = 10

[Repository gmail-local]
# Jenis repository lokal
type = GmailMaildir

# lokasi repository lokal, folder IMAP akan di sync didalam folder ini.
localfolders = ~/.mail/gmail/

# folder translator, untuk menerjemahkan nama folder dari kedua repository, 
# NOTE: harus ditentukan dimasing - masing repository.
# disini [Repository gmail-local] berarti perubahan nama dari repository lokal.
nametrans = lambda folder: {'drafts':  '[Gmail]/Drafts',
                            'sent':    '[Gmail]/Sent Mail',
                            'trash':   '[Gmail]/Trash',
                            'archive': '[Gmail]/All Mail',
                            }.get(folder, folder)

# sinkronisasi deleted file atau folder, jika yes berarti file/folder yang dihapus
# di repository lokal akan dihapus juga di repository remote.
sync_deletes = yes

[Repository gmail-remote]
# jenis Repository remote, pilihannya hanya Gmail atau IMAP.
type = Gmail

# file cacert yang dipakai, dibawah ini lokasi untuk archlinux.
sslcacertfile = /etc/ssl/certs/ca-certificates.crt

# username remote, akun Gmail tentunya.
remoteuser = alexarians@gmail.com

# password, kita menggunakan remotepasseval = get_pass() yang akan dicek di pythonfile yang
# sebelumnya ditentukan
remotepasseval = get_pass()

# memaksa koneksi terus terbuka diantara jeda refresh (harus memakai autorefresh).
holdconnectionopen = yes

# jumlah detik diantara setiap keepalives, autorefresh dan holdconnectionopen harus diset.
keepalive = 60

# folder translator, untuk menerjemahkan nama folder dari kedua repository, 
# NOTE: harus ditentukan dimasing - masing repository.
# disini [Repository gmail-remote] berarti perubahan nama dari repository remote.
nametrans = lambda folder: {'[Gmail]/Drafts':    'drafts',
                            '[Gmail]/Sent Mail': 'sent',
                            '[Gmail]/Trash':     'trash',
                            '[Gmail]/All Mail':  'archive'}.get(folder, folder)

# filter folder - folder yang akan disync, disini berarti folder yang TIDAK akan disync.
folderfilter = lambda folder: folder not in ['[Gmail]/Chats',
                                             '[Gmail]/Important',
                                             '[Gmail]/All Mail',
                                             '[Gmail]/Spam',
                                             '[Gmail]/Starred']

# sinkronisasi deleted file atau folder, jika yes berarti file/folder yang dihapus
# di repository remote akan dihapus juga di repository lokal.
sync_deletes = yes
```

{: .box-note}
**Note:** Perhatikan nama folder yang ditentukan di `nametrans` dan `folderfilter`, sesuaikan terlebih dahulu dengan **label** yang sudah ada di Gmail.

{: .box-note}
Tentukan label yang ingin disync di `folderfilter` terlebih dahulu, di konfigurasi saya label yang **tidak** disync(karena perintahnya `folder not in`).

{: .box-note}
`folderfilter` memakai nama label dari Gmail, jadi untuk beberapa label default(didalam Gmail namanya system labels), memakai awalan `[Gmail]`, seperti `[Gmail]/Chats`, jika di dalam Gmail namanya adalah `Chats`.

{: .box-note}
`nametrans` harus ditentukan di kedua Repository. Jika kita merubah satu label di lokal, tentunya harus kita kembalikan lagi diremote agar offlineimap tahu nama asli label tersebut.

{: .box-note}
Cek dengan Gmail, jangan dengan Google Inbox(<https://inbox.google.com/>), lihat dari url-nya. Untuk melihat semua label <https://mail.google.com/mail/u/0/#settings/labels>

### Password management

Kita buat file `~/.offlineimap.py` yang sebelumnya sudah kita tentukan di `~/.offlineimaprc`.

{% highlight python %}
#! /usr/bin/env python2
from subprocess import check_output

def get_pass():
    return check_output("gpg -dq ~/.offlineimappass.gpg", shell=True).strip("\n")
{% endhighlight %}

Disini kita define `get_pass()`. Lalu kita buat file `~/.offlineimappass`(tanpa extensi .gpg) berisi password Gmail, dan encrypt menggunakan gpg.

{% highlight shell %}
cd ~
echo "password-Gmailnya" > ~/.offlineimappass
gpg --encrypt --recipient KEY-ID ~/.offlineimappass
rm ~/.offlineimappass
{% endhighlight %}

Pastikan kita sudah memiliki key gpg, untuk melakukan enkripsi dan dekripsi. Coba jalankan offlineimap melalui terminal untuk melakukan sinkronisasi awal,

## Jalankan offlineimap sebagai systemd service

Jika kita install offlineimap melalui pacman, tersedia systemd timer yang bisa kita gunakan, cukup di start/atau enable melalu systemctl.

## Integrasi dengan Mutt/Neomutt.

Kita cukup menambahkan ini di `~/.mutt/muttrc`:

```
source ~/.mutt/mailboxes
```

Tentunya karena sebelumnya saya sudah menggunakan `getmail` berarti saya melakukan sync dua kali untuk akun gmail saya. Tetapi melihat fitur - fitur yang disediakan oleh offlineimap menurut saya ini bukanlah pengorbanan sia - sia. :smile:
