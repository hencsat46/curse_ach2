QT       += core gui sql

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++17

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    edit_archive.cpp \
    edit_docum_plan.cpp \
    edit_faculty.cpp \
    edit_pub.cpp \
    login.cpp \
    main.cpp \
    registration.cpp \
    widget.cpp

HEADERS += \
    edit_archive.h \
    edit_docum_plan.h \
    edit_faculty.h \
    edit_pub.h \
    widget.h

FORMS += \
    edit_archive.ui \
    edit_docum_plan.ui \
    edit_faculty.ui \
    edit_pub.ui \
    widget.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
