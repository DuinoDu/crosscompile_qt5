#!/bin/bash

cd ..
tar -zxvf qt-everywhere-opensource-src-5.5.1.tar.gz
git clone https://github.com/DuinoDu/crosscompile_qt5
cd crosscompile_qt5

# edit linux-arm-hisiv400-gnueabi-g++/qmake.conf
# add cross compile
# add EGL opengl path and so on

cp linux-arm-hisiv400-g++ -r ../qt-everywhere-opensource-src-5.5.1/qtbase/mkspecs/
cp qopenglfunctions.cpp ../qt-everywhere-opensource-src-5.5.1/qtbase/src/gui/opengl/
cp simsun.ttf ../qt-everywhere-opensource-src-5.5.1/qtbase/lib/fonts/
cp qplatformfontdatabase.cpp ../qt-everywhere-opensource-src-5.5.1/qtbase/src/gui/text/

# To change user and user group.
chown iactive ../qt-everywhere-opensource-src-5.5.1/qtbase/mkspecs/linux-arm-hisiv400-g++
chown iactive ../qt-everywhere-opensource-src-5.5.1/qtbase/mkspecs/linux-arm-hisiv400-g++/qmake.conf
chown iactive ../qt-everywhere-opensource-src-5.5.1/qtbase/mkspecs/linux-arm-hisiv400-g++/qplatformdefs.h
chown iactive ../qt-everywhere-opensource-src-5.5.1/qtbase/src/gui/opengl/qopenglfunctions.cpp
chown iactive ../qt-everywhere-opensource-src-5.5.1/qtbase/lib/fonts/simsun.ttf
chown iactive ../qt-everywhere-opensource-src-5.5.1/qtbase/src/gui/text/qplatformfontdatabase.cpp

chgrp iactive ../qt-everywhere-opensource-src-5.5.1/qtbase/mkspecs/linux-arm-hisiv400-g++
chgrp iactive ../qt-everywhere-opensource-src-5.5.1/qtbase/mkspecs/linux-arm-hisiv400-g++/qmake.conf
chgrp iactive ../qt-everywhere-opensource-src-5.5.1/qtbase/mkspecs/linux-arm-hisiv400-g++/qplatformdefs.h
chgrp iactive ../qt-everywhere-opensource-src-5.5.1/qtbase/src/gui/opengl/qopenglfunctions.cpp
chgrp iactive ../qt-everywhere-opensource-src-5.5.1/qtbase/lib/fonts/simsun.ttf
chgrp iactive ../qt-everywhere-opensource-src-5.5.1/qtbase/src/gui/text/qplatformfontdatabase.cpp

cp build-5.5.1.sh  ../qt-everywhere-opensource-src-5.5.1/
cd ../qt-everywhere-opensource-src-5.5.1
chown iactive build-5.5.1.sh 
chgrp iactive build-5.5.1.sh
chmod +x build-5.5.1.sh
./build-5.5.1.sh

##############
# How to run #
##############
# Since qt has been installed on the target file when make install, so go to target directly.
# 
# 1. Login on the target.
#
# 2. Set nfs to download Qt file to native target.
# 
# 3. Set env
#
# mount -t nfs -o nolock 192.168.9.142:/home/duino/nfs /mnt/duino
# 
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/duino/lib:/mnt/duino/qt5/lib:/mnt/duino/build_expat/lib:/mnt/duino/build_dbus/lib
# 
# export QTDIR=/mnt/duino/qt5
# export QT_QPA_FONTDIR=/mnt/duino/qt5/lib/fonts
# export QT_QPA_PLATFORM_PLUGIN_PATH=/mnt/duino/qt5/plugins
# export QT_QPA_PLATFORM=eglfs
# export QT_QPA_EGLFS_FB=/dev/fb0
# export QT_QPA_EGLFS_WIDTH=1280
# export QT_QPA_EGLFS_HEIGHT=720
# export QT_QPA_EGLFS_DEPTH=32 
# export QT_QPA_EGLFS_DEBUG="yes" 
# export QT_QPA_EGLFS_INTEGRATION=eglfs_mali 
# 
# insmod /mnt/duino/others/gpu/release/ko/kds.ko
# insmod /mnt/duino/others/gpu/release/ko/ump.ko
# insmod /mnt/duino/others/gpu/release/ko/mali_kbase.ko
# (these are needed by libmali.so, libEGL.so, and so on.) 
#
# 4. Find an demo and run below:
# ./demo -plugin EvdevMouse:/dev/input/event0 EvdevKeyboard:/dev/input/event1
