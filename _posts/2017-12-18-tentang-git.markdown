---
layout: post
title: Tentang Git
subtitle: Pengenalan Awal Git - Seri pengenalan git dari https://git-scm.com/
tags: [git]
description: 
---

Git adalah free software yang didistribusikan menggunakan Gnu General Public License version 2, awalnya dibuat oleh Linus Torvald ditahun 2005 untuk memanage perkembangan dari kernel linux, seiring dengan semakin banyaknya jumlah developer yang ikut bergabung dalam proyek tersebut.

# Git

Git merupakan version control system(VCS), yang berfungsi untuk tracking perubahan pada file dan mengkoordinasikannya orang - orang lain. Penggunaan utamanya adalah sebagai source code management dalam software development, tapi sebenarnya bisa digunakan untuk jenis file apa saja.

## Instalasi

Git tentunya ada di repository arch, cukup install dengan `sudo pacman -S git`, sebagian dari konfigurasi standar sudah saya bahas di[sini]({{ site.baseurl }}{% post_url 2017-01-23-arch-is-live  %}), namun untuk kelengkapan post ini akan saya cantumkan juga. Dan juga jika belum pernah, buat akun [Github](https://github.com/), atau [Gitlab](https://gitlab.com/).

## Penggunaan

Ini adalah tutorial simpel untuk penggunaan git.

### Buat satu repository git

Misal kita ingin membuat satu repository dalam sebuah folder:

```shell
mkdir ~/Project
cd ~/Project
git init
```

akan ada informasi bahwa repository kosong telah dibuat difolder tersebut. Walaupun misalnya didalam folder tersebut sudah ada beberapa file, namun karena kita belum menambahkannya kedalam repository, git tidak akan men-track-nya. Satu perintah yang akan sering diketik adalah `git status`. Perintah ini akan memperlihatkan status dari repository, dan menginformasikan jika ada perbedaan antara file dengan commit HEAD saat ini.

Sebagai ilustrasi, kita buat file `README` dalam folder tersebut, dan cek output dari `git status`.

```shell
touch README
git status
```

Hasilnya adalah:

{% highlight shell %}
alexforsale in ~/Project on master ● λ git status
On branch master

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	README

nothing added to commit but untracked files present (use "git add" to track)
{% endhighlight %}

File `README` yang baru saja kita buat dideteksi oleh git sebagai `untracked files`

#### Environment staging dan commits

Salah satu bagian yang mungkin membingungkan ketika belajar git adalah konsep environment dari staging dan hubungannya dengan commit.

Commit adalah record atau catatan dari file apa saja yang berubah sejak commit terakhir dibuat. Simpelnya, jika kita membuat perubahan dalam repo(sekecil apapun), lalu kita menginformasikan git untuk push perubahan file tersebut kedalam sebuah commit.

Commit merupakan esensi dari sebuah project dan commit memungkinan kita untuk kembali ke salah satu bentuk dari project tersebut kapan saja.

Jadi bagaimana cara kita memberitahukan git file apa saja yang perlu dicommit? Disinilah staging environment(atau index) berperan. Seperti terlihat dicontoh sebelumnya, ketika kita membuat perubahan pada repository, git mengetahui ada perubahan pada repository(muncul satu untracked file) tapi belum melakukan tindakan apapun(seperti membuat commit).

### Menambahkan file baru di staging environment

Ketik `git add README`. Dan jika kita melihat dengan perintah `git status`, kita dapat melihat bahwa git sudah menambahkan file tersebut kedalam staging environment.

```shell
alexforsale in ~/Project on master ● λ git status
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

	new file:   README
```

Disini terlihat file `README` sudah masuk kedalam staging, dari informasi `Changes to be committed:`, dan juga petunjuk untuk unstage-nya jika kita ingin mengeluarkannya dari staging area. Ini berfungsi untuk menandai sebuah file sudah kita anggap siap untuk di commit, namun kita masih belum siap untuk melakukan sebuah commit, mungkin jika dalam repository tersebut ada banyak file yang akan kita masukkan dalam satu commit, atau kita perlu melakukan serangkaian test pada file tersebut(misalnya compiling atau lainnya).

{: .box-note }
**Note:** Jika kita membuat perubahan pada file yang sudah dalam keadaan staging, maka ketika kita melihat output dari `git status` akan terlihat file tersebut akan berada didalam bagian `Changes to be commited` dan `Changes not staged for commit`. Karena file tersebut sudah berubah semenjak terakhir dimasukkan kedalam staging, kita memiliki pilihan untuk menambahkan perubahan baru tersebut kedalam staging, menggunakan `git add`, atau membuang perubahan tersebut menggunakan `git checkout -- <namafile>` untuk kembali kedalam keadaan file ketika terakhir kita masukkan kedalam staging(`git add` terakhir).

Kita buat perubahan dalam file `README`:

```shell
echo "this is a readme file" > README
git add README
```

### Commit

Jika kita sudah puas dengan keadaan repository saat ini dan ingin merekamnya kedalam git, saatnya kita buat sebuah commit:

```shell
git commit -m `my first commit!`
```

{: .box-note}
Kita bisa langsung melakukan commit dan menambahkan semua file yang berubah semenjak commit terakhir(**tidak termasuk file untracked**) dengan perintah `git commit -a`

`-m` atau `--message` disini adalah isi pesan/log dari commit, yang ditandai dengan `' '` atau `" "`. Jika kita tidak mencantumkan `-m` atau `--message` maka kita akan dibawa kedalam editor untuk mengetikkan isi pesan/log.

{: .box-note}
Jika tidak kita set sebelumnya, editor yang digunakan adalah yang ditentunkan oleh `shell`, bisa dicheck dengan perintah `echo $EDITOR`, biasanya antara `vi` atau `nano`, kita bisa tentukan sendiri pilihan editor yang kita inginkan khusus untuk git, misal kita ingin emacs dengan perintah `git config --global core.editor emacs`.

Sampai disini merupakan alur sederhana dari penggunaan git. Kita terus melakukan perkembangan pada repository tersebut dengan cara yang sama, setiap kali kita puas dengan perubahan, penambahan, atau mungkin penghapusan file kita lakukan pembuatan commit baru.

![alur git](https://git-scm.com/book/en/v2/images/lifecycle.png "alur git")

### Ignoring file file tertentu

Terkadang ada file - file tertentu yang tidak perlu di track oleh git, bahkan tidak perlu terlihat sebagai `untracked files`. Biasa seperti file - file yang generated secara otomatis seperti file log. Untuk hal seperti ini kita bisa buat sebuah file dengan list pattern - pattern dengan nama `.gitignore`, file atau folder dengan awalan `.` akan tersembunyi namun masih bisa ditrack oleh git. Ini contoh file `.gitignore`:

```shell
*.[oa]
*~
```

Baris pertama berarti semua file dengan ekstensi ".o" atau ".a", object atau archive yang biasanya muncul setelah compiling. Baris kedua merupakan format dari file temporary, biasa digunakan oleh text editor seperti emacs. Membuat file `.gitgignore` sebaiknya dilakukan sebelum repository mulai berjalan untuk meminimalisir penambahan file yang tidak kita perlu secara tidak disengaja.

### Melihat perubahan staged dan unstaged

Tambahkan dua baris rule ignore diatas kedalam file `.gitignore` lalu masukkan kedalam commit baru:

```shell
git add .gitignore
git commit -m 'tambah file .gitignore'
```

Jika kita cek history dari repository:

```shell
git status
```

```
commit 2ab97fb330b8555444e24cda5cec26fe237da71b (HEAD -> master)
Author: alexforsale <alexforsale@yahoo.com>
Date:   Mon Dec 18 12:45:39 2017 +0700

    tambah file .gitignore

commit e75f756c67a29c468421b72dd3215699d47f6f8e
Author: alexforsale <alexforsale@yahoo.com>
Date:   Mon Dec 18 12:45:24 2017 +0700

    my first commit!
```

Terlihat ada dua commit yang sudah kita buat, dengan tambahan informasi author, tanggal commit, isi pesan/log, dan ID commit, yang merupakan checksum SHA-1 yang berfungsi sebagai identitas dari setiap commit.

Misal kita buat penambahan baru dalam repository kita:

```shell
cat > README << 'EOF'
```

perintah tersebut akan menunggu input kita, kita masukkan text ini kedalamnya(dengan kombinasi copy/paste)

```
# Project Title

One Paragraph of project description goes here
```

Ketik 'ENTER' lalu setelahnya ketik `EOF` lalu 'ENTER' lagi, untuk mengakhiri perintah diatas. Seperti biasa jika kita melakukan perintah `git status` kita dapat melihat bahwa file `README` telah dimodifikasi, tetapi hal ini masih kurang jelas, seperti apa sebenarnya perubahannya? Disini kita bisa gunakan perintah `git diff`, kita akan sering gunakan perintah ini untuk menjawab dua pertanyaan: apa saja yang berubah namun belum masuk staging? Dan apa saja yang telah di stage dan akan dicommit? Walau sebenarnya kedua pertanyaan ini dijawab oleh `git status` juga, `git diff` memperlihatkan baris yang berubah/dihapus(atau biasa disebut patch).

Kita lihat output dari `git diff`

```
diff --git a/README b/README
index 5b65f7b..a910def 100644
--- a/README
+++ b/README
@@ -1 +1,3 @@
-this is a readme file
+# Project Title
+
+One Paragraph of project description goes here
```

Hasilnya adalah perubahan yang kita buat namun belum di staged. Kita masukkan perubahan ini kedalam sebuah commit baru:

```shell
git commit README -m 'tambah Project Title'
```

Sebagai contoh lain, kita buat tambahan file baru bernama `CONTRIBUTING.md`

```shell
cat > CONTRIBUTING.md << 'EOF'
```

Lalu masukkan baris - baris ini:

```
# Contributing

When contributing to this repository, please first discuss the change you wish to make via issue,
email, or any other method with the owners of this repository before making a change. 

Please note we have a code of conduct, please follow it in all your interactions with the project.

```

Seperti biasa, ketik 'ENTER' lalu ketik 'EOF' dan sudahi dengan 'ENTER' lagi. Kita masukkan file tersebut kedalam staging dengan `git add CONTRIBUTING.md`, namun ternyata kita ingin melakukan penambahan lagi di file tersebut:

```shell
cat >> CONTRIBUTING.md << 'EOF'
```

Perhatikan ada dua tanda `>>` yang berarti `append` atau menambahkan, kita tambah dengan:

```
## Pull Request Process

1. Ensure any install or build dependencies are removed before the end of the layer when doing a 
   build.
2. Update the README.md with details of changes to the interface, this includes new environment 
   variables, exposed ports, useful file locations and container parameters.
3. Increase the version numbers in any examples files and the README.md to the new version that this
   Pull Request would represent.
4. You may merge the Pull Request in once you have the sign-off of two other developers, or if you 
   do not have permission to do that, you may request the second reviewer to merge it for you.

```

Sekarang file `CONTRIBUTING.md` berada dalam staging dan juga not staged:

```shell
alexforsale in ~/Project on master ● ● λ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	new file:   CONTRIBUTING.md

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   CONTRIBUTING.md
```

Namun kita bisa melihat lebih jelasnya dengan `git diff`

```
diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
index d0979ee..a40b6f2 100644
--- a/CONTRIBUTING.md
+++ b/CONTRIBUTING.md
@@ -4,3 +4,14 @@ When contributing to this repository, please first discuss the change you wish t
 email, or any other method with the owners of this repository before making a change. 
 
 Please note we have a code of conduct, please follow it in all your interactions with the project.
+## Pull Request Process
+
+1. Ensure any install or build dependencies are removed before the end of the layer when doing a 
+   build.
+2. Update the README.md with details of changes to the interface, this includes new environment 
+   variables, exposed ports, useful file locations and container parameters.
+3. Increase the version numbers in any examples files and the README.md to the new version that this
+   Pull Request would represent.
+4. You may merge the Pull Request in once you have the sign-off of two other developers, or if you 
+   do not have permission to do that, you may request the second reviewer to merge it for you.
+
```

Dan kita bisa melihat apa saja yang sudah kita staged dengan `git diff --staged` atau `git diff --cached`:

```
diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
new file mode 100644
index 0000000..d0979ee
--- /dev/null
+++ b/CONTRIBUTING.md
@@ -0,0 +1,6 @@
+# Contributing
+
+When contributing to this repository, please first discuss the change you wish to make via issue,
+email, or any other method with the owners of this repository before making a change. 
+
+Please note we have a code of conduct, please follow it in all your interactions with the project.
```

Kita commit lagi perubahan ini:

```shell
git commit CONTRIBUTING.md -m 'tambah file CONTRIBUTING.md'
```

{: .box-note}
Jika kita melakukan `git commit -m 'tambah file CONTRIBUTING.md'` maka perubahan yang akan dicommit hanya yang sudah berada didalam staging. Berguna jika kita ingin membuat commit yang lebih spesifik.

### Menghapus file

Untuk menghapus file dari git, kita harus menghapusnya dari tracked files dan melakukan sebuah commit untuk itu. Bisa dilakukan dengan `git rm` yang juga menghapus file dari repository sehingga kita tidak lagi melihatnya sebagai untracked files.

Sebagai contoh kita buat satu file kosong dengan nama `PROJECTS.md` dan sudah kita masukkan kedalam commit.

```shell
touch PROJECTS.md
git add .
git commit -m 'tambah file PROJECTS.md'
```

`git add .` berarti menambahkan semua didalam folder tersebut, terkecuali semua file yang tercantum didalam `.gitignore`. Hati - hati dengan perintah ini. Oke, file `PROJECTS.md` ternyata merupakan kesalahan, kita ingin menghapusnya. Kita hapus dengan `rm` hasilnya seperti ini:

```shell
rm PROJECTS.md
git status
On branch master
Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	deleted:    PROJECTS.md

no changes added to commit (use "git add" and/or "git commit -a")
```

File tersebut muncul dibagian `changes not staged for commit`, jika kita jalankan perintah `git rm` maka penghapusan file tersebut akan dimasukkan kedalam staging:

```shell
git rm PROJECTS.md
rm 'PROJECTS.md'
git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	deleted:    PROJECTS.md
```

Begitu kita commit:

```shell
git commit PROJECTS.md -m 'hapus file PROJECTS.md'
```

File tersebut sudah tidak ada didalam repository. Misal sebelumnya file tersebut sudah berada didalam staging, kita harus menambahkan `-f` ketika menghapusnya.

### Moving file

Didalam git ada perintah `git mv` yang bisa berfungsi untuk merename file. Sebagai contoh:

```
alexforsale in ~/Project on master λ git mv README README.md
alexforsale in ~/Project on master ● λ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	renamed:    README -> README.md
```

Sebenarnya ini sama seperti:

```
mv README README.md
git rm README
git add README.md
```

### Melihat Commit History

Setelah kita membuat beberapa commit, kita mungkin perlu melihat kebelakang untuk mengetahui apa - apa saja yang telah terjadi. Kita sudah coba sebelumnya dengan `git log`, secara default perintah ini akan memperlihatkan commit secara reverse-chronological, artinya commit yang terbaru berada dipaling atas.


## Push ke remote repository

Kita ambil contoh disini menggunakan [Github](https://github.com/), tentunya setelah kita membuat satu akun. Fungsi dari repository remote ini adalah untuk melakukan kolaborasi dengan user lain dalam repository yang sama. Ikuti petunjuk didalam web untuk proses pembuatan repository-nya, gunakan nama project yang sama dengan repository lokal untuk mempermudah, namun tidak wajib sebenarnya.

Didalam web setelah kita membuat repository baru akan ada petunjuk juga untuk push repository lokal kita ke remote. Sebagai contoh:

```shell
git remote add origin https://github.com/namauser/projects.git
git push -u origin master
Counting objects: 3, done.
Writing objects: 100% (3/3), 263 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To https://github.com/namauser/projects.git
 * [new branch]      master -> master
Branch master set up to track remote branch master from origin
```

Disini perintah `git remote add origin https://github.com/namauser/projects.git` artinya adalah menambahkan sebuah repository remote dengan nama `origin`(ini bisa apa saja) dengan url yang sudah ditentukan ketika proses pembuatan remote di web.

Secara default setiap kali kita membuat repository git, kita berada didalam branch `master`, lebih mengenai branching mungkin didalam sebuah post khusus.
