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

#include "activecolormodel.h"
#include "countriesmodel.h"
#include "definitions.h"
#include "genresmodel.h"
#include "homescreenmodel.h"
#include "languagesmodel.h"
#include "resourcesrequest.h"
#include "screenorientationmodel.h"
#include "searchesmodel.h"
#include "settings.h"
#include "stationsmodel.h"
#include "streamextractor.h"
#include "utils.h"
#include <QApplication>
#include <QDeclarativeView>
#include <QDeclarativeEngine>
#include <QDeclarativeContext>
#include <qdeclarative.h>
#include <QGLWidget>
#include <QTranslator>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(new QApplication(argc, argv));
    QScopedPointer<QDeclarativeView> view(new QDeclarativeView);

    app.data()->setOrganizationName("cuteRadio");
    app.data()->setApplicationName("cuteRadio");
    
    qmlRegisterType<ActiveColorModel>("CuteRadioApp", 1, 0, "ActiveColorModel");
    qmlRegisterType<HomescreenModel>("CuteRadioApp", 1, 0, "HomescreenModel");
    qmlRegisterType<ScreenOrientationModel>("CuteRadioApp", 1, 0, "ScreenOrientationModel");
    qmlRegisterType<StreamExtractor>("CuteRadioApp", 1, 0, "StreamExtractor");
    
    qmlRegisterType<CuteRadio::CountriesModel>("CuteRadio", 1, 0, "CountriesModel");
    qmlRegisterType<CuteRadio::GenresModel>("CuteRadio", 1, 0, "GenresModel");
    qmlRegisterType<CuteRadio::LanguagesModel>("CuteRadio", 1, 0, "LanguagesModel");
    qmlRegisterType<CuteRadio::ResourcesRequest>("CuteRadio", 1, 0, "ResourcesRequest");
    qmlRegisterType<CuteRadio::SearchesModel>("CuteRadio", 1, 0, "SearchesModel");
    qmlRegisterType<CuteRadio::StationsModel>("CuteRadio", 1, 0, "StationsModel");
    
    QScopedPointer<Settings> settings(Settings::instance());
    Utils utils;
    
    if (!Settings::instance()->language().isEmpty()) {
        QTranslator translator;
        translator.load(QString("/opt/cuteradio/translations/%1").arg(Settings::instance()->language()));
        app.data()->installTranslator(&translator);
    }
    
    QDeclarativeContext *context = view.data()->rootContext();
    context->setContextProperty("Settings", Settings::instance());
    context->setContextProperty("Utils", &utils);
    context->setContextProperty("VERSION_NUMBER", VERSION_NUMBER);
    
    view.data()->setViewport(new QGLWidget);
    view.data()->setSource(QUrl::fromLocalFile("/opt/cuteradio/qml/main.qml"));
    view.data()->showFullScreen();

    QObject::connect(view.data()->engine(), SIGNAL(quit()), app.data(), SLOT(quit()));

    return app.data()->exec();
}
