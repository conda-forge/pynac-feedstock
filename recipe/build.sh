#!/bin/bash

export CPPFLAGS="-I$PREFIX/include -DDISABLE_COMMENTATOR $CPPFLAGS"
export CFLAGS="-O2 -g -fPIC $CFLAGS"
export CXXFLAGS="-O2 -g -fPIC $CXXFLAGS"

export CXXFLAGS=$(echo $CXXFLAGS | sed "s/-fvisibility-inlines-hidden//g")

if [[ "$target_platform" == osx-* ]]; then
    export PYTHON_LDFLAGS="-undefined dynamic_lookup"
    # turn off annoying warnings
    export CFLAGS="-Wno-deprecated-register $CFLAGS -isysroot ${SDKROOT}"
    export CXXFLAGS="-Wno-deprecated-register $CXXFLAGS -isysroot ${SDKROOT}"
fi

# remove libtool files
find $PREFIX -name '*.la' -delete

chmod +x configure

./configure \
    --prefix="$PREFIX" \
    --with-giac=no \
    --libdir="$PREFIX/lib"

make -j${CPU_COUNT}
make install
