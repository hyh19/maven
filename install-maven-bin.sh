#!/usr/bin/env bash

MAVEN_VERSION="apache-maven-3.5.2"

ARCHIVE_NAME="${MAVEN_VERSION}-bin.tar.gz"

ARCHIVE_URL="http://mirrors.hust.edu.cn/apache/maven/maven-3/3.5.2/binaries/${ARCHIVE_NAME}"

BASE_DIRECTORY="/usr/local/maven/"

INSTALL_DIRECTORY="${BASE_DIRECTORY}/${MAVEN_VERSION}"

CURRENT_VERSION="${BASE_DIRECTORY}/current"

PROFILE=/etc/profile.d/m2_home.sh

wget -O "/tmp/check_sys.sh" "https://github.com/mrhuangyuhui/shell/raw/snippets/check_sys.sh"

. /tmp/check_sys.sh

if check_sys "packageManager" "yum"; then
    sudo yum install tar -y
elif check_sys "packageManager" "apt"; then
    sudo apt-get update
    sudo apt-get install tar -y
else
    echo "ERROR: Not supported distro"
    exit 1
fi

mkdir -p $BASE_DIRECTORY

cd $BASE_DIRECTORY

if [ ! -e "./$ARCHIVE_NAME" ]; then
    wget $ARCHIVE_URL
fi

if [ -d "${INSTALL_DIRECTORY}" ]; then
    rm -rf $INSTALL_DIRECTORY
fi

tar xzvf $ARCHIVE_NAME

if [ -L "$CURRENT_VERSION" ]; then
    rm -f $CURRENT_VERSION
fi

ln -s $INSTALL_DIRECTORY $CURRENT_VERSION

echo "M2_HOME=${CURRENT_VERSION}" > $PROFILE
echo "export PATH=$PATH:\${M2_HOME}/bin" >> $PROFILE

echo "################################################################################"
echo "# 1. Open a new terminal or enter 'source /etc/profile.d/m2_home.sh'"
echo "# 2. Run the command 'mvn -v' to ensure that installation succeeded"
echo "################################################################################"
