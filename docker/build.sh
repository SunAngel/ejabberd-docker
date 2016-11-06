#!/bin/sh -e

#Debug!
set -x

# Fix little bug in alpine image
#ln -s /etc/profile.d/color_prompt /etc/profile.d/color_prompt.sh

###################################################
# We'll need binaries from different paths,       #
#  so we should be sure, all bin dir in the PATH  #
###################################################
PATH="${PATH}:/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

#######################################
# Get ejabberd version from first arg #
#######################################
SW_VERSION="16.09"
if [ "x$1" != "x" ]; then
    SW_VERSION=$1
fi

#################################
# Where all data will be stored #
#################################
DATA_DIR="/home/ejabberd"
if [ "x$2" != "x" ]; then
    DATA_DIR=$2
fi

WORK_DIR="/tmp/build"
mkdir -p $WORK_DIR
cd $WORK_DIR

################################
# UID and GID for ffsync user #
################################
[ -z "$uUID" ] && uUID=2016
[ -z "$uGID" ] && uGID=2016

# First, add ejabberd user
addgroup -g "$uGID" ejabberd
adduser -D -s /bin/sh -g "EjabberD XMPP Server" -G ejabberd -h "$DATA_DIR" -u "$uUID" ejabberd

################################
# Install some needed packages #
################################
apk update
#####################################
# Runtime dependencies for ejabberd #
#  Not all erlang libs are needed,  #
#  but nobody can say, which are    #
#  needed, so some libs could be    #
#  missed                           #
#####################################
apk add expat yaml openssl zlib imagemagick sqlite erlang erlang-crypto \
	erlang-syntax-tools erlang-eunit erlang-asn1 erlang-parsetools \
	bash \
	erlang-sasl erlang-ssl erlang-public-key erlang-mnesia erlang-inets


#	erlang-hipe
#################################################
# Add build-deps                                #
# I'm creatind variable with them to being able #
#  to delete them back after building           #
#################################################
BUILD_DEP="make gcc g++ autoconf automake musl-dev sqlite-dev git erlang-dev openssl-dev yaml-dev expat-dev"
apk add $BUILD_DEP

########################################
# Download and unpack ejabberd sources #
########################################
wget "https://github.com/processone/ejabberd/archive/${SW_VERSION}.tar.gz" -O- | tar xzf - -C "$WORK_DIR"

##############################
# Build and install syncserv #
##############################
cd "$WORK_DIR/ejabberd-${SW_VERSION}"
./autogen.sh && \
	./configure --prefix=/usr/local --localstatedir="${DATA_DIR}/var" --sysconfdir="${DATA_DIR}/etc" \
	--enable-user=ejabberd \
	--enable-odbc --enable-mysql --enable-pgsql --enable-sqlite \
   	--enable-zlib --enable-iconv --enable-tools \
	&& \
	make && make install

# Backup DATA_DIR somewhere
tar czf /usr/local/share/ejabberd.tgz -C "$DATA_DIR" ./


#########################################
# Delete all unneded files and packages #
#########################################
cd /
apk del --purge $BUILD_DEP
rm /var/cache/apk/*
rm -rf /root/.cache
rm -rf $WORK_DIR

echo "Done!"
