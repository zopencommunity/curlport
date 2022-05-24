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
export PORT_TARBALL_DEPS="curl gzip make m4 perl autoconf"

export PORT_GIT_URL="https://github.com/curl/curl.git"
export PORT_GIT_DEPS="git make m4 perl autoconf automake help2man makeinfo xz"

export PORT_EXTRA_CFLAGS=""
export PORT_EXTRA_LDFLAGS=""

if [ "${PORT_TYPE}x" = "TARBALLx" ]; then
	export PORT_BOOTSTRAP=skip
fi
