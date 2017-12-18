---
layout: post
title: Tentang GPG
subtitle: Sebuah pengenalan
tags: [gpg, privacy, gnu]
description: sebagian besar dari artikel ini diambil secara kurang ajar dari https://www.futureboy.us/pgp.html
---

{: .box-note}
Arguing that you don't care about the right to privacy because you have nothing to hide is no different from saying you don't care about free speech because you have nothing to say. – Edward Snowden

Sebagian besar dari artikel ini dari [Archlinux Wiki](https://wiki.archlinux.org/index.php/GnuPG) dan [GPG Tutorial](https://futureboy.us/pgp.html) dari [alieasen](https://twitter.com/aeliasen).

# Gnu Privacy Guard

GPG, atau Gnu Privacy Guard, adalah free software yang dibuat sebagai pengganti untuk software suite [PGP](https://en.wikipedia.org/wiki/Pretty_Good_Privacy) [cryptographic](https://en.wikipedia.org/wiki/Cryptography) milik [Symantec](https://en.wikipedia.org/wiki/Symantec). GnuPG termasuk bagian dari [GNU Project](https://en.wikipedia.org/wiki/GNU_Project).

## Cryptography

Terlepas dari asumsi umum, cryptography bukanlah hal yang baru. Istilah tersebut bahkan sudah ada sejak abad ke-19. Dari sebuah novel karya Edgar Allan Poe, yang mengacu kepada enkripsi: mengubah informasi umum (plaintext) menjadi cyphertext menggunakan algoritma tertentu. Dekripsi (decryption) adalah sebaliknya, dengan chiper/chyper sebagai algoritma yang membuat enkripsi dan mengembalikannya (dekripsi).

Salah satu bentuk cryptograpy kuno dalam bentuk transposition cypher, yang mengacak urutan huruf dalam sebuah pesan, misalnya dari `Christian Alexander` menjadi `Alexandra Tench Iris` atau `Atiana Schindler Rex`. Dan subtition cypher, yang mengganti huruf atau sekumpulan huruf dengan huruf atau sekumpulan huruf lainnya, seperti misalnya:

{: .box-note}
ABCDEFGHIJKLMNOPQRSTUVWXYZ

{: .box-note}
VWXYZABCDEFGHIJKLMNOPQRSTU


merupakan algoritma yang digunakan, sehingga:

{: .box-note}
Christian Alexander

menjadi:

{: .box-note}
XCMDNODVI VGZSVIYZM

## Public-Key Cryptography

Ini merupakan jawaban dari pertanyaan yang sangat kuno: "bagaimana cara kita berkomunikasi dengan seseorang tanpa perlu saling menginformasikan password rahasia terlebih dahulu?". Menginformasikan password rahasia, yang diperlukan untuk enkripsi/dekripsi secara aman merupakan masalahnya.

Dengan public-key encryption, tidak perlu untuk saling menukar atau menginformasikan sebuah password. Setiap orang memiliki "keypair" berisi "public-key" dan "private key". Setiap orang dapat menginformasikan public-key nya secara umum, atau memberikannya secara langsung kepada orang yang ingin diajak berkomunikasi tadi, tanpa harus menginformasikan "secret key" mereka.

Misal kita memiliki public-key seseorang, kita dapat:

- meng-enkripsi pesan yang hanya dapat dibuka(dekripsi) oleh orang tersebut, tentunya orang tersebut harus menggunakan secret key nya untuk dapat membuka pesan tersebut.
- Memastikan (validasi) bahwa pesan yang dikirim oleh orang tersebut di"sign" menggunakan secret key nya. Dengan ini juga bisa dipastikan pesan yang dikirim tidak corrupt atau diubah oleh orang lain.

Dengan secret key, kita dapat:

- Mendekripsi pesan yang dienkrip menggunakan public-key kita.
- Sign pesan yang bisa diverifikasi oleh orang lain bahwa pesan tersebut datang dari kita, orang lain membutuhkan public-key kita untuk verifikasi signature-nya.

# Menggunakan GPG

Umumnya hampir semua distro linux menyediakan package GPG dalam repository mereka, mungkin beberapa malah langsung menyediakannya dalam installer distro mereka. Cek menggunakan package manager dari distro yang digunakan, biasanya dengan nama package gnupg.

## Konfigurasi

Untuk konfigurasi default berada di folder `~/.gnupg` atau `$HOME`. Walau sebenarnya yang dicari pertama adalah `$GNUPGHOME`, biasanya ini tidak diset. Jadi jika ingin mengubah lokasi dari file konfigurasi bisa set `$GNUPGHOME` melalu startup files.

## <a name="Membuat Key Pair"></a>Membuat Key Pair

Jalankan perintah `gpg --full-gen-key` untuk generate full, atau cukup `gpg --gen-key` saja dari terminal. Perintah tersebut akan meminta respon kita untuk beberapa pertanyaan. Umumnya yang diperlukan adalah:

- Pada prompt jenis key yang diinginkan, pilih default `RSA and RSA`.
- Untuk key size, disarankan maksimum `4096`.
- Untuk validitas, pilih default (doesn't expire).
- Verifikasi ulang semua pilihan tadi.

## List Key

Untuk dapat melihat public-key didalam key-ring kita:

```
gpg --list-keys
```

Untuk melihat secret-key kita menggunakan perintah:

```
gpg --list-secret-keys
```

Sebagai contoh:

```
alexforsale in ~ λ gpg --list-key
/home/alexforsale/.gnupg/pubring.kbx
------------------------------------
pub   rsa2048/972B3C2D613E4AE9 2017-12-08 [SC]
```

Adalah public-key saya, setelah `RSA2048/`.

## Eksport Public Key

Tentunya untuk orang lain agar dapat mengirimkan encrypted message ke kita, mereka butuh public-key kita. Untuk generate public-key secara text(atau versi ASCII):

```
gpg --output public.key --armor --export user-ID
```

`User-ID` adalah ID dari public-key kita, misal untuk public-key saya `972B3C2D613E4AE9`. Outputnya menjadi file `public.key` yang bisa kita attach kedalam email untuk kita kirimkan.

### Menggunakan Keyserver

Kita bisa mengekspor public-key kita kedalam Keyserver, misalnya <sks-keyservers.net>, <search.keyserver.net>, atau <subkeys.pgp.net>.

```
alexforsale in ~ λ gpg --keyserver hkp://sks-keyservers.net --send-key 972B3C2D613E4AE9
gpg: sending key 972B3C2D613E4AE9 to hkp://sks-keyservers.net
alexforsale in ~ λ 
```

Untuk memastikan:

```
alexforsale in ~ λ gpg --keyserver hkp://sks-keyservers.net --search-keys alexforsale@yahoo.com
gpg: data source: http://sks-keyservers.net:11371
(1)	Christian Alexander <alexarians@gmail.com>
	Christian Alexander <alexforsale@hotmail.com>
	Christian Alexander <christian.alexander@ymail.com>
	Christian Alexander <elasrofxela.alexander@yahoo.co.id>
	Christian Alexander <christian.alexander@rocketmail.com>
	Christian Alexander <christian.alexander@windowslive.com>
	Christian Alexander (my second key) <alexforsale@yahoo.com>
	  2048 bit RSA key 972B3C2D613E4AE9, created: 2017-12-08
```

## Mengimpor key

Ada banyak cara yang dapat digunakan untuk mengimpor key orang lain, akan lebih mudah jika orang yang ingin kita impor key-nya sudah mem-publish-nya kedalam keyserver. Menggunakan perintah:

```
gpg --keyserver hkp://sks-keyservers.net --recv-keys KEYID
```

## Enkripsi/Dekripsi Menggunakan GPG

### Asymmetric

Kita membutuhkan public-key dari orang yang akan kita kirimkan file enkripsi tersebut, tentunya kita harus sudah memiliki keypair sendiri untuk enkripsinya.

```
gpg --recipient user-id --encrypt file
```

Dimana `--recipient` adalah orang yang akan menerima `file` yang kita encrypt.

Untuk dekripsi file dengan nama `file.gpg` yang diencrypt menggunakan public-key kita:

```
gpg --output file --decrypt file.gpg
```

Sebaiknya kita menambahkan `--armor` ketika meng-enkripsi (ASCII lebih mudah untuk copy/paste dalam format text).

### Symmetric

Enkripsi symmetric tidak membutuhkan keypair dan dapat digunakan untuk enkripsi data menggunakan passphrase. Gunakan `--symmetric` atau `-c`:

```
gpg -c file
```

Selesai ketik ENTER kita akan diminta untuk membuat passphrase.

Contoh berikut menggunakan:

- symmetric cipher menggunakan passphrase.
- Algoritma AES-256 cipher untuk enkripsi passphrase.
- Algoritma SHA-512 digest untuk mengacak passphrase.
- Mengacak passphrase dengan 65536 iterasi

```
gpg -c --s2k-cipher-algo AES256 --s2k-digest-algo SHA512 --s2k-count 65536 file
```

Untuk dekripsinya:

```
gpg --output doc --decrypt file.gpg
```

## Key Maintenance

### Backup private key

```
gpg --export-secret-keys --armor ID > secret.key
```

Untuk importnya sama seperti import public-key.

```
gpg --import secret.key
```

Simpan file tersebut ditempat yang aman.

### Edit key

Menjalankan perintah `gpg --edit-key ID` akan memberikan kita pilihan untuk memodifikasi key kita. Beberapa diantaranya:

- passwd: untuk mengubah password key.
- clean: untuk membersihkan dari ID yang sudah direvoke atau expired.
- revkey: untuk revoke key.
- addkey: untuk menambahkan subkey.
- expire: mengubah masa berlaku key.
- adduid: menambahkan identitas kedalam key, seperti email baru.

ketik `help` untuk melihat list perintah - perintah yang dapat dijalankan.

### <a name="Membuat revoke"></a>Membuat revoke

Ini step yang sebenarnya sangat penting, jika kita kehilangan keypair kita, dan kita tidak melakukan revoke, orang lain akan menganggap key kita masih bisa kita gunakan. Dan untuk revoke key kita membutuhkan secret-key. Jadi jika kita tidak membuat file certificate revocation sekarang, kita tidak dapat menggunakannya ketika key kita hilang, dan kita tidak dapat merevoke key tersebut.

```
gpg -a --gen-revoke ID
```

Akan ada beberapa prompt pertanyaan, dan kita akan diminta passphrase diakhirnya. Certificate revoke-nya akan seperti ini:

```
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.2.3 (SunOS)
Comment: A revocation certificate should follow

iEkEIBECAAkFAkBQW9oCHQAACgkQ1XM5fJGtheGdYgCdGLN32ck9F3CL3lb2Rbef
weZOg00An3gedAc9chK5aSAAnjCwRC0Vftsv
=luxm
-----END PGP PUBLIC KEY BLOCK-----
```

bisa disimpan kedalam file text. Dan untuk melakukan proses revoke-nya:

```
gpg --recv-keys <public-key-yang-akan-direvoke>
gpg --import <file-yang-berisi-revoke-certificate>
gpg --send-key <public-key-yang-akan-direvoke>
```

Mayoritas dari keyserver saling bertukar informasi satu sama lainnya, jadi dalam waktu yang tidak terlalu lama tentunya *gossip* revokasi tersebut sudah menyebar.

## Signature

### Membuat Signature

#### sign file

Gunakan flag `--sign` atau `-s`

```
gpg --output file.sig --sign file
```

`file.sig` berisi isi yang dicompressed dari `file` dan juga signature dalam format binary, namun file tidak dienkrip. Bisa dienkripsi juga sekaligus.

### clearsign file

Untuk sign sebuah file tanpa harus meng-kompresi-nya kedalam format binary:

```
gpg --output file.sig --clearsign file
```

Dengan perintah diatas `file` dan signature nya disimpan dalam format yang dapat dibaca, dengan nama `file.sig`.

### detached signature

Dengan `--detach-sign` kita memisahkan signature kedalam file yang berbeda dari file yang kita sign:

```
gpg --output file.sig --detach-sig file
```

Signature akan disimpan dalam `file.sig` tapi isi dari `file` tidak akan dimasukkan kedalam file tersebut. Ini metode yang umumnya digunakan.

### Verifikasi Signature

Gunakan `--verify`

```
gpg --verify file.sig
```

Jika kita verifikasi file dengan signature detached, kedua file harus berada dalam lokasi yang sama. Misal kita ingin verifkasi file iso archlinux:

```
gpg --verify archlinux-version.iso.sig
```

dan file `archlinux-version.iso` juga harus berada dalam directory yang sama.

## Verifikasi Key

Melihat semua yang dijelaskan diatas, membuat keypair sebenarnya sangat mudah, dan orang dapat membuat keypair dengan *sembarang email*, dan orang dapat dengan mudahnya *mengirim key tersebut ke semua keyserver*. Memastikan ke bahwa key tersebut valid hanya dengan mengacu ke email-nya saja tidak memberikan kepastian. Selalu validasi ke orang yang bersangkutan langsung untuk memastikan bawha itu key dia.

### fingerprint

Key dapat diverifikasi dengan banyak cara, misal kita dapat membacakan seluruh public-key, yang tentunya rentan kesalahan, dan memakan waktu lama. Alternatif umumnya adalah membandingkan fingerprint antara fingerprint yang kita anggap milik orang tersebut, dan fingerprint dari si orang tersebut.

Fingerprint adalah angka singkat yang biasanya di-*hash* secara cryptography dari public-key. Lebih pendek dari isi public-key tentunya. Misal seseorang telah mengimpor public-key saya, ketik:

```
gpg --fingerprint alexforsale@yahoo.com
```

```
alexforsale in ~ λ gpg --fingerprint alexforsale@yahoo.com
pub   rsa2048/972B3C2D613E4AE9 2017-12-08 [SC]
      Key fingerprint = 2751 7709 E592 F14C 5A51  D90B 972B 3C2D 613E 4AE9
uid                 [ultimate] Christian Alexander (my second key) <alexforsale@yahoo.com>
```

Dan cukup verifikasi key fingerprint saja untuk memastikan bahwa ini key yang saya pakai.

## Sign key

Setelah kita memastikan identitas dari key dan orang tersebut, kita perlu menginformasikan kepada software yang kita gunakan bahwa kita percaya key tersebut. Tanpa ini biasanya software yang kita gunakan(entah gpg atau lainnya) akan memberikan peringatan bahwa kita berkomunikasi dengan key yang belum dapat dipastikan.

```
gpg --sign-key alexforsale@yahoo.com
```

Ada opsi yang lebih bagus lagi:

```
gpg --interactive --sign-key alexforsale@yahoo.com
```

Ketik `help` ketika berada didalam mode interaktif tersebut, yang diperlukan hanyalah sign dan trust. Setelah kita sign kita export kembali key tersebut:

```
gpg --export --armor alexforsale@yahoo.com
```

Dan kirimkan ke orang yang bersangkutan. Misal ini dikirim ke saya(dan memang key saya yang di sign), saya cukup ketik `gpg --import`.

Kita juga bisa upload key yang sudah kita sign kedalam keyserver.

## Update Key

Orang - orang biasanya meng-update key mereka untuk berbagai alasan:

- Key yang dicuri orang lain, atau direvoke.
- Key disign oleh orang lain,
- Dan orang yang merubah Algoritma enkripsi key mereka.

Key yang diupdate dapat dipublish kedalam keyserver, termasuk signature - signature baru. Kita dapat update key - key yang ada didalam key ring kita dengan cara:

```
gpg --refresh-keys
```

Ini memastikan key - key yang kita gunakan tidak dalam kondisi revoked. Terkadang orang lain bisa sign key kita dan mempublish-nya ke keyserver. Dengan refresh key kita bisa mengetahui jika key kita diupdate.


## Migrasi ke Key baru

Terkadang kita butuh untuk generate public-key baru, dan tidak lagi menggunakan yang lama

### Generate key baru

Cara ini sama seperti di[awal](#Membuat Key Pair).

### Bedakan antara key lama dengan key baru

Sepanjang post ini, kita mengidentifikasi key kita dengan menggunakan email. Namun, begitu kita memiliki lebih dari satu key dengan email yang sama, akan menjadi cukup rumit. GPG akan menggunakan secret key pertama yang didapat, kecuali kita menentukannya secara eksplisit. Jadi kita harus mengetahui ID dari key lama dan key baru.

Kita dapat melihat secret key dengan cara:

```
gpg --list-secret-keys
```

Atau,

```
gpg -K
```

Kita dapat membedakannya dengan melihat creation date.

### Buat certificate revocation untuk key yang baru

Ikuti proses [revoke](#Membuat revoke), dengan ID key yang baru. Tentunya bedakan filename nya.

### Sign key yang baru menggunakan key yang lama.

```
gpg -u ID-lama --sign-key ID-baru
```

`-u` atau `--local-user` memilih key mana yang melakukan signing.

### Trust signature key lama

```
gpg -u ID-baru --interactive --edit-key ID-lama
```

Ambil pilihan `trust` lalu `save`.

### Buat key baru sebagai default

#### Melalui gpg.conf

tambahkan pilihan `default-key ID-baru` didalam file `~/.gnupg/gpg.conf`, tentunya ini tidak berlaku untuk semua software, misalnya *enigmail* memiliki preferensi tersendiri.

#### Menggunakan `-u ID-baru`

Sangat tidak disarankan, walaupun misal kita memakai `alias`.

#### Disable key lama dalam key-ring

```
gpg --interactive --edit-key ID-lama
```

Didalamnya pilih `disable` diikuti dengan `save`.

### Informasikan key baru kepada orang yang memiliki key lama

Salah satu cara dengan membuat file berisi dokumentasi migrasi key baru, mungkin beserta alasannya, key lama dan key baru, dan sign file tersebut dengan ID-lama:

```
gpg -u ID-lama --clearsign file
```

### Impor signature baru

Orang lain mungkin akan sign key kita secara public dan mengembalikannya kepada kita, atau menguploadnya kedalam keyserver. Pastikan kita refresh secara berkala.

### Upload key baru kedalam keyserver

Penting jika orang lain sign key baru kita dan mengembalikannya langsung ke kita, karena signature mereka tidak akan muncul dalam keyserver public jika tidak ada yang menguploadnya.

### Revoke key lama

Key yang sudah direvoke bukan berarti sama sekali tidak berguna, karena masih bisa digunakan untuk verifikasi signature yang kita buat sebelumnya, hanya saja sudah tidak bisa digunakan lagi untuk enkripsi. Namun masih dapat digunakan untuk dekripsi file - file sebelumnya selama kita masih memiliki akses ke secret-key -nya. Selalu lakukan refresh-key setelah revoke.




## Menggunakan Public-Key baru orang lain

Orang lain juga generate key baru, kita perlu memastikan key tersebut valid, dan kita menggunakan key baru mereka bukan yang lama.

### Import key baru mereka

Jika mereka mengirimkan langsung kepada kita, cukup dengan `gpg --import`, baik dengan nama file yang mereka berikan, atau langsung paste key mereka kedalam terminal(gunakan `CTRL-D` untuk mengakhiri).

Atau bisa langsung import dari keyserver jika orang tersebut sudah upload. Validasi Fingerprint jika melalui keyserver.

### Bedakan ID-lama dan ID-baru mereka

Lihat dari creation date di `gpg --list-key <email>`, dan kembali, pastikan kepada orang yang bersangkutan.

### Validasi key baru dengan orang yang bersangkutan

Perlu diingat, setiap orang dapat membuat key dengan alamat email siapapun juga.

```
gpg --check-sigs ID-baru-nya
```

Dari outputnya kita dapat melihat misalnya ID-lama orang tersebut sign ID-baru ini.

### Sign key baru ini

Begitu kita memastikan key ini valid, sign key dengan ID-baru tersebut. Namun pastikan perintahnya menggunakan ID-baru, bukan menggunakan email.

### Kirim key kembali

Bisa kepada orangnya langsung, melalui email, atau melalui keyserver.

### Disable key lama mereka

Atau jika menggunakan software lain selain GPG, lebih baik menggunakan `gpg --delete-keys ID-lama` agar tidak muncul di software tersebut.
