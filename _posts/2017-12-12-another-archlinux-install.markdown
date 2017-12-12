---
layout: post
title: Another Archlinux Install
subtitle: sebuah proyek necromancery, part I?
tags: arch,linux,installation
bigimg: /img/post/IMG_20171212_223908.jpg
description: 
---
# I'm Back
Saya kembali, ke Bekasi. _the home is where the heart is_ katanya... konon. Mengadu nasib sepertinya susah untuk _orang yang tidak memiliki nasib_. _But anyway,_ ini topik post yang dimaksud untuk hari ini: **Instalasi archlinux disebuah Ancient PC**

## <a name="atas"></a>Kenapa harus arch?
Ini sebuah pertanyaan klasik yang sering ditanyakan, dan parahnya lagi, sering dijawab oleh semua orang. Bertanya "mengapa distro ini lebih baik dari itu?" sebenarnya sama saja seperti menanyakan "Kenapa lebih suka makanan ini daripada makanan itu?" Tentunya setiap jenis makanan memiliki kualitas yang berbeda dibandingkan makanan lain, sama halnya seperti distro linux, jika bertanya kepada orang Padang "kenapa sih suka makan rendang?", sama saja seperti bertanya kepada penggemar archlinux "kenapa sih selalu archlinux?"

Berbeda halnya jika pertanyaan yang diajukan adalah "Mengapa archlinux di PC tersebut?" [Ini jawabannya](https://pastebin.com/P1nv1BYz). Archlinux menjadi pilihan ideal karena:
* Installer yang benar2 ramping

  Release awal bulan Desember ini size installer-nya hanya sekitar 500mb. Tentunya butuh download tambahan ketika proses instalasi dimulai, tetapi distro lain yang installer-nya dilengkapi dengan _packaging_ yang lengkap pun setelah instalasi tetap harus di update juga. Tambah lagi, _package - package_ yang disediakan oleh distro lain tersebut belum tentu ideal untuk PC ini. Seperti hanya sambal, beda mulut tentu beda rasa.
* Freedom for the people!

  Minimnya packaging yang diberikan oleh archlinux biasanya yang menyebabkan orang malas. Tetapi disisi lain, buat saya ini seperti sebuah kertas kosong yang belum ada coretan (banyak). Saya cukup install apa yang saya perlu di PC ini. Seandainya lupa, **Intel(R) Pentium(R) Dual  CPU  E2160  @ 1.80GHz**.
  
## Kondisi sang pasien
Setelah mencari semua bagian - bagian dari si PC ini di seantero rumah, dan percobaan pertama ketika dinyalakan tidak ada power. Tombol power yang semestinya menyala biru berpendaran merah selayaknya anak indigo sama sekali tidak ada nyawa. Layar monitor tetap hitam seperti masa depan negeri ini.

Dugaan pertama ada di power supply, hanya saja karena tidak tersedia kotak P3K dirumah, saya copot power supply dan bawa ke rumah sakit terdekat(yang menerima pasien power supply tentunyaa). Dugaan yang tepat karena kata si dokter(yang juga hanya bisa mendiagnosa power supply) power supply yang saya bawa sudah tidak bisa tertolong lagi, bahkan menurut si dokter power supply tersebut sudah mati lama.

Akhirnya saya beli power supply second karena buat apa beli barang baru buat ditaruh dirumah lama? Sepanjang perjalanan pulang saya memikirkan filosofi ini terus...

## Tanda kehidupan
PC sialan ini akhirnya menyala setelah dipasang power supply yang baru(tapi lama) ini. Tapi masalah baru muncul: monitor masih kelam... Saya copot vga card dan coba bersihkan seikhlas mungkin, lalu pasang kembali, tetap tidak menyala. Kali ini saya coba copot kembali vga card-nya, lalu pasang kabel monitor ke input vga onboard, dan layar menyambut dengan log BIOS, dan berhenti disitu... masalah baru menghadang, tetapi saya masih belum bisa menerima keadaan dan tetap memaksa untuk menarik sang VGA dari alam lain.

Setelah akhirnya saya menyerah dan ikhlas merelakan kepergian si vga card, lanjut ke masalah berikutnya. Ternyata dari 3 hard drive yang ada dirumah ini, hanya satu yang masih layak digunakan(note: kata layak disini masih sangat diragukan juga). Sialnya lagi hard drive yang survive justru bukan yang memiliki OS didalamnya. Ini juga jawaban dari pertanyaan di [atas](#atas).

# Ending itu sebenarnya adalah awal dari sebuah ending baru
Post ini judulnya **Another Archlinux Install** tapi sama sekali tidak ada kaitannya dengan instalasi ya? Anggap saja post ini sebuah prelude, seperi trilogi Star Wars yang diikuti dengan prequel, dilanjut dengan sequel yang konon akan diikuti oleh prequel lagi...
