/*
 * Copyright (C) 2015 Stuart Howarth <showarth@marxoft.co.uk>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "definitions.h"
#include "homescreenmodel.h"
#include "screenorientationmodel.h"
#include "settings.h"
#include "streamextractor.h"
#include "utils.h"
#include <QApplication>
#include <QTranslator>
#include <QDeclarativeEngine>
#include <QDeclarativeContext>
#include <QDeclarativeComponent>
#include <qdeclarative.h>
#include <QDebug>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QDeclarativeEngine engine;
    
    app.setOrganizationName("cuteRadio");
    app.setApplicationName("cuteRadio");
    
    qmlRegisterType<HomescreenModel>("CuteRadioApp", 1, 0, "HomescreenModel");
    qmlRegisterType<ScreenOrientationModel>("CuteRadioApp", 1, 0, "ScreenOrientationModel");
    qmlRegisterType<StreamExtractor>("CuteRadioApp", 1, 0, "StreamExtractor");
    
    QScopedPointer<Settings> settings(Settings::instance());
    Utils utils;
    
    if (!Settings::instance()->language().isEmpty()) {
        QTranslator translator;
        translator.load(QString("/opt/cuteradio/translations/%1").arg(Settings::instance()->language()));
        app.installTranslator(&translator);
    }
    
    QDeclarativeContext *context = engine.rootContext();
    context->setContextProperty("Settings", Settings::instance());
    context->setContextProperty("Utils", &utils);
    context->setContextProperty("VERSION_NUMBER", VERSION_NUMBER);
    
    QDeclarativeComponent component(&engine, "/opt/cuteradio/qml/main.qml");
    component.create();
    
    if (component.isError()) {
        foreach (QDeclarativeError error, component.errors()) {
            qWarning() << error.toString();
        }
        
        return 0;
    }
    
    return app.exec();
}
