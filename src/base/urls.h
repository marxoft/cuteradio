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

#ifndef URLS_H
#define URLS_H

#include <QString>

static const QString BASE_URL("https://cuteradio.herokuapp.com");

static const QString GENRES_URL(BASE_URL + "/genres");
static const QString COUNTRIES_URL(BASE_URL + "/countries");
static const QString LANGUAGES_URL(BASE_URL + "/languages");
static const QString SEARCHES_URL(BASE_URL + "/previous_searches");

static const QString STATIONS_URL(BASE_URL + "/stations");
static const QString STATIONS_BY_GENRE_URL(BASE_URL + "/stations?where={\"genre\":\"%1\"}&page=%2&max_results=%3");
static const QString STATIONS_BY_COUNTRY_URL(BASE_URL + "/stations?where={\"country\":\"%1\"}&page=%2&max_results=%3");
static const QString STATIONS_BY_LANGUAGE_URL(BASE_URL + "/stations?where={\"language\":\"%1\"}&page=%2&max_results=%3");
static const QString STATIONS_SEARCH_URL(BASE_URL + "/stations?where={\"title\":{\"$regex\":\"%1\",\"$options\":\"i\"}}&page=%2&max_results=%3");

static const QString MY_STATIONS_URL(BASE_URL + "/my_stations");
static const QString RECENTLY_PLAYED_STATIONS_URL(BASE_URL + "/recently_played_stations");
static const QString FAVOURITES_URL(BASE_URL + "/favourites");

static const QString TOKEN_URL(BASE_URL + "/token");

#endif // URLS_H
