#!/bin/bash

export CPPFLAGS="-I$PREFIX/include -DDISABLE_COMMENTATOR $CPPFLAGS"
export LDFLAGS="-L$PREFIX/lib $LDFLAGS"
export LD_LIBRARY_PATH="$PREFIX/lib:$LD_LIBRARY_PATH"
export CFLAGS="-O2 -g -fPIC $CFLAGS"
export CXXFLAGS="-O2 -g -fPIC $CXXFLAGS"

export CXXFLAGS=$(echo $CXXFLAGS | sed "s/-fvisibility-inlines-hidden//g")

if [ "$(uname)" == "Darwin" ]; then
    export PYTHON_LDFLAGS="-undefined dynamic_lookup"
    # turn off annoying warnings
    export CFLAGS="-Wno-deprecated-register $CFLAGS"
    export CXXFLAGS="-Wno-deprecated-register $CXXFLAGS"
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
