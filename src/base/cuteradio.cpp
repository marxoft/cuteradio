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

#include "cuteradio.h"
#include "cuteradioreply.h"
#include "networkaccessmanager.h"
#include "urls.h"
#include "json.h"
#include <QSettings>
#include <QRegExp>
#ifdef CUTERADIO_DEBUG
#include <QDebug>
#endif

using namespace QtJson;

static QNetworkRequest buildRequest(QString url, bool auth = true) {
    
    QNetworkRequest request(QUrl::fromEncoded(url.replace(QRegExp("&(?![\\w_]+=)"), "%26").toUtf8()));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Accept", "application/json");
    
    if (auth) {
        request.setRawHeader("Authorization", "Basic " + QByteArray(QSettings().value("Authorization/token")
                                                                               .toByteArray() + ":").toBase64());
    }
    
    return request;
}

CuteRadioReply* CuteRadio::get(const QString &url, bool auth) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::get" << url << auth;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->get(buildRequest(url, auth)));
}

CuteRadioReply* CuteRadio::post(const QString &url, const QVariant &data, bool auth) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::post" << url << data << auth;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->post(buildRequest(url, auth), Json::serialize(data)));
}

CuteRadioReply* CuteRadio::put(const QString &url, const QVariant &data, bool auth) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::put" << url << data << auth;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->put(buildRequest(url, auth), Json::serialize(data)));
}

CuteRadioReply* CuteRadio::deleteResource(const QString &url, bool auth) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::deleteResource" << url << auth;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->deleteResource(buildRequest(url, auth)));
}

CuteRadioReply* CuteRadio::getToken(const QString &username, const QString &password) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::getToken" << username << password;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->post(buildRequest(TOKEN_URL, false),
                                                                     QString("{\"username\": %1, \"password\": %2}")
                                                                     .arg(username).arg(password).toUtf8()));
}

CuteRadioReply* CuteRadio::deleteToken() {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::deleteToken";
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->deleteResource(buildRequest(TOKEN_URL)));
}

CuteRadioReply* CuteRadio::getCountries(int page, int limit) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::getCountries" << page << limit;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->get(buildRequest(QString(COUNTRIES_URL
                                                                                 + "?page=%1&max_results=%2")
                                                                                 .arg(page).arg(limit))));
}

CuteRadioReply* CuteRadio::getGenres(int page, int limit) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::getGenres" << page << limit;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->get(buildRequest(QString(GENRES_URL
                                                                                 + "?page=%1&max_results=%2")
                                                                                 .arg(page).arg(limit))));
}

CuteRadioReply* CuteRadio::getLanguages(int page, int limit) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::getLanguages" << page << limit;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->get(buildRequest(QString(LANGUAGES_URL
                                                                                 + "?page=%1&max_results=%2")
                                                                                 .arg(page).arg(limit))));
}

CuteRadioReply* CuteRadio::getSearches(int page, int limit) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::getSearches" << page << limit;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->get(buildRequest(QString(SEARCHES_URL
                                                                                 + "?page=%1&max_results=%2")
                                                                                 .arg(page).arg(limit))));
}

CuteRadioReply* CuteRadio::addSearch(const QString &query) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::addSearch" << query;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->post(buildRequest(SEARCHES_URL),
                                                                     QString("{\"name\": %1}").arg(query).toUtf8()));
}

CuteRadioReply* CuteRadio::deleteSearch(const QString &id) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::deleteSearch" << id;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->deleteResource(buildRequest(SEARCHES_URL + "/" + id)));
}

CuteRadioReply* CuteRadio::searchStations(const QString &query, int page, int limit) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::searchStations" << query << page << limit;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->get(buildRequest(STATIONS_SEARCH_URL
                                                                                 .arg(query)
                                                                                 .arg(page).arg(limit))));
}

CuteRadioReply* CuteRadio::getStationsByCountry(const QString &country, int page, int limit) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::getStationsByCountry" << country << page << limit;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->get(buildRequest(STATIONS_BY_COUNTRY_URL
                                                                                 .arg(country)
                                                                                 .arg(page).arg(limit))));
}

CuteRadioReply* CuteRadio::getStationsByGenre(const QString &genre, int page, int limit) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::getStationsByGenre" << genre << page << limit;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->get(buildRequest(STATIONS_BY_GENRE_URL
                                                                                 .arg(genre)
                                                                                 .arg(page).arg(limit))));
}

CuteRadioReply* CuteRadio::getStationsByLanguage(const QString &language, int page, int limit) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::getStationsByLanguage" << language << page << limit;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->get(buildRequest(STATIONS_BY_LANGUAGE_URL
                                                                                 .arg(language)
                                                                                 .arg(page).arg(limit))));
}

CuteRadioReply* CuteRadio::getMyStations(int page, int limit) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::getMyStations" << page << limit;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->get(buildRequest(QString(MY_STATIONS_URL
                                                                                 + "?page=%1&max_results=%2")
                                                                                 .arg(page).arg(limit))));
}

CuteRadioReply* CuteRadio::getFavouriteStations(int page, int limit) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::getFavouriteStations" << page << limit;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->get(buildRequest(QString(FAVOURITES_URL
                                                                                 + "?page=%1&max_results=%2")
                                                                                 .arg(page).arg(limit))));
}

CuteRadioReply* CuteRadio::getRecentlyPlayedStations(int page, int limit) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::getRecentlyPlayedStations" << page << limit;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->get(buildRequest(QString(RECENTLY_PLAYED_STATIONS_URL
                                                                                 + "?page=%1&max_results=%2")
                                                                                 .arg(page).arg(limit))));
}

CuteRadioReply* CuteRadio::getStations(const QString &url) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::getStations" << url;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->get(buildRequest(url.isEmpty() ?
                                                                                 QString(STATIONS_URL
                                                                                 + "?page=%1&max_results=%2")
                                                                                 .arg(1).arg(25) : url)));
}

CuteRadioReply* CuteRadio::addStationToFavourites(const QString &id) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::addStationToFavourites" << id;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->post(buildRequest(FAVOURITES_URL), 
                                                                     QString("{\"station_id\": %1 }")
                                                                     .arg(id).toUtf8()));
}

CuteRadioReply* CuteRadio::deleteStationFromFavourites(const QString &id) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::deleteStationFromFavourites" << id;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->deleteResource(buildRequest(FAVOURITES_URL + "/" + id)));
}

CuteRadioReply* CuteRadio::addStation(const QVariantMap &properties) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::addStation" << properties;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->post(buildRequest(MY_STATIONS_URL), 
                                                                     QtJson::Json::serialize(properties)));
}

CuteRadioReply* CuteRadio::updateStation(const QString &id, const QVariantMap &properties) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::updateStation" << id << properties;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->put(buildRequest(MY_STATIONS_URL + "/" + id),
                                                                    Json::serialize(properties)));
}

CuteRadioReply* CuteRadio::deleteStation(const QString &id) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::deleteStation" << id;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->deleteResource(buildRequest(MY_STATIONS_URL + "/" + id)));
}

CuteRadioReply* CuteRadio::stationPlayed(const QString &id) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadio::stationPlayed" << id;
#endif
    return new CuteRadioReply(NetworkAccessManager::instance()->post(buildRequest(RECENTLY_PLAYED_STATIONS_URL), 
                                                                     QString("{\"station_id\": %1 }")
                                                                     .arg(id).toUtf8()));
}
