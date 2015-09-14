TEMPLATE = app
TARGET = cuteradio
QT += network xml

maemo5 {
    QT += declarative
    
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
}

INSTALLS += target
