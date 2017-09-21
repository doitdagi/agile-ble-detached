#!/bin/sh
#-------------------------------------------------------------------------------
# Copyright (C) 2017 Create-Net / FBK.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# Contributors:
#     Create-Net / FBK - initial API and implementation
#-------------------------------------------------------------------------------

set -e

WD=`pwd`
CURRDIR=${1:-$WD}
BUILD=$CURRDIR/build
ARM=$2
mkdir -p $BUILD

git_fetch() {

    cd $BUILD

    REPO=$1
    BNAME=`basename $REPO | sed 's/\.git//'`
    LIBNAME=${2:-BNAME}
    BRANCH=${3:-"master"}

    if [ ! -e "./$LIBNAME" ]
    then
        echo "Clone $REPO to $LIBNAME"
        git clone $REPO $LIBNAME
    fi

    echo "Fetching $LIBNAME"
    cd $LIBNAME
    git checkout $BRANCH
    git pull
    echo "OK"
}

LIB="jnr-unixsocket"
git_fetch "https://github.com/jnr/jnr-unixsocket.git" "$LIB" # "master"
mvn clean install -DskipTests=true

LIB="dbus-java-mvn"
git_fetch "https://github.com/muka/dbus-java-mvn.git" "$LIB" # "master"
mvn clean install -DskipTests=true

LIB="agile-api-spec"
git_fetch "https://github.com/Agile-IoT/agile-api-spec.git" "$LIB" # "master"
cd $BUILD/$LIB/agile-dbus-java-interface
mvn clean install -DskipTests=true

cd $CURRDIR
sh ./scripts/install-tinyb.sh $CURRDIR $ARM
