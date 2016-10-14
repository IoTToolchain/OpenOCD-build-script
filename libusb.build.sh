#!/bin/bash -ex

if [[ ! -f libusb-1.0.20.tar.bz2 ]] ;
then
	wget http://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.20/libusb-1.0.20.tar.bz2
fi

tar xfv libusb-1.0.20.tar.bz2

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p libusb-build
cd libusb-build

../libusb-1.0.20/configure \
	--prefix=$PREFIX \
	--host=x86_64-w64-mingw32 \
	--target=x86_64-w64-mingw32

#	--disable-shared \

#if [ -z "$MAKE_JOBS" ]; then
#	MAKE_JOBS="2"
#fi

#nice -n 10 make -j $MAKE_JOBS

cat Makefile

make

make install
