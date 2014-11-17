TEMPLATE = app
TARGET = cuteradio
QT += network xml declarative

HEADERS += $$files(src/base/*.h)
SOURCES += $$files(src/base/*.cpp)
INCLUDEPATH += src/base

INSTALLS += target

#DEFINES += CUTERADIO_TEST
#DEFINES += CUTERADIO_DEBUG

maemo5 {
    system(lupdate src/base/*.* src/maemo5/*.* -ts translations/maemo5/base.ts)
    system(cp translations/maemo5/base.ts translations/maemo5/en.ts)
    system(lrelease translations/maemo5/en.ts)

    SOURCES += src/maemo5/main.cpp

    target.path = /opt/cuteradio/bin
    
    qml.files += $$files(src/maemo5/*.qml)
    qml.path = /opt/cuteradio/qml

    desktop.files = desktop/maemo5/cuteradio.desktop
    desktop.path = /usr/share/applications/hildon

    icon.files = desktop/maemo5/64x64/cuteradio.png
    icon.path = /usr/share/icons/hicolor/64x64/apps

    translations.files = $$files(translations/maemo5/*.qm)
    translations.path = /opt/cuteradio/translations

    INSTALLS += qml desktop icon translations
}

symbian {
    system(lupdate src/base/*.* src/symbian/*.* -ts translations/symbian/base.ts)
    system(cp translations/symbian/base.ts translations/symbian/en.ts)
    system(lrelease translations/symbian/en.ts)

    DEFINES += SYMBIAN_OS IN_APP_UPDATES
    TARGET = cuteradio_0xe71cbb8d
    CONFIG += qtcomponents
    MMP_RULES += "DEBUGGABLE_UDEBONLY"
    TARGET.UID3 = 0xE71CBB8D
    TARGET.CAPABILITY += NetworkServices ReadUserData
    INCLUDEPATH += MW_LAYER_SYSTEMINCLUDE src/symbian/volumekeys
    LIBS += -L\\epoc32\\release\\armv5\\lib -lremconcoreapi
    LIBS += -L\\epoc32\\release\\armv5\\lib -lremconinterfacebase
    TARGET.EPOCHEAPSIZE = 0x20000 0x8000000
    TARGET.EPOCSTACKSIZE = 0x14000
    HEADERS += src/symbian/volumekeys/mediakeycaptureitem.h
    SOURCES += \
        src/symbian/main.cpp \
        src/symbian/volumekeys/mediakeycaptureitem.cpp
    RESOURCES += src/symbian/resources.qrc
    OTHER_FILES += $$files(src/symbian/*.qml)

    DEPLOYMENT.display_name = cuteRadio
    VERSION = 0.3.0
    ICON = desktop/symbian/cuteradio.svg

    vendorinfo += "%{\"Stuart Howarth\"}" ":\"Stuart Howarth\""
    qtcomponentsdep = "; Default dependency to Qt Quick Components for Symbian library" \
        "(0x200346DE), 1, 1, 0, {\"Qt Quick components for Symbian\"}"

    my_deployment.pkg_prerules += vendorinfo qtcomponentsdep

    translations.files = $$files(translations/symbian/*.qm)
    translations.path = !:\\Private\\e71cbb8d\\translations

    DEPLOYMENT += my_deployment translations
}

simulator {
    DEFINES += SYMBIAN_OS IN_APP_UPDATES
    CONFIG += qtcomponents
    SOURCES += src/symbian/main.cpp
    RESOURCES += src/symbian/resources.qrc
    OTHER_FILES += $$files(src/symbian/*.qml)
}

contains(MEEGO_EDITION,harmattan) {
    system(lupdate src/base/*.* src/harmattan/*.* -ts translations/harmattan/base.ts)
    system(cp translations/harmattan/base.ts translations/harmattan/en.ts)
    system(lrelease translations/harmattan/en.ts)

    QT += opengl
    CONFIG += qdeclarative-boostable
    SOURCES += src/harmattan/main.cpp
    RESOURCES += src/harmattan/resources.qrc
    OTHER_FILES += $$files(src/harmattan/*.qml)

    target.path = /opt/cuteradio/bin

    desktop.files = desktop/harmattan/cuteradio.desktop
    desktop.path = /usr/share/applications

    icon.files = desktop/harmattan/80x80/cuteradio.png
    icon.path = /usr/share/icons/hicolor/80x80/apps

    splash.files = $$files(desktop/harmattan/splash/*.png)
    splash.path = /opt/cuteradio/splash

    translations.files = $$files(translations/harmattan/*.qm)
    translations.path = /opt/cuteradio/translations

    INSTALLS += desktop icon splash translations
}

contains(DEFINES,IN_APP_UPDATES) {
    INCLUDEPATH += src/updatemanager
    HEADERS += src/updatemanager/updatemanager.h
    SOURCES += src/updatemanager/updatemanager.cpp
}

contains(DEFINES,CUTERADIO_TEST) {
    SOURCES += src/tests/main.cpp
    
    target.path = /opt/cuteradio/bin
    
    qml.files += $$files(src/tests/*.qml)
    qml.path = /opt/cuteradio/qml
    
    INSTALLS += qml
}
