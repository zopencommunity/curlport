#!/bin/sh
#
# Set up environment variables for general build tool to operate
#
if ! [ -f ./setenv.sh ]; then
	echo "Need to source from the setenv.sh directory" >&2
	return 0
fi

export PORT_ROOT="${PWD}"
export PORT_TYPE="TARBALL"
export PORT_TARBALL_URL="https://curl.se/download/curl-7.83.1.tar.gz"
export PORT_TARBALL_DEPS="curl gzip make m4 perl autoconf openssl"

export PORT_GIT_URL="https://github.com/curl/curl.git"
export PORT_GIT_DEPS="git make m4 perl autoconf automake help2man makeinfo xz openssl"

export PORT_EXTRA_CPPFLAGS="-qnose -I$PWD/curl-7.83.1/include,$PWD/curl-7.83.1/lib,$HOME/zot/prod/openssl/include,$HOME/zot/prod/zlib/include,/usr/include/le"
export PORT_EXTRA_LDFLAGS="-L$HOME/zot/prod/openssl/lib -L$HOME/zot/prod/zlib/lib -lcrypto -lssl -lz"

if [ "${PORT_TYPE}x" = "TARBALLx" ]; then
	export PORT_BOOTSTRAP=skip
fi

export PORT_CONFIGURE_OPTS="--prefix=$HOME/zot/prod/curl-7.83.1 --with-openssl=$HOME/zot/prod/openssl"
