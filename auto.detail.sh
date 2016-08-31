#!/bin/bash

##########
# Step 1 #
##########
cd ..
tar -zxvf qt-everywhere-opensource-src-5.5.1.tar.gz
cd crosscompile_qt5

##########
# Step 2 #
##########
# edit linux-arm-hisiv400-gnueabi-g++/qmake.conf
# add cross compile
# add EGL opengl path and so on


##########
# Step 3 #
##########
# add mkspecs file
cp linux-arm-hisiv400-g++ -r ../qt-everywhere-opensource-src-5.5.1/qtbase/mkspecs/


##########
# Step 4 #
##########
# edit qtbase/src/gui/opengl/qopenglfunctions.cpp
cp qopenglfunctions.cpp ../qt-everywhere-opensource-src-5.5.1/qtbase/src/gui/opengl/

# bool QOpenGLES3Helper::init()
# {
# #ifndef Q_OS_IOS
# # ifdef Q_OS_WIN
# #  ifndef QT_DEBUG
#     m_gl.setFileName(QStringLiteral("libGLESv2"));
# #  else
#     m_gl.setFileName(QStringLiteral("libGLESv2d"));
# #  endif
# # else
# #  ifdef Q_OS_ANDROID
#     m_gl.setFileName(QStringLiteral("GLESv2"));
# #  else
#     //m_gl.setFileNameAndVersion(QStringLiteral("GLESv2"), 2);
#     m_gl.setFileName(QStringLiteral("GLESv2"));
# #  endif
# # endif // Q_OS_WIN
#     return m_gl.load();
# #else
#     return true;
# #endif // Q_OS_IOS
# }


##########
# Step 5 #
##########
# add font file
cp simsun.ttf ../qt-everywhere-opensource-src-5.5.1/qtbase/lib/fonts/


##########
# Step 6 #
##########
# edit qtbase/src/gui/text/qplatformfontdatabase.cpp
cp qplatformfontdatabase.cpp ../qt-everywhere-opensource-src-5.5.1/qtbase/src/gui/text/

# void QPlatformFontDatabase::populateFontDatabase()
# {
#     QString fontpath = fontDir();
#     if(!QFile::exists(fontpath)) {
#         qWarning("QFontDatabase: Cannot find font directory '%s' - is Qt installed correctly?",
#                  qPrintable(QDir::toNativeSeparators(fontpath)));
#         return;
#     }
# 
#     QDir dir(fontpath);
#     //dir.setNameFilters(QStringList() << QLatin1String("*.qpf2"));
#     dir.setNameFilters(QStringList() << QLatin1String("simsum.ttf"));
#     dir.refresh();
#     for (int i = 0; i < int(dir.count()); ++i) {
#         const QByteArray fileName = QFile::encodeName(dir.absoluteFilePath(dir[i]));
#         QFile file(QString::fromLocal8Bit(fileName));
#         if (file.open(QFile::ReadOnly)) {
#             const QByteArray fileData = file.readAll();
#             QByteArray *fileDataPtr = new QByteArray(fileData);
#             registerQPF2Font(fileData, fileDataPtr);
#         }
#     }
# }


##########
# Step 7 #
##########
cp build-5.5.1.sh  ../qt-everywhere-opensource-src-5.5.1/
cd ../qt-everywhere-opensource-src-5.5.1
./configure
#make -j5
#make install



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
