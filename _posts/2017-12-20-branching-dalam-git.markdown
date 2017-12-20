---
layout: post
title: Branching dalam git
subtitle: Git Basic - Seri Pengenalan git dari https://git-scm.com/
tags: [git]
description: 
---

Branching merupakan hal umum dalam VCS, yang bertujuan untuk memisahkan dari jalur development utama dan melanjukan development tanpa harus mengganggu jalur development utama tadi.

Banyak orang yang menganggap branching dalam git merupakan fitur yang paling diandalkan dan memisahkan git dari VCS lainnya. Branching dalam git sangat spesial karena lebih "lightweight" dibandingkan yang lain, perpindahan branch sangat cepat. Tidak seperti VCS lain, git justru menyarakan alur kerja yang sering menggunakan banyak branch dan banyak merging branch.

## Branching secara simpel

Untuk lebih mengerti cara git melakukan branch, sebelumnya kita mesti mengerti cara git menyimpan datanya.

Git tidak menyimpan data sebagai sekumpulan dari perubahan atau diffs, tapi git menyimpan data sebagai sekumpulan dari snapshots.

Ketika kita membuat commit, git menyimpan object commit yang berisi pointer ke snapshot dari konten yang kita stage. Object ini juga berisi username dan email si pembuat commit tersebut, commit message, dan pointer ke commit atau sekumpulan commit yang ada sebelum commit yang baru dibuat ini (parents): nol parent untuk commit awal/pertama, satu parent untuk commit normal, dan lebih dari satu parent untuk commit yang dihasilkan dari penggabungan dua branch atau lebih(merging).

Seperti ini contoh yang dibuat oleh [git-scm](https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell):

Anggaplah kita memiliki satu folder yang berisi tiga file, kita stage semua lalu commit. Proses staging tersebut menghasilkan sebuah checksum untuk masing - masing file (hash SHA-1), menyimpan versi file - file di repository git(dalam git disebut "blob"), dan menambahkan checksum tersbut ke staging area.

``` shell
$ git add README test.rb LICENSE
$ git commit -m 'The initial commit of my project'
```

Waktu kita membuat commit dengan `git commit`, git membuat checksum dari masing masing subfolder(jika ada) dan menyimpan object tree tersebut didalam repository git. Lalu git membuat object commit yang memiliki metadata dan sebuah pointer ke project tree root agar bisa membuat ulang snapshot tersebut jika diperlukan.

Repository git ini sekarang memiliki 5 object: satu blob untuk setiap 3 file, satu tree yang mendata isi dari folder dan menentukan nama file untuk setiap blob-nya, dan satu commit dengan pointer ke tree root dan semua metadata commit.

![commit dan tree-nya](https://git-scm.com/book/en/v2/images/commit-and-tree.png)

Jika kita membuat perubahan lalu membuat commit lagi, commit berikutnya menyimpan pointer ke commit sebelumnya

![commit dan parent-nya](https://git-scm.com/book/en/v2/images/commits-and-parents.png)

Sebuah branch dalam git simpelnya hanyalah pointer ringan yang dapat digerakkan dari salah satu commit ini. Branch default dalam git adalah `master`. Semakin kita membuat commit, kita diberikan sebuah branch `master` yang menunjukkan (pointer) ke commit terakhir yang kita buat. Setiap kali kita membuat commit baru, pointer tersebut bergerak maju secara otomatis.

![branch dan history commit-nya](https://git-scm.com/book/en/v2/images/branch-and-history.png)

Apa yang terjadi ketika kita membuat branch baru? Kita menciptakan sebuah pointer baru, anggaplah kita membuat branch baru bernama "testing". Kita lakukan dengan perintah `git branch`:

``` shell
git branch testing
```

Ini membuat pointer baru ke commit yang sama dengan commit kita sekarang.

![2 branch menunjuk ke seri commit yang sama](https://git-scm.com/book/en/v2/images/two-branches.png)

Bagaimana cara git mengetahui branch kita sekarang? Git menyimpan pointer khusus bernama `HEAD`. Ini merupakan pointer ke branch lokal kita sekarang. Dalam hal ini kita masih berada didalam branch `master`, perintah `git branch` hanya membuat branch baru namun tidak langsung pindah ke branch baru tersebut.

![HEAD menunjuk ke sebuah branch](https://git-scm.com/book/en/v2/images/head-to-master.png)

Kita dapat dengan mudah melihat ini dengan perintah `git log` yang menunjukkan arah pointer branch. Dengan opsi `--decorate`

``` shell
$ git log --oneline --decorate
f30ab (HEAD -> master, testing) add feature #32 - ability to add new formats to the central interface
34ac2 Fixed bug #1328 - stack overflow under certain conditions
98ca9 The initial commit of my project
```

Kita lihat disini branch "master" dan "testing" semua berada di commit `f30ab`.

Untuk berpindah branch kita lakukan dengan perintah `git checkout testing`, yang akan memindahkan `HEAD` ke branch `testing`.

![HEAD menunjuk ke branch saat ini](https://git-scm.com/book/en/v2/images/head-to-testing.png)

Mari kita buat sebuah commit baru:

``` shell
$ vim test.rb
$ git commit -a -m 'made a change'
```

![HEAD bergerak maju ketika commit dibuat](https://git-scm.com/book/en/v2/images/advance-testing.png)

Sekarang branch `testing` bergerak maju satu commit, namun branch `master` masih berada dicommit sebelumnya ketika kita melakukan `git checkout` untuk berpindah branch. Coba kembali ke branch `master`:

```shell
git checkout master
```

![HEAD pindah ketika kita checkout](https://git-scm.com/book/en/v2/images/checkout-master.png)

Perintah tadi melakukan dua hal. Memindahkan HEAD kembali ke point branch `master`, dan mengembalikan keadaan file kembali ke snapshot yang dipoint oleh branch `master` tersebut. Ini juga berarti perubahan yang kita buat disini akan bergerak maju dari versi project yang lebih awal. Simpelnya ini mundur dari dari semua yang kita kerjakan di branch `testing` jadi kita bisa memulai ke arah yang berbeda.

{: .box-note}
Perlu diingat kita tidak dapat melakukan perpindahan branch jika keadaan kita saat ini tidak "clean", dalam artian ada file atau directory yang dalam keadaan unstaged dan lainnya. File yang kita stage-pun jika kita berpindah branch akan tetap berada didalam staging di branch baru tersebut.

Sekarang coba kita buat commit lagi:

``` shell
$ vim test.rb
$ git commit -a -m 'made other changes'
```

Sekarang history project ini mulai bercabang(diverge). Kita membuat branch baru dan pindah kesitu, membuat commit disitu, lalu kembali ke commit utama dan membuat commit juga disitu. Semua perubahan terisolir dalam branch yang berbeda: kita dapat berpindah ke masing - masing branch dan merge keduanya jika sudah siap.

![History cabang](https://git-scm.com/book/en/v2/images/advance-master.png)

Kita juga dapat melihatnya dengan `git log`. Jika kita jalankan dengan perintah `git log --oneline --decorate --graph --all` semua history commit akan diperlihatkan, beserta semua pointer branch dan dimana bercabangnya history tersebut.

``` shell
$ git log --oneline --decorate --graph --all
* c2b9e (HEAD, master) made other changes
| * 87ab2 (testing) made a change
|/
* f30ab add feature #32 - ability to add new formats to the
* 34ac2 fixed bug #1328 - stack overflow under certain conditions
* 98ca9 initial commit of my project
```

Karena branch di git hanyalah file yang berisi 40 karakter checksum SHA-1 dari commit yang dipoint, branch mudah untuk dibuat dan dihapus. Membuat branch baru sama saja seperti membuat file baru dengan size 41 byte(40 karakter dan baris baru).
