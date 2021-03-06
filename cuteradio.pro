TEMPLATE = app
TARGET = cuteradio
QT += network xml

INCLUDEPATH += src/base

HEADERS += src/base/*.h
SOURCES += src/base/*.cpp

maemo5 {
    QT += declarative
    
    INCLUDEPATH += src/maemo5
    
    HEADERS += src/maemo5/*.h
    SOURCES += src/maemo5/*.cpp

    target.path = /opt/cuteradio/bin
    
    qml.files = $$files(src/maemo5/qml/*.qml)
    qml.path = /opt/cuteradio/qml

    desktop.files = desktop/maemo5/cuteradio.desktop
    desktop.path = /usr/share/applications/hildon

    icon.files = desktop/maemo5/64x64/cuteradio.png
    icon.path = /usr/share/icons/hicolor/64x64/apps

    INSTALLS += qml desktop icon
    
} else:contains(MEEGO_EDITION,harmattan) {
    CONFIG += qdeclarative-boostable
    
    QT += declarative opengl
    
    INCLUDEPATH += ../libcuteradio/src src/harmattan
    
    HEADERS += ../libcuteradio/src/*.h src/harmattan/*.h 
    SOURCES += ../libcuteradio/src/*.cpp src/harmattan/*.cpp

    target.path = /opt/cuteradio/bin
    
    qml.files = $$files(src/harmattan/qml/*.qml)
    qml.path = /opt/cuteradio/qml
    
    images.files = $$files(src/harmattan/qml/images/*.png)
    images.path = /opt/cuteradio/qml/images

    desktop.files = desktop/harmattan/cuteradio.desktop
    desktop.path = /usr/share/applications

    icon.files = desktop/harmattan/80x80/cuteradio.png
    icon.path = /usr/share/icons/hicolor/80x80/apps
    
    splash.files = $$files(desktop/harmattan/splash/*.png)
    splash.path = /opt/cuteradio/splash

    INSTALLS += qml images desktop icon splash
    
} else:symbian {
    TARGET = cuteradio_0xe71cbb8d
    TARGET.UID3 = 0xE71CBB8D
    TARGET.CAPABILITY += NetworkServices ReadUserData
    TARGET.EPOCHEAPSIZE = 0x20000 0x8000000
    TARGET.EPOCSTACKSIZE = 0x14000
    
    VERSION = 0.4.2
    ICON = desktop/symbian/cuteradio.svg
    
    QT += declarative
    CONFIG += qtcomponents
    
    MMP_RULES += "DEBUGGABLE_UDEBONLY"
    
    LIBS += -L\\epoc32\\release\\armv5\\lib -lremconcoreapi
    LIBS += -L\\epoc32\\release\\armv5\\lib -lremconinterfacebase
    
    INCLUDEPATH += MW_LAYER_SYSTEMINCLUDE ../libcuteradio/src src/symbian
    
    HEADERS += ../libcuteradio/src/*.h src/symbian/*.h 
    SOURCES += ../libcuteradio/src/*.cpp src/symbian/*.cpp

    vendorinfo += "%{\"Stuart Howarth\"}" ":\"Stuart Howarth\""
    qtcomponentsdep = "; Default dependency to Qt Quick Components for Symbian library" \
        "(0x200346DE), 1, 1, 0, {\"Qt Quick components for Symbian\"}"

    cuteradio_deployment.pkg_prerules += vendorinfo qtcomponentsdep
    
    qml.sources = $$files(src/symbian/qml/*.qml)
    qml.path = !:/Private/e71cbb8d/qml

    images.sources = $$files(src/symbian/qml/images/*.*)
    images.path = !:/Private/e71cbb8d/qml/images

    DEPLOYMENT.display_name = cuteRadio

    DEPLOYMENT += cuteradio_deployment qml images

} else:unix {
    greaterThan(QT_MAJOR_VERSION, 4) {
        QT += widgets multimedia
    }
    else {
        CONFIG += mobility
    }

    LIBS += -L/usr/lib -lcuteradio
    CONFIG += link_prl
    PKGCONFIG += libcuteradio
    
    INCLUDEPATH += src/desktop

    HEADERS += src/desktop/*.h
    SOURCES += src/desktop/*.cpp

    desktop.files = desktop/desktop/cuteradio.desktop
    desktop.path = /usr/share/applications
    
    icon64.files = desktop/desktop/64x64/cuteradio.png
    icon64.path = /usr/share/icons/hicolor/64x64/apps
    
    icon48.files = desktop/desktop/48x48/cuteradio.png
    icon48.path = /usr/share/icons/hicolor/48x48/apps
    
    icon22.files = desktop/desktop/22x22/cuteradio.png
    icon22.path = /usr/share/icons/hicolor/22x22/apps
    
    icon16.files = desktop/desktop/16x16/cuteradio.png
    icon16.path = /usr/share/icons/hicolor/16x16/apps

    target.path = /usr/bin

    INSTALLS += \
        desktop \
        icon64 \
        icon48 \
        icon22 \
        icon16
}

INSTALLS += target
