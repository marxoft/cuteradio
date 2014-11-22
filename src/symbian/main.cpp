/*
 * Copyright (C) 2014 Stuart Howarth <showarth@marxoft.co.uk>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms and conditions of the GNU Lesser General Public License,
 * version 3, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
 * more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "cuteradiorequest.h"
#include "homescreenmodel.h"
#include "stationmodel.h"
#include "namecountmodel.h"
#include "selectionmodels.h"
#include "settings.h"
#include "utils.h"
#include "urls.h"
#include "definitions.h"
#include "streamextractor.h"
#include "updatemanager.h"
#include "mediakeycaptureitem.h"
#include <QApplication>
#include <QDeclarativeView>
#include <QDeclarativeEngine>
#include <QDeclarativeContext>
#include <qdeclarative.h>
#include <QSsl>
#include <QSslConfiguration>
//#include <QTranslator>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(new QApplication(argc, argv));
    QScopedPointer<QDeclarativeView> view(new QDeclarativeView);

    app.data()->setOrganizationName("cuteRadio");
    app.data()->setApplicationName("cuteRadio");
    
    qmlRegisterType<CuteRadioRequest>("org.marxoft.cuteradio", 1, 0, "CuteRadioRequest");
    qmlRegisterType<HomescreenModel>("org.marxoft.cuteradio", 1, 0, "HomescreenModel");
    qmlRegisterType<StationModel>("org.marxoft.cuteradio", 1, 0, "StationModel");
    qmlRegisterType<NameCountModel>("org.marxoft.cuteradio", 1, 0, "NameCountModel");
    qmlRegisterType<ScreenOrientationModel>("org.marxoft.cuteradio", 1, 0, "ScreenOrientationModel");
    //qmlRegisterType<LanguageModel>("org.marxoft.cuteradio", 1, 0, "LanguageModel");
    qmlRegisterType<StreamExtractor>("org.marxoft.cuteradio", 1, 0, "StreamExtractor");
    qmlRegisterType<MediakeyCaptureItem>("org.marxoft.cuteradio", 1, 0, "VolumeKeys");
    qmlRegisterType<UpdateManager>("org.marxoft.updates", 1, 0, "UpdateManager");
    
    QSslConfiguration config = QSslConfiguration::defaultConfiguration();
    config.setProtocol(QSsl::TlsV1);
    QSslConfiguration::setDefaultConfiguration(config);
    
    Settings settings;
    Utils utils;
    
    /*if (!settings.language().isEmpty()) {
        QTranslator translator;
        translator.load(QString("/opt/cuteradio/translations/%1").arg(settings.language()));
        app.data()->installTranslator(&translator);
    }*/
    
    QDeclarativeContext *context = view.data()->rootContext();
    context->setContextProperty("Settings", &settings);
    context->setContextProperty("Utils", &utils);
    context->setContextProperty("BASE_URL", BASE_URL);
    context->setContextProperty("GENRES_URL", GENRES_URL);
    context->setContextProperty("COUNTRIES_URL", COUNTRIES_URL);
    context->setContextProperty("LANGUAGES_URL", LANGUAGES_URL);
    context->setContextProperty("STATIONS_URL", BASE_URL);
    context->setContextProperty("STATIONS_BY_GENRE_URL", STATIONS_BY_GENRE_URL);
    context->setContextProperty("STATIONS_BY_COUNTRY_URL", STATIONS_BY_COUNTRY_URL);
    context->setContextProperty("STATIONS_BY_LANGUAGE_URL", STATIONS_BY_LANGUAGE_URL);
    context->setContextProperty("STATIONS_SEARCH_URL", STATIONS_SEARCH_URL);
    context->setContextProperty("MY_STATIONS_URL", MY_STATIONS_URL);
    context->setContextProperty("RECENTLY_PLAYED_STATIONS_URL", RECENTLY_PLAYED_STATIONS_URL);
    context->setContextProperty("FAVOURITES_URL", FAVOURITES_URL);
    context->setContextProperty("TOKEN_URL", TOKEN_URL);
    context->setContextProperty("VERSION_NUMBER", VERSION_NUMBER);
    
    view.data()->setSource(QUrl("qrc:/main.qml"));
    view.data()->showFullScreen();

    QObject::connect(view.data()->engine(), SIGNAL(quit()), app.data(), SLOT(quit()));

    return app.data()->exec();
}
