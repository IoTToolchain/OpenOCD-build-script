#!/bin/bash -ex

export CFLAGS="-m64 -O2"
export CXXFLAGS="-m64 -O2"
export HIDAPI_LDFLAGS="-lhidapi"

./clean.sh
rm -rf objdir

./libusb.build.sh
./libusb-compat-0.1.build.sh
USE_LOCAL_LIBUSB=yes ./hidapi.build.sh
USE_LOCAL_LIBUSB=yes ./openocd.build.sh

if [[ -f objdir/bin/openocd.exe ]] ;
then
	strip --strip-all objdir/bin/openocd.exe
fi
