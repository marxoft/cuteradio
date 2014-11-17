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

#ifndef CUTERADIO_H
#define CUTERADIO_H

#include <QVariantMap>

class CuteRadioReply;

class CuteRadio
{

public:
    static CuteRadioReply* get(const QString &url, bool auth = true);
    static CuteRadioReply* post(const QString &url, const QVariant &data, bool auth = true);
    static CuteRadioReply* put(const QString &url, const QVariant &data, bool auth = true);
    static CuteRadioReply* deleteResource(const QString &url, bool auth = true);
    
    static CuteRadioReply* getToken(const QString &username, const QString &password);
    static CuteRadioReply* deleteToken();
    
    static CuteRadioReply* getCountries(int page = 1, int limit = 25);
    static CuteRadioReply* getGenres(int page = 1, int limit = 25);
    static CuteRadioReply* getLanguages(int page = 1, int limit = 25);
    static CuteRadioReply* getSearches(int page = 1, int limit = 25);
    
    static CuteRadioReply* addSearch(const QString &query);
    static CuteRadioReply* deleteSearch(const QString &id);

    static CuteRadioReply* searchStations(const QString &query, int page = 1, int limit = 25);
    static CuteRadioReply* getStationsByCountry(const QString &country, int page = 1, int limit = 25);
    static CuteRadioReply* getStationsByGenre(const QString &genre, int page = 1, int limit = 25);
    static CuteRadioReply* getStationsByLanguage(const QString &language, int page = 1, int limit = 25);
    static CuteRadioReply* getMyStations(int page = 1, int limit = 25);
    static CuteRadioReply* getFavouriteStations(int page = 1, int limit = 25);
    static CuteRadioReply* getRecentlyPlayedStations(int page = 1, int limit = 25);
    static CuteRadioReply* getStations(const QString &url = QString());
    
    static CuteRadioReply* addStationToFavourites(const QString &id);
    static CuteRadioReply* deleteStationFromFavourites(const QString &id);
    static CuteRadioReply* addStation(const QVariantMap &properties);
    static CuteRadioReply* updateStation(const QString &id, const QVariantMap &properties);
    static CuteRadioReply* deleteStation(const QString &id);
    static CuteRadioReply* stationPlayed(const QString &id);
};

#endif
