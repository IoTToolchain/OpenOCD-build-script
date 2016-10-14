#!/bin/bash -ex

if [[ ! -d libusb-compat ]] ;
then
        git clone https://github.com/IoTToolchain/libusb-compat-0.1.git libusb-compat
fi

cd libusb-compat
git reset --hard 272388e744cae3ac720a0c2592d2b75e3a93e412
./bootstrap.sh
cd -

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p libusb-compat-build
cd libusb-compat-build

export LT_MAJOR=0
export LT_REVISION=0
export LT_AGE=0

../libusb-compat/configure \
	LIBUSB_1_0_CFLAGS=-I${PREFIX}/include/libusb-1.0 \
	LIBUSB_1_0_LIBS="-L${PREFIX}/lib -lusb-1.0" \
	--prefix=$PREFIX \
	--host=$HOST \
	--target=$HOST
#	--disable-shared \

make
make install
