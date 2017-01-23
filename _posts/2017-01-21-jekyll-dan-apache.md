---
layout: post
title: Apache dan Jekyll
tags: [random, blog, apache2, jekyll]
---

Tutorial ini saya dapatkan dari blog [Christopher Rung](https://christopherrung.com/tutorial/2015/05/07/apache-and-jekyll/), dan sebenarnya semua sudah dikupas tuntas disitu. Saya hanya mencoba menambahkan beberapa hal yang tidak diulas dalam blog itu ketika saya mencoba sendiri melakukan tutorial ini.

Yang pertama, ketika proses instalasi yang diberikan diblog tersebut semuanya sudah saya lakukan, masih ada error ketika menjalankan perintah:

```
alexforsale@ubuntu-home:~$ sudo gem install jekyll
Fetching: liquid-3.0.6.gem (100%)
Successfully installed liquid-3.0.6
Fetching: kramdown-1.13.2.gem (100%)
Successfully installed kramdown-1.13.2
Fetching: mercenary-0.3.6.gem (100%)
Successfully installed mercenary-0.3.6
Fetching: safe_yaml-1.0.4.gem (100%)
Successfully installed safe_yaml-1.0.4
Fetching: colorator-1.1.0.gem (100%)
Successfully installed colorator-1.1.0
Fetching: rouge-1.11.1.gem (100%)
Successfully installed rouge-1.11.1
Fetching: sass-3.4.23.gem (100%)
Successfully installed sass-3.4.23
Fetching: jekyll-sass-converter-1.5.0.gem (100%)
Successfully installed jekyll-sass-converter-1.5.0
Fetching: rb-fsevent-0.9.8.gem (100%)
Successfully installed rb-fsevent-0.9.8
Fetching: ffi-1.9.17.gem (100%)
Building native extensions.  This could take a while...
ERROR:  Error installing jekyll:
	ERROR: Failed to build gem native extension.

    current directory: /var/lib/gems/2.3.0/gems/ffi-1.9.17/ext/ffi_c
/usr/bin/ruby2.3 -r ./siteconf20170121-32562-dp8ajr.rb extconf.rb
mkmf.rb can't find header files for ruby at /usr/lib/ruby/include/ruby.h

extconf failed, exit code 1

Gem files will remain installed in /var/lib/gems/2.3.0/gems/ffi-1.9.17 for inspection.
Results logged to /var/lib/gems/2.3.0/extensions/x86_64-linux/2.3.0/ffi-1.9.17/gem_make.out
```
Ternyata butuh package `ruby-dev` juga.

```
alexforsale@ubuntu-home:/var/www/html$ sudo apt-get install ruby-dev
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  ruby2.3-dev
The following NEW packages will be installed:
  ruby-dev ruby2.3-dev
0 upgraded, 2 newly installed, 0 to remove and 5 not upgraded.
Need to get 1.037 kB of archives.
After this operation, 4.813 kB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://id.archive.ubuntu.com/ubuntu yakkety/main amd64 ruby2.3-dev amd64 2.3.1-5build2 [1.032 kB]
Get:2 http://id.archive.ubuntu.com/ubuntu yakkety/main amd64 ruby-dev amd64 1:2.3.0+4 [4.366 B]
Fetched 1.037 kB in 6s (173 kB/s)                                                                                                                                                                                                                                 
Selecting previously unselected package ruby2.3-dev:amd64.
(Reading database ... 264649 files and directories currently installed.)
Preparing to unpack .../0-ruby2.3-dev_2.3.1-5build2_amd64.deb ...
Unpacking ruby2.3-dev:amd64 (2.3.1-5build2) ...
Selecting previously unselected package ruby-dev:amd64.
Preparing to unpack .../1-ruby-dev_1%3a2.3.0+4_amd64.deb ...
Unpacking ruby-dev:amd64 (1:2.3.0+4) ...
Setting up ruby2.3-dev:amd64 (2.3.1-5build2) ...
Setting up ruby-dev:amd64 (1:2.3.0+4) ...
```

Baru setelahnya instalasi `jekyll` berhasil. Dan sebelum jalankan `jekyll build` pastikan juga semua gem sudah terinstall. Semua yang dibutuhkan ada didalam file `Gemfile.lock` yang berada didalam folder blog. Kita bisa install semua langsung dengan perintah `bundle install`. Proses ini akan menginformasikan jika memang dibutuhkan akses root, jadi tidak perlu menggunakan `sudo`.

```
cd /path/to/jekyll/blog/
sudo jekyll build -d /var/www/
```

Dan akhirnya blog saya sudah terinstall di `/var/www/alexforsale`. Edit file `/etc/apache2/sites-enabled/000-default.conf` dan sesuaikan `DocumentRoot` dengan path yang dibuild oleh `jekyll`. Restart service apachenya dengan perintah `sudo service apache2 restart`. Dan blog saya sudah live, di `localhost` dalam kasus saya.

Lanjut lagi baca blog referensi [diatas](https://christopherrung.com/tutorial/2015/05/07/apache-and-jekyll/) jika ingin memodifikasi lebih lanjut, misalnya untuk autogeneration melalui `/etc/rc.local` atau menggunakan service Dropbox.

### arch linux

Mungkin ini bukan hal aneh, tapi untuk setting jekyll dan apache di arch memiliki banyak perbedaan dibandingkan di ubuntu, yang pertama, perhatikan warning di setiap instalasi diatas. Jika seperti ini:

```
WARNING:  You don't have /home/alexforsale/.gem/ruby/2.4.0/bin in your PATH,
```

Tambahkan path tersebut ke ~/.bashrc __UPDATE:__perintah yang lebih disarankan seperti ini:

```
# By default, Bundler installs gems system-wide, which is contrary to the behaviour of gem itself on Arch.
export GEM_HOME=$(ruby -e 'print Gem.user_dir')
```

Dan jika ada error sewaktu menjalankan `jekyll build` seperti ini:

```
Prepending `bundle exec` to your command may solve this. (Gem::LoadError)
```

Lakukan saja apa yang diminta, perintahnya menjadi `bundle exec jekyll build -d /srv/http`. Package apache di arch secara default directory-nya di `/srv/http`, jika ingin dirubah bisa dimodifikasi file `/etc/httpd/conf/httpd.conf`-nya, lengkapnya bisa baca di [wiki](https://wiki.archlinux.org/index.php/Apache_HTTP_Server)-nya.

#### Automatic Regeneration

Khusus untuk di arch, saya melakukan proses yang berbeda untuk regenerate blog saya, dan saya tulis di post [terpisah](https://alexforsale.github.io/2017-01-23-membuat-file-unit-systemd/).

