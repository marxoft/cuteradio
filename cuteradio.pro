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
}

INSTALLS += target
