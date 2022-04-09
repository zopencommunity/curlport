#!/bin/sh 
#set -x
#
# Pre-requisites: 
#  - ensure you have sourced setenv.sh, e.g. . ./setenv.sh
#  - ensure you have GNU make installed (4.1 or later)
#  - ensure you have access to xlclang/c99
#  - network connectivity to pull git source from org
#
if [ $# -ne 1 ]; then
	if [ "${CURL_VRM}" = "" ]; then
		echo "Either specify target build options on the command-line or with environment variables\n" >&2

		echo "Syntax: $0 [<vrm>]\n" >&2
		echo "  where:\n" >&2
		echo "  <vrm> is blead\n" >&2
		exit 16
	fi
else
	export CURL_VRM="$1"
fi

if [ "${CURL_ROOT}" = '' ]; then
	echo "Need to set CURL_ROOT - source setenv.sh" >&2
	exit 16
fi
if [ "${CURL_VRM}" = '' ]; then
	echo "Need to set CURL_VRM - source setenv.sh" >&2
	exit 16
fi

if [ -z "${CURL_OS390_TGT_LOG_DIR}" ]; then
  CURL_OS390_TGT_LOG_DIR=/tmp
fi

make --version >/dev/null 2>&1 
if [ $? -gt 0 ]; then
	echo "You need GNU Make on your PATH in order to build cURL" >&2
	exit 16
fi

CURLPORT_ROOT="${PWD}"

echo "Logs will be stored to ${CURL_OS390_TGT_LOG_DIR}"

if [ ! -z "${CURL_OS390_TGT_CONFIG_OPTS}" ]; then
  ConfigOpts="$CURL_OS390_TGT_CONFIG_OPTS"
else
	echo "You need to specify envar CURL_OS390_TGT_CONFIG_OPTS." >&2
	exit 16
fi

echo $ConfigOpts

if [ -d "${CURLPORT_ROOT}/curl.local" ]; then
	echo "Copy Local cURL"
	date
	rm -rf "${CURLPORT_ROOT}/${CURL_VRM}"
	cp -rpf "${CURLPORT_ROOT}/curl.local" "${CURLPORT_ROOT}/${CURL_VRM}"
elif ! [ -d "${CURLPORT_ROOT}/${CURL_VRM}" ]; then
	mkdir -p "${CURLPORT_ROOT}/"
	echo "Clone cURL"
	date
	(cd "${CURLPORT_ROOT}/" && ${GIT_ROOT}/git clone https://github.com/curl/curl.git --branch "master" --single-branch --depth 1)

	if [ $? -gt 0 ]; then
		echo "Unable to clone cURL directory tree" >&2
		exit 16
	fi
	# This is not meant to be something we can do any development on, so
	# delete the git information

	rm -rf "${CURLPORT_ROOT}/${CURL_VRM}/perl5/.git*"
	chtag -R -h -t -cISO8859-1 "${CURLPORT_ROOT}/${CURL_VRM}"

	if [ $? -gt 0 ]; then
		echo "Unable to tag cURL directory tree as ASCII" >&2
		exit 16
	fi
fi

if ! managepatches.sh ; then
	exit 4
fi

cd "${CURLPORT_ROOT}/${CURL_VRM}" || exit 8

#
# Run autoreconf (using Autotools)
#

if ! autoreconf -fi ; then
  echo "autoreconf failed" >&2
  exit 4
fi

#
# Setup the configuration 
#
echo "Configure cURL"
date
if ! ./configure ${ConfigOpts} > ${CURL_OS390_TGT_LOG_DIR}/config.${USER}.out 2>&1 ; then
	echo "Configure of cURL tree failed." >&2
	exit 4
fi

echo "Make cURL"
date

if ! make  >${CURL_OS390_TGT_LOG_DIR}/make.${USER}..out 2>&1 ; then
	echo "MAKE of cURL tree failed." >&2
	exit 4
fi

echo "Make Test cURL"
date

if ! make test >${CURL_OS390_TGT_LOG_DIR}/maketest.${USER}..out 2>&1 ; then
	echo "MAKE test of cURL tree failed." >&2
	FAILURES=`grep "Failed.*tests out of" ${CURL_OS390_TGT_LOG_DIR}/maketest.${USER}..out | cut -f2 -d' '`
	echo "cURL test failures: $FAILURES";
fi
date

exit 0
