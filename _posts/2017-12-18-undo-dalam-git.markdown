---
layout: post
title: Undo dalam git
subtitle: Git Basic - Seri Pengenalan git dari https://git-scm.com/
tags: [git]
description: 
---

Seandainya ada tombol undo di kehidupan nyata...

# Proses Undo dalam git

Suatu saat pasti kita membutuhkan untuk kembali kedalam keadaan repository sebelumnya dan merubah kesalahan yang terjadi dalam waktu itu. Kita akan coba mereview beberapa tool basic yang biasa digunakan. Ini adalah beberapa area dalam git dimana kita dapat kehilangan data jika kita melakukan kesalahan.

## Amend
Salah satu kasus undo yang umum terjadi jika kita commit terlalu dini dan melupakan satu atau lebih file, atau kita salah dalam menulis isi commit message. Jika kita ingin mengulang kembali commit tersebut, lakukan perubahan tambahan yang tadi kita lupa, dan commit kembali dengan tambahan `--amend`:

```shell
git commit --amend
```

Perintah ini akan membawa semua file di staging dan menggunakannya untuk commit, jika kita tidak membuat perubahan lain sejak commit terakhir yang salah itu, maka snapshotnya akan terlihat sama dan yang berubah hanyalah commit message saja(itupun jika diubah).

Editor yang muncul akan menampilkan commit message yang sebelumnya dan bisa kita edit.

## Melepas file dari staging

Anggaplah kita sudah membuat perubahan di dua file project kita, me-rename `README.md` menjadi `README` dan membuat perubahan isi file `CONTRIBUTING.md`. Kita ingin membuat dua commit terpisah untuk kedua file tersebut namun secara tidak sengaja mengetik perintah `git add .`. Bagaimana cara melepas salah satu dari file tersebut? Jika seperti ini kita masih bisa melihat output dari `git status`:

```shell
git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

    renamed:    README.md -> README
    modified:   CONTRIBUTING.md
```

Kita ikuti saran dia dan ketik perintah:

```shell
git reset HEAD CONTRIBUTING.md
Unstaged changes after reset:
M	CONTRIBUTING.md
git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

    renamed:    README.md -> README

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

    modified:   CONTRIBUTING.md
```

Kita akan kembali kepada `git reset` mungkin dalam post yang berbeda(**mungkin**).

## Mengembalikan file yang dimodifikasi

Bagaimana jika ternyata kita tidak ingin menyimpan perubahan di file `CONTRIBUTING.md`? Untungnya git status masih memberikan solusi untuk ini juga. Cukup jalankan perintah:

```shell
git checkout -- CONTRIBUTING.md
git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

    renamed:    README.md -> README
```


## Kembali ke beberapa commit yang lalu

Seandainya mesin waktu ada didalam kehidupan nyata... Tapi didalam git hal tersebut mungkin terjadi, ambil contoh seperti ini dalam repository project kita: Kita sedang break sejenak dari aktifitas, dan mencoba mereview semua commit yang kita buat sejak pagi tadi, kita bisa melihat hasil dari `git log --oneline`:

```shell
d38c5de (HEAD -> master) fix paragraph sebelumnya, dan tambah Our standard
1f91e9d Tambah Prerequisites, instruksi installing, Running tests dan breakdown into end to end tests.
55c17f6 tambah getting started, code of conduct dan our pledge
af5b331 fix paragraph
45e9dea ubah README menjadi README.md
f31d0f2 hapus file PROJECTS.md
e9ed298 tambah file PROJECTS.md
2b1ec45 tambah file CONTRIBUTING.md
8b96753 tambah Project Title
2ab97fb tambah file .gitignore
e75f756 my first commit!
```

Semua terlihat baik - baik saja, tapi karena kita sedang benar - benar senggang, kita coba lihat output yang lebih lengkap, `git log --patch`. Perintah ini membuat output dari `git log` menjadi patch(lebih mengenai ini (**mungkin**) dipost lain. Hasilnya seperti ini:

```shell
commit d38c5de8f4d2b5253b44303ff12520dc6e58771a (HEAD -> master)
Author: alexforsale <alexforsale@yahoo.com>
Date:   Tue Dec 19 00:03:01 2017 +0700

    fix paragraph sebelumnya, dan tambah Our standard

diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
index 895a129..4d8c0cb 100644
--- a/CONTRIBUTING.md
+++ b/CONTRIBUTING.md
@@ -19,6 +19,26 @@ These instructions will get you a copy of the project up and running on your loc
 
 ### Our Pledge
 
-In the interest of fostering an open and welcoming environment, we as contributors and maintainers pledge to making participation in our project and our community a harassment-free experience for everyone, regardless of age
, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and
-orientation.
+In the interest of fostering an open and welcoming environment, we as contributors and maintainers pledge to making participation in our project and our community a harassment-free experience for everyone, regardless of age
, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation.
 
+## Our Standards
+
+Examples of behavior that contributes to creating a positive environment
+include:
+
+* Using welcoming and inclusive language
+* Being respectful of differing viewpoints and experiences
+* Gracefully accepting constructive criticism
+* Focusing on what is best for the community
+* Showing empathy towards other community members
+
+Examples of unacceptable behavior by participants include:
+
+* The use of sexualized language or imagery and unwelcome sexual attention or
+advances
+* Trolling, insulting/derogatory comments, and personal or political attacks
+* Public or private harassment
+* Publishing others' private information, such as a physical or electronic
+  address, without explicit permission
+* Other conduct which could reasonably be considered inappropriate in a
+  professional setting
```

Output yang sadis ya? Intinya kita iseng - iseng melihat semua diff yang dihasilkan dari log tersebut, dan melihat ada satu kesalahan fatal:

```shell
commit 55c17f65269deecf27907ff34acc8f1cf37652f8
Author: alexforsale <alexforsale@yahoo.com>
Date:   Mon Dec 18 23:59:00 2017 +0700

    tambah getting started, code of conduct dan our pledge

diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
index 6d9868b..895a129 100644
--- a/CONTRIBUTING.md
+++ b/CONTRIBUTING.md
@@ -4,6 +4,10 @@ When contributing to this repository, please first discuss the change you wish t
 
 Please note we have a code of conduct, please follow it in all your interactions with the project.
 
+## Getting Started
+
+These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.
+
 ## Pull Request Process
 
 1. Ensure any install or build dependencies are removed before the end of the layer when doing a build.
@@ -11,3 +15,10 @@ Please note we have a code of conduct, please follow it in all your interactions
 3. Increase the version numbers in any examples files and the README.md to the new version that this Pull Request would represent. 
 4. You may merge the Pull Request in once you have the sign-off of two other developers, or if you do not have permission to do that, you may request the second reviewer to merge it for you.
```

Jadi di commit ini kita membuat kesalahan menempatkan konten, semestinya `Getting started` berada di file `README.md`. Kita harus membetulkannya di commit tersebut(tidak masuk akal karena contoh ini hanya dokumen text ya? Tapi anggap aja isi file tersebut sebuah kode programming dan sampai saat ini masih luput dari build error tapi kita tahu itu adalah sebuah kesalahan yang fatal). Rumitnya lagi, kesalahan tersebut berhubungan dengan kedua file dalam project ini.

Bagaimana solusinya? kita bisa menggunakan `git rebase`. Ini adalah sebuah tool yang **berbahaya**, karena bisa mengacak - acak history dari sebuah repository. Namun untuk mengetahui kalau api itu panas kita harus membakar tangan kita terlebih dahulu kan? Jadi mari kita coba:

### Git rebase

Kita tidak akan membahas terlalu dalam mengenai `git rebase` ini(pertama karena saya juga masih belum paham benar). Kita melakukan ini karena memang sangat dibutuhkan dan kebetulan kita belum push perubahan direpository lokal kita ke repository remote(lebih mengenai ini nanti).

Pertama kita tahu commit yang bermasalah di `55c17f6` atau lengkapnya `55c17f65269deecf27907ff34acc8f1cf37652f8`, **kita akan melakukan rebase ke commit sebelum commit yang akan kita edit**, kita cek lagi melalui perintah `git log --oneline`:

```shell
git log --oneline
d38c5de (HEAD -> master) fix paragraph sebelumnya, dan tambah Our standard
1f91e9d Tambah Prerequisites, instruksi installing, Running tests dan breakdown into end to end tests.
55c17f6 tambah getting started, code of conduct dan our pledge
af5b331 fix paragraph
45e9dea ubah README menjadi README.md
f31d0f2 hapus file PROJECTS.md
e9ed298 tambah file PROJECTS.md
2b1ec45 tambah file CONTRIBUTING.md
8b96753 tambah Project Title
2ab97fb tambah file .gitignore
e75f756 my first commit!
(END)
```

Jadi kita tahu kita harus rebase ke commit `af5b331`, kita lakukan rebase dengan opsi `--interactive` karena disitu kita bisa memilih secara interactive commit apa saja yang perlu diedit.

{: .box-note}
**Note:** Pastikan repository dalam keadaan "bersih" sebelum melakukan rebase.

```shell
git rebase --interactive af5b331
```

hasilnya kita akan masuk ke editor seperti ini:

```
pick 55c17f6 tambah getting started, code of conduct dan our pledge
pick 1f91e9d Tambah Prerequisites, instruksi installing, Running tests dan breakdown into end to end tests.
pick d38c5de fix paragraph sebelumnya, dan tambah Our standard

# Rebase af5b331..d38c5de onto af5b331 (3 commands)
#
# Commands:
# C-c C-c  tell Git to make it happen
# C-c C-k  tell Git that you changed your mind, i.e. abort
# p        move point to previous line
# n        move point to next line
# M-p      move the commit at point up
# M-n      move the commit at point down
# SPC      show the commit at point in another buffer
# RET      show the commit at point in another buffer and select its window
# C-_      undo last change
# k        drop the commit at point
# y        insert a line for an arbitrary commit
# z        add noop action at point
# c        pick = use commit
# r, w     reword = use commit, but edit the commit message
# e, m     edit = use commit, but stop for amending
# s        squash = use commit, but meld into previous commit
# f        fixup = like "squash", but discard this commit's log message
# x        exec = run command (the rest of the line) using shell
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
# Note that empty commits are commented out
```

Tambahan informasi(semua yang berawal dengan tanda `#`) berarti perintah ini memang benar - benar berbahaya ditangan mereka yang lemah. Oke, ada tiga commit yang akan diproses dalam rebase ini, kita hanya perlu merubah commit bermasalah dari keadaan `pick` menjadi `edit` (dieditor saya dengan `e` atau `m` karena saya menggunakan `emacsclient`, editor lain mungkin berbeda). Oke, sepertinya sudah benar, taruh kursor didepan baris commit yang akan kita ubah, ketik `e` atau `m`, save buffer(nama lain dari file yang sedang dibuka di `emacs`) lalu exit dan berdoa semoga semua tatasurya berada dalam posisi yang benar. Dan output-nya seperti ini:

```shell
git rebase --interactive af5b331
Stopped at 55c17f6...  tambah getting started, code of conduct dan our pledge
You can amend the commit now, with

  git commit --amend '-S'

Once you are satisfied with your changes, run

  git rebase --continue
```

Oke kita sudah kembali kemasa lampau, disini semua orang masih berkomunikasi dengan mulut, dan masih membaca berita dari koran, buku dan majalah. Kita melihat ada figur masyarakat penting yang dimasa depan akan mengalami kejadian fatal, kita bisa memberikan peringatan, tetapi bukan itu tujuan kita ke masa lalu. Kita disini untuk membetulkan satu commit!

Oke kedua file tersebut sudah kita edit, bagian `Getting Started` yang tadinya ada didalam file `CONTRIBUTING.md` kita pindahkan ke file `README.md`, lengkapnya seperti ini:

```
diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
index 895a129..5b6a2d3 100644
--- a/CONTRIBUTING.md
+++ b/CONTRIBUTING.md
@@ -4,10 +4,6 @@ When contributing to this repository, please first discuss the change you wish t
 
 Please note we have a code of conduct, please follow it in all your interactions with the project.
 
-## Getting Started
-
-These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.
-
 ## Pull Request Process
 
 1. Ensure any install or build dependencies are removed before the end of the layer when doing a build.
diff --git a/README.md b/README.md
index a910def..3c271ec 100644
--- a/README.md
+++ b/README.md
@@ -1,3 +1,7 @@
 # Project Title
 
 One Paragraph of project description goes here
+
+## Getting Started
+
+These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.
(END)
```

Kita lakukan `git commit --amend` dengan tambahan `-S` yang diinstruksikan, karena commit tersebut di `sign`, jika tidak diinstruksikan tidak perlu ditambahkan!

```shell
git add .
git commit --amend -S
```

kita add kedua file karena memang keduanya harus dilakukan perubahan, setelah kita lakukan `git commit --amend -S` kita lakukan instruksi yang diberikan begitu kita sampai dimasa lalu, kita lakukan `git rebase --continue` dan berharap dimasa depan tidak ada perubahan yang tidak diinginkan.

Masalah pertama menghadang:

```
git rebase --continue
Auto-merging README.md
CONFLICT (content): Merge conflict in README.md
error: could not apply 1f91e9d... Tambah Prerequisites, instruksi installing, Running tests dan breakdown into end to end tests.

Resolve all conflicts manually, mark them as resolved with
"git add/rm <conflicted_files>", then run "git rebase --continue".
You can instead skip this commit: run "git rebase --skip".
To abort and get back to the state before "git rebase", run "git rebase --abort".

Could not apply 1f91e9d... Tambah Prerequisites, instruksi installing, Running tests dan breakdown into end to end tests.
```

Jadi ada conflict di commit setelahnya. Kita cek melalui `git status`

```
git status
interactive rebase in progress; onto af5b331
Last commands done (2 commands done):
   edit 55c17f6 tambah getting started, code of conduct dan our pledge
   pick 1f91e9d Tambah Prerequisites, instruksi installing, Running tests dan breakdown into end to end tests.
Next command to do (1 remaining command):
   pick d38c5de fix paragraph sebelumnya, dan tambah Our standard
  (use "git rebase --edit-todo" to view and edit)
You are currently rebasing branch 'master' on 'af5b331'.
  (fix conflicts and then run "git rebase --continue")
  (use "git rebase --skip" to skip this patch)
  (use "git rebase --abort" to check out the original branch)

Unmerged paths:
  (use "git reset HEAD <file>..." to unstage)
  (use "git add <file>..." to mark resolution)

	both modified:   README.md
```

Disitu tertera `both modified` untuk file `README.md`, kita coba cek melalui `git diff` hasilnya seperti ini:

```

diff --cc README.md
index 3c271ec,1902e56..0000000
--- a/README.md
+++ b/README.md
@@@ -2,6 -2,41 +2,47 @@@
  
  One Paragraph of project description goes here
  
++<<<<<<< HEAD
 +## Getting Started
 +
 +These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.
++=======
+ ### Prerequisites
+ 
+ What things you need to install the software and how to install them
+ 
+ ```
+ Give examples
+ ```
+ 
+ ### Installing
+ 
+ A step by step series of examples that tell you have to get a development env running
+ 
+ Say what the step will be
+ 
+ ```
+ Give the example
+ ```
+ 
+ And repeat
+ 
+ ```
+ until finished
+ ```
+ 
+ End with an example of getting some data out of the system or using it for a little demo
+ 
+ ## Running the tests
+ 
+ Explain how to run the automated tests for this system
+ 
+ ### Break down into end to end tests
+ 
+ Explain what these tests test and why
+ 
+ ```
+ Give an example
+ ```
+ 
++>>>>>>> 1f91e9d... Tambah Prerequisites, instruksi installing, Running tests dan breakdown into end to end tests.
```

Terlihat conflictnya yang membuat git tidak dapat melanjutkan ke commit berikutnya, kedua conflict tersebut dipisahkan dengan tanda `<<<<<<<` dan diakhiri dengan `=======` di setiap conflict-nya, git tidak mau melanjutkan karena posisi yang semestinya sesuai dengan history awal sebelum kita kemasa lalu(di commit `1f91e9d`) sudah kita isi dengan commit kita(ditandai dengan `HEAD`). Dari sini saja sudah terlihat betapa berbahaya nya `git rebase` kan? Disini kita cukup hapus kedua tanda indikator tersebut dan gabungkan menjadi satu dokumen, setelahnya kita bisa kembali melanjutkan perjalanan kemasa depan. Tapi bayangkan jika yang direbase adalah project source code!

Selesai wejangan orang tua-nya, kita edit file `README.md` save lalu masukkan ke staging,

```shell
git add README.md
```

Namun kita tidak melakukan `git commit --amend` disini! Kita sudah cukup mengacak - acak history, yang kita lakukan disini adalah "menyesuaikan" isi commit `1f91e9d` agar sesuai dengan perubahan yang kita buat dimasa lalu(coba pikirkan seandainya commit `1f91e9d` ternyata milik orang lain yang berkolaborasi dengan kita menggunakan repository yang sama... Dan ini kita bahkan belum berbicara mengenai `branch`).

Kita lakukan kembali `git rebase --continue`, sebelum lanjut ke commit berikutnya kita masuk ke editor lagi untuk commit message di commit ini(`1f91e9d`), cukup save lalu exit hingga commit terkini(dengan catatan tidak ada conflict lagi).

Sepertinya semua terlihat baik - baik saja dari konten kedua file tersebut ya? Untuk memastikan kita coba bandingkan hasil dari `git log --oneline` sebelum rebase dengan setelahnya:

| Sebelum Rebase                                                             | Setelah Rebase                                                                 |
| d38c5de (HEAD -> master) fix paragraph sebelumnya, dan tambah Our standard | **a2ec0dc (HEAD -> master) fix paragraph sebelumnya, dan tambah Our standard** |
| 1f91e9d Tambah Prerequisites, instruksi installing...                      | **07d17c0 Tambah Prerequisites, instruksi installing...**                      |
| 55c17f6 tambah getting started, code of conduct dan our pledge             | **4fd5ac5 tambah getting started, code of conduct dan our pledge**             |
| af5b331 fix paragraph                                                      | af5b331 fix paragraph                                                          |
| 45e9dea ubah README menjadi README.md                                      | 45e9dea ubah README menjadi README.md                                          |
| f31d0f2 hapus file PROJECTS.md                                             | f31d0f2 hapus file PROJECTS.md                                                 |
| e9ed298 tambah file PROJECTS.md                                            | e9ed298 tambah file PROJECTS.md                                                |
| 2b1ec45 tambah file CONTRIBUTING.md                                        | 2b1ec45 tambah file CONTRIBUTING.md                                            |
| 8b96753 tambah Project Title                                               | 8b96753 tambah Project Title                                                   |
| 2ab97fb tambah file .gitignore                                             | 2ab97fb tambah file .gitignore                                                 |
| e75f756 my first commit!                                                   | e75f756 my first commit!                                                       |

Commit yang kita ubah menggunakan rebase (mulai dari `55c17f6` sampai ke `HEAD`) checksum SHA-1 nya semua berubah! Jika ini adalah sebuah repository lokal yang tidak dipush ke repository remote dan merupakan project pribadi tidak menjadi masalah, tapi coba bayangkan seandainya ini adalah sebuah repositry publik, dan commit yang kita rebase melewati banyak commit yang bisa jadi di-commit oleh orang lain. Jika seperti itu kasusnya `git rebase` sangat tidak disarankan, lebih baik buat commit baru dengan penjelasan yang mendetail mengenai commit tersebut.

