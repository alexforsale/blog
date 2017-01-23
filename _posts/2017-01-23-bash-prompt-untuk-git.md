---
layout: post
title: Bash prompt untuk git
tags: [blog, arch, linux, bash, git, bash-prompt]
---

Ada banyak cara mengkonfigurasi bash agar bisa lebih informatif ketika didalam folder git, tapi satu yang lebih sering saya pakai adalah bash-git-prompt dari [magicmonty](https://github.com/magicmonty/bash-git-prompt), saya temukan dari google beberapa bulan yang lalu, coba pakai diubuntu, dan akan saya pakai di arch juga.

Fungsi dari bash prompt ini adalah untuk menampilkan informasi tentang repository git saat ini, seperti branch apa yang digunakan, perbedaannya dengan branch remote, jumlah file dalam kondisi staging, dimodifikasi, dan lainnya. Tentunya hanya berlaku untuk folder yang menggunakan git. Penjelasan lebih lanjut mengenai git bisa dilihat di web [git-scm](https://git-scm.com/), untuk saya sendiri, blog ini dimaintain oleh git, jadi fitur ini akan sangat berguna.

### Instalasi

Cukup clone repository-nya dengan git, dan source file `gitprompt.sh` yang berada didalamnya ke dalam `~/.bashrc`

```
cd /data/source #karena saya menyimpan semua repository git disini
git clone git@github.com:magicmonty/bash-git-prompt.git
```

Edit file `~/.bashrc` dan tambahkan baris ini dibawahnya

```
# https://github.com/magicmonty/bash-git-prompt
# Set config variables first
GIT_PROMPT_ONLY_IN_REPO=1

# GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status

# GIT_PROMPT_SHOW_UPSTREAM=1 # uncomment to show upstream tracking branch
# GIT_PROMPT_SHOW_UNTRACKED_FILES=all # can be no, normal or all; determines counting of untracked files

# GIT_PROMPT_SHOW_CHANGED_FILES_COUNT=0 # uncomment to avoid printing the number of changed files

# GIT_PROMPT_STATUS_COMMAND=gitstatus_pre-1.7.10.sh # uncomment to support Git older than 1.7.10
# GIT_PROMPT_START=...    # uncomment for custom prompt start sequence
# GIT_PROMPT_END=...      # uncomment for custom prompt end sequence

# as last entry source the gitprompt script
# GIT_PROMPT_THEME=Custom # use custom theme specified in file GIT_PROMPT_THEME_FILE (default ~/.git-prompt-colors.sh)
# GIT_PROMPT_THEME_FILE=~/.git-prompt-colors.sh
# GIT_PROMPT_THEME=Solarized # use theme optimized for solarized color scheme
# source the location of the repo
source /data/source/bash-git-prompt/gitprompt.sh

```

Semua yang diawali tanda `#` adalah comment dan tidak dibaca oleh script, semua itu saya ambil dari file [readme-nya](https://github.com/magicmonty/bash-git-prompt), jika ada beberapa yang diperlukan cukup hapus tanda `#` yang berada dipaling awal setiap barisnya.

### Hasilnya

<img src=https://raw.githubusercontent.com/alexforsale/alexforsale.github.io/93c78938040472c8cef3608c596dab0f305ac56b />
