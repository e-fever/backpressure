QT       += testlib qml

TARGET = backpressure
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app

SOURCES +=     main.cpp    

DEFINES += SRCDIR=\\\"$$PWD/\\\"
DEFINES += QUICK_TEST_SOURCE_DIR=\\\"$$PWD/\\\"

ROOTDIR = $$PWD/../../

include(vendor/vendor.pri)
include($$ROOTDIR/backpressure.pri)

DISTFILES +=     qpm.json     qmltests/tst_QmlTests.qml \
    qmltests/tst_BackPressure.qml

HEADERS +=    
