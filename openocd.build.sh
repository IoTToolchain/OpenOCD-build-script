#!/bin/bash -ex

if [[ ! -d OpenOCD ]] ;
then
	git clone https://github.com/IoTToolchain/OpenOCD.git OpenOCD
fi

cd OpenOCD
git reset --hard 7b8b2f944322161334e21f30709504e4d42da18e
./bootstrap
cd -

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p openocd-build
cd openocd-build

if [[ x$USE_LOCAL_LIBUSB == xyes ]] ;
then
	PKG_CONFIG_LIBDIR="${PREFIX}/lib/pkgconfig":"${PREFIX}/lib64/pkgconfig" \
	../OpenOCD/configure \
		--prefix=$PREFIX \
		LIBUSB0_CFLAGS=-I${PREFIX}/include/ \
		LIBUSB1_CFLAGS=-I${PREFIX}/include/libusb-1.0 \
		HIDAPI_CFLAGS=-I${PREFIX}/include/hidapi \
		LIBUSB0_LIBS="-L${PREFIX}/lib -lusb" \
		LIBUSB1_LIBS="-L${PREFIX}/lib -lusb-1.0" \
		HIDAPI_LIBS="-L${PREFIX}/lib ${HIDAPI_LDFLAGS}" \
		--host=$HOST \
		--target=$HOST \
		--pdfdir=$PREFIX
else
	../OpenOCD/configure \
		--prefix=$PREFIX \
		HIDAPI_CFLAGS=-I${PREFIX}/include/hidapi \
		HIDAPI_LIBS="-L${PREFIX}/lib ${HIDAPI_LDFLAGS}" \
		LIBFTDI_CFLAGS=-I${PREFIX}/include/libftdi1 \
		--host=$HOST \
		--target=$HOST \
		--pdfdir=$PREFIX
fi

make
make install
