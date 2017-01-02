#!/usr/bin/env bash

################################################################################
#  THIS FILE IS 100% GENERATED BY ZPROJECT; DO NOT EDIT EXCEPT EXPERIMENTALLY  #
#  READ THE ZPROJECT/README.MD FOR INFORMATION ABOUT MAKING PERMANENT CHANGES. #
################################################################################
# NOTE: The script below is customized, merge carefully when updating zproject

set -x
set -e

if [ "$BUILD_TYPE" == "default" ]; then
    mkdir tmp
    BUILD_PREFIX=$PWD/tmp

    CONFIG_OPTS=()
    CONFIG_OPTS+=("CFLAGS=-I${BUILD_PREFIX}/include")
    CONFIG_OPTS+=("CPPFLAGS=-I${BUILD_PREFIX}/include")
    CONFIG_OPTS+=("CXXFLAGS=-I${BUILD_PREFIX}/include")
    CONFIG_OPTS+=("LDFLAGS=-L${BUILD_PREFIX}/lib")
    CONFIG_OPTS+=("PKG_CONFIG_PATH=${BUILD_PREFIX}/lib/pkgconfig")
    CONFIG_OPTS+=("--prefix=${BUILD_PREFIX}")
    CONFIG_OPTS+=("--with-docs=no")
    CONFIG_OPTS+=("--quiet")

    # Clone and build dependencies
    git clone --quiet --depth 1 https://github.com/zeromq/libzmq libzmq
    cd libzmq
    git --no-pager log --oneline -n1
    if [ -e autogen.sh ]; then
        ./autogen.sh 2> /dev/null
    fi
    if [ -e buildconf ]; then
        ./buildconf 2> /dev/null
    fi
    ./configure "${CONFIG_OPTS[@]}"
    make -j4
    make install
    cd ..
    git clone --quiet --depth 1 https://github.com/zeromq/czmq czmq
    cd czmq
    git --no-pager log --oneline -n1
    if [ -e autogen.sh ]; then
        ./autogen.sh 2> /dev/null
    fi
    if [ -e buildconf ]; then
        ./buildconf 2> /dev/null
    fi
    ./configure "${CONFIG_OPTS[@]}"
    make -j4
    make install
    cd ..
    git clone --quiet --depth 1 https://github.com/zeromq/malamute malamute
    cd malamute
    git --no-pager log --oneline -n1
    if [ -e autogen.sh ]; then
        ./autogen.sh 2> /dev/null
    fi
    if [ -e buildconf ]; then
        ./buildconf 2> /dev/null
    fi
    ./configure "${CONFIG_OPTS[@]}"
    make -j4
    make install
    cd ..
    git clone --quiet --depth 1 https://github.com/42ity/fty-proto fty-proto
    cd fty-proto
    git --no-pager log --oneline -n1
    if [ -e autogen.sh ]; then
        ./autogen.sh 2> /dev/null
    fi
    if [ -e buildconf ]; then
        ./buildconf 2> /dev/null
    fi
    ./configure "${CONFIG_OPTS[@]}"
    make -j4
    make install
    cd ..
    git clone --quiet --depth 1 https://github.com/42ity/libcidr cidr
    cd cidr
    git --no-pager log --oneline -n1
    if [ -e autogen.sh ]; then
        ./autogen.sh 2> /dev/null
    fi
    if [ -e buildconf ]; then
        ./buildconf 2> /dev/null
    fi
    ./configure "${CONFIG_OPTS[@]}"
    make -j4
    make install
    cd ..
    git clone --quiet --depth 1 -b 42ity https://github.com/42ity/cxxtools cxxtools
    cd cxxtools
    git --no-pager log --oneline -n1
    if [ -e autogen.sh ]; then
        ./autogen.sh 2> /dev/null
    fi
    if [ -e buildconf ]; then
        ./buildconf 2> /dev/null
    fi
    ./configure "${CONFIG_OPTS[@]}"
    make -j4
    make install
    cd ..
    git clone --quiet --depth 1 https://github.com/networkupstools/nut libnutclient
    cd libnutclient
    git --no-pager log --oneline -n1
    if [ -e autogen.sh ]; then
        ./autogen.sh 2> /dev/null
    fi
    if [ -e buildconf ]; then
        ./buildconf 2> /dev/null
    fi
    ( # Special override for NUT
      CONFIG_OPTS+=("--with-doc=skip")
      ./configure "${CONFIG_OPTS[@]}"
    )
    make -j4
    make install
    cd ..

    # Build and check this project
    ./autogen.sh 2> /dev/null
    ./configure "${CONFIG_OPTS[@]}"
    make -j4
    make check
    make install

    # Build and check this project without DRAFT APIs
    make clean
    git reset --hard HEAD
    ./autogen.sh 2> /dev/null
    ./configure --enable-drafts=no "${CONFIG_OPTS[@]}"
    make -j4
    make check
    make install
else
    pushd "./builds/${BUILD_TYPE}" && REPO_DIR="$(dirs -l +1)" ./ci_build.sh
fi
