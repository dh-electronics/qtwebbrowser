#!/bin/sh
QT_VERSION=1.0.0
export QT_VERSION
QT_VER=1.0
export QT_VER
QT_VERSION_TAG=100
export QT_VERSION_TAG
QT_INSTALL_DOCS=/opt/Qt5.9.1/Docs/Qt-5.9.1
export QT_INSTALL_DOCS
BUILDDIR=/work/QTWebBrowser/qtwebbrowser/doc
export BUILDDIR
exec /opt/Qt5.9.1/5.9.1/gcc_64/bin/qdoc "$@"
