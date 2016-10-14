#!/bin/bash -ex

if [[ ! -d hidapi ]] ;
then
	git clone https://github.com/signal11/hidapi.git
fi

cd hidapi
./bootstrap
cd -

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p hidapi-build
cd hidapi-build

if [[ x$USE_LOCAL_LIBUSB == xyes ]] ;
then
	../hidapi/configure --prefix=$PREFIX \
	libusb_CFLAGS="-I${PREFIX}/include/libusb-1.0" \
	libusb_LIBS="-L${PREFIX}/lib -lusb-1.0" \
	--host=$HOST \
	--target=$HOST
else
	../hidapi/configure --prefix=$PREFIX
fi

make
make install
