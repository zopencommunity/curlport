#!/bin/sh
#set -x
if ! [ -f ./setenv.sh ]; then
	echo "Need to source from the setenv.sh directory" >&2
else
	export _BPXK_AUTOCVT="ON"
	export _CEE_RUNOPTS="FILETAG(AUTOCVT,AUTOTAG),POSIX(ON),TERMTHDACT(MSG)"
	export _TAG_REDIR_ERR="txt"
	export _TAG_REDIR_IN="txt"
	export _TAG_REDIR_OUT="txt"

	if [ -z "$GIT_ROOT" ]; then
		export GIT_ROOT=/rsusr/ported/bin
	fi  

	export PATH=$PWD/bin:$PATH

	# See curlbuild.sh for valid values of CURL_xxx variables
  if [ -z "${CURL_VRM}" ]; then
	  export CURL_VRM="curl" 
  fi

  if [ -z "${CURL_OS390_TGT_LOG_DIR}" ]; then
	  export CURL_OS390_TGT_LOG_DIR=${PWD} 
  fi

	export CURL_ROOT="${PWD}"

	export PATH="${CURL_ROOT}/bin:$PATH"

	#
        # Add 'Perl', 'M4', autoconf, automake to PATH, LIBPATH, PERL5LIB
	#
        fsroot=$( basename $HOME )
	export PERL_ROOT="/${fsroot}/perlprod"
	export M4_ROOT="/${fsroot}/m4prod"
	export AUTOCONF_ROOT="/${fsroot}/autoconfprod"
	export AUTOMAKE_ROOT="/${fsroot}/automakeprod"
	export PERLLIB=$( cd ${PERL_ROOT}/lib/perl5/*/os390/CORE; echo $PWD )
	export LIBPATH="${PERLLIB}:${LIBPATH}"
	export PATH="${M4_ROOT}/bin:${PERL_ROOT}/bin:${AUTOCONF_ROOT}/bin:${AUTOMAKE_ROOT}/bin:$PATH"

	export CURL_PROD="/${fsroot}/curlprod"

	export CURL_ENV="${CURL_ROOT}/${CURL_VRM}"

	echo "Environment set up for ${CURL_ENV}"
fi
