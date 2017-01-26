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

Jika ada error `zlib is missing; necessary for building libxml2` ketika installing *gem* *nokogiri* (`bundle install`), install package `zlib1g-dev`.

#### Jalankan PHP dari user directory

Butuh package `php`, `php7.0-cli` dan `apache2` tentunya. Aktifkan module userdir dengan perintah `sudo a2enmod userdir`, dan lakukan konfigurasi pada module *userdir*-nya difile *userdir.conf*.

```
sudo nano /etc/apache2/mods-enabled/userdir.conf
```

Rubah isi defaultnya menjadi seperti ini:

```
<IfModule mod_userdir.c>
        UserDir public_html
        UserDir disabled root

        <Directory /home/*/public_html>
                AllowOverride All
                Options MultiViews Indexes SymLinksIfOwnerMatch
                <Limit GET POST OPTIONS>
                        # Apache <= 2.2:
                        #Order allow,deny
                        #Allow from all
 
                        # Apache >= 2.4:
                        Require all granted
                </Limit>
                <LimitExcept GET POST OPTIONS>
                        # Apache <= 2.2:
                        #Order deny,allow
                        #Deny from all
 
                        # Apache >= 2.4:
                        Require all denied
                </LimitExcept>
        </Directory>
</IfModule>

```

Directory *public_html* secara default di disabled untuk alasan keamanan, jadi untuk membuatnya menjadi *enable* ada konfigurasi *apache* yang perlu dirubah:

```
sudo nano /etc/apache2/mods-available/php7.0.conf
```

Sesuai keterangan dari comment-nya, beri tanda comment `#` mulai dari `<IfModule ...>` sampai ke `</IfModule>`

```
<FilesMatch ".+\.ph(p[3457]?|t|tml)$">
    SetHandler application/x-httpd-php
</FilesMatch>
<FilesMatch ".+\.phps$">
    SetHandler application/x-httpd-php-source
    # Deny access to raw php sources by default
    # To re-enable it's recommended to enable access to the files
    # only in specific virtual host or directory
    Require all denied
</FilesMatch>
# Deny access to files without filename (e.g. '.php')
<FilesMatch "^\.ph(p[3457]?|t|tml|ps)$">
    Require all denied
</FilesMatch>

# Running PHP scripts in user directories is disabled by default
#
# To re-enable PHP in user directories comment the following lines
# (from <IfModule ...> to </IfModule>.) Do NOT set it to On as it
# prevents .htaccess files from disabling it.
#<IfModule mod_userdir.c>
#    <Directory /home/*/public_html>
#        php_admin_flag engine Off
#    </Directory>
#</IfModule>

```

Jika kosong berarti file tersebut tidak ada, cek folder `/etc/apache2/mods-available`, jika folder tersebut pun tidak ada, kemungkinan perlu install `libapache2-mod-php`.

##### Dari https://wiki.ubuntu.com/UserDirectoryPHP

Menjalankan script *PHP* di directory home user sebenarnya sangat berbahaya -- *PHP* adalah bahasa programming full, dan karenanya, dapat digunakan sebagai tools untuk hacking dengan berbagai cara. Idealnya, *PHP* engine ini hanya diberikan untuk user yang dipercaya saja, jika ingin seperti ini, jangan lakukan step yang diatas. Sebaliknya, buat file baru (sebagai root) dengan nama`/etc/apache2/conf.d/php-in-homedirs.conf` dan isi seperti ini:

```
    <IfModule mod_userdir.c>
        <Directory /home/$USERNAME/public_html>
            php_admin_value engine On
        </Directory>
    </IfModule>
```

Ganti `$USERNAME` dengan nama user yang ingin diberikan permission untuk *php*, dan bagian `<Directory>` ini bisa dibuat berulang kali (misal untuk folder / user berbeda).

Restart *Apache* web servernya dengan perintah `sudo service apache2 restart`, dan buat folder `~/public_html`-nya (mkdir `~/public_html`)

```
cd /path/to/jekyll/blog/
sudo jekyll build -d /var/www/
```

Dan akhirnya blog saya sudah terinstall di `/var/www/alexforsale`. Edit file `/etc/apache2/sites-enabled/000-default.conf` dan sesuaikan `DocumentRoot` dengan path yang dibuild oleh `jekyll`. Restart service apachenya dengan perintah `sudo service apache2 restart`. Dan blog saya sudah live, di `localhost/~alexforsale` dalam kasus saya.

#### Buat file virtual host

Salin konfigurasi virtual host *Apache* menjadi file yang akan kita gunakan
```
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/alexforsale.github.io.conf
```

Dan

```
sudo nano /etc/apache2/sites-available/alexforsale.github.io.conf
```

Hapus tanda `#` didepan *ServerName*, ganti *www.example.com* dengan `localhost`, edit *DocumentRoot*-nya menjadi `/home/username/public_html`, sesuaikan *username*-nya. Lalu gunakan perintah `a2ensite` untuk enable file konfigurasi tersebut:

```
sudo a2ensite alexforsale.github.io.conf
```

Dan blog tersebut sudah dapat diakses melalui `http://localhost`. Lanjut lagi baca blog referensi [diatas](https://christopherrung.com/tutorial/2015/05/07/apache-and-jekyll/) jika ingin memodifikasi lebih lanjut, misalnya untuk autogeneration melalui `/etc/rc.local` atau menggunakan service Dropbox.

### arch linux

Beberapa perbedaan antara *arch* dengan *ubuntu*:

#### ruby

Sebelum menggunakan rubygem tambahkan line ini ke `$PATH` (gunakan `~/.bashrc`)

```
PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
```

Atau jika ingin lebih detail lagi:

```
#Setting the GEM_PATH and GEM_HOME variables may not be necessary, check 'gem env' output to verify whether both variables already exist 
GEM_HOME=$(ls -t -U | ruby -e 'puts Gem.user_dir')
GEM_PATH=$GEM_HOME
export PATH=$PATH:$GEM_HOME/bin
```

#### User directory apache

Di apache user directory defaultnya ada di `http://localhost/~yourusername/` dan mengacu ke `~/public_html` (bisa diganti di `/etc/httpd/conf/extra/httpd-userdir.conf`), setelah membuat folder `~/public_html` set permissionnya, serta permission folder `home`:

```
$ chmod o+x ~
$ chmod o+x ~/public_html
$ chmod -R o+r ~/public_html```
```

Ubah isi file `/etc/httpd/conf/extra/httpd-userdir.conf`

```
# Settings for user home directories
#
# Required module: mod_authz_core, mod_authz_host, mod_userdir

#
# UserDir: The name of the directory that is appended onto a user's home
# directory if a ~user request is received.  Note that you must also set
# the default access control for these directories, as in the example below.
#
UserDir public_html

#
# Control access to UserDir directories.  The following is an example
# for a site where these directories are restricted to read-only.
#
        <Directory /home/*/public_html>
		AllowOverride All
		Options MultiViews Indexes SymLinksIfOwnerMatch
		<Limit GET POST OPTIONS>
			# Apache <= 2.2:
		        Order allow,deny
		        Allow from all
 
		        # Apache >= 2.4:
		        #Require all granted
		</Limit>
		<LimitExcept GET POST OPTIONS>
			# Apache <= 2.2:
		        Order deny,allow
		        Deny from all
 
			# Apache >= 2.4:
			#Require all denied
		</LimitExcept>
        </Directory>
```

Dan juga untuk `/etc/httpd/conf/extra/httpd-vhosts.conf` tambahkan dipaling bawah:

```
<VirtualHost *:80>
  ServerName localhost
  DocumentRoot /home/username/public_html
</VirtualHost>

```

ganti *username* tentunya, dan terakhir, file `/etc/httpd/conf/httpd.conf`, hapus tanda `#` didepan baris:

```
Include conf/extra/httpd-vhosts.conf
```

Dan untuk perintah build-nya:

```
bundle exec jekyll build -d ~/public_html
```

Sekarang blog sudah dapat dilihat di `http://localhost`.

#### Automatic Regeneration

Khusus untuk di arch, saya melakukan proses yang berbeda untuk regenerate blog saya, dan saya tulis di post [terpisah](https://alexforsale.github.io/2017-01-23-membuat-file-unit-systemd/).

