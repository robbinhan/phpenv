#!/usr/bin/env bash
version=$1;
if [ ! -n "$version" ]; then
  echo "unknown php version ";
  exit;
fi
definitions_dir="./definitions/"
prefix="php-"
ext=".tar.bz2"
config_file_name=$definitions_dir$version;
http_file_path=`cat $config_file_name`
save_file_name="/tmp/$version$ext";
save_file_path="/tmp/$prefix$version";
install_dir="$HOME/.phpenv/versions/$version";
if [ ! -d "$install_dir" ]; then
  echo "make install dir..."
  mkdir $install_dir;
fi

#这里的-f参数判断是否存在
#download
echo "$http_file_path  downloading……"
if [ ! -f "$save_file_name" ]; then
  `wget  "$http_file_path" -O $save_file_name`;
fi
#unpack
#判断解包目录是否存在
echo "$save_file_name tar……"
if [ ! -d "$save_file_path" ]; then
  `tar xvf $save_file_name -C /tmp`;
fi
#编译
echo "Configure……"
backup_pwd=$(pwd)
cd $save_file_path
if [ ! -f ./configure ]; then
    ./buildconf
fi
pwd
./configure --without-pear --with-gd --enable-sockets --with-jpeg-dir=/usr --with-png-dir=/usr --enable-exif --enable-zip --with-zlib --with-zlib-dir=/usr --with-kerberos --with-openssl --with-mcrypt=/usr --enable-soap --enable-xmlreader --with-xsl --enable-ftp --enable-cgi --with-curl=/usr --with-tidy --with-xmlrpc --enable-sysvsem --enable-sysvshm --enable-shmop --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-pdo-sqlite --enable-pcntl --with-libedit --enable-mbstring --disable-debug --enable-fpm --prefix=$install_dir
make && make install
cd $backup_pwd
