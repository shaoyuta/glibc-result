# For ubuntu 2004
# apt install gcc make texinfo xz-utils gawk bison python3 gcc-snapshot

sudo apt install texinfo
wget -O binutils-2.38.tar.gz https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.gz
tar xvf binutils-2.38.tar.gz
mkdir binutils-build
cd binutils-build
../binutils-2.38/configure --prefix=/opt/binutils-2.38
make -j
sudo make install

cd ..

wget -O glibc-2.35.tar.xz  https://ftp.gnu.org/gnu/libc/glibc-2.35.tar.xz
tar xvf glibc-2.35.tar.xz
mkdir glibc-build
cd glibc-build/
../glibc-2.35/configure --prefix=/usr/local/glibc --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/opt/binutils-2.38/bin
make -j
make bench