#!/bin/bash -ex

if [ "$TARGET" == "i686" ] ;
then
	export CFLAGS="-m32 -O2 -mfpmath=sse -march=atom"
	export CXXFLAGS=$CFLAGS
elif [ "$TARGET" == "x86_64" ] ;
then
	export CFLAGS="-m64 -O2 -mfpmath=sse -march=atom"
	export CXXFLAGS=$CFLAGS
else
	exit 1
fi

export HOST=$TARGET-w64-mingw32
export CC=$HOST-gcc
export CXX=$HOST-g++

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
