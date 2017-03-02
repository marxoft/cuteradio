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

#include "settings.h"

Settings* Settings::self = 0;

Settings::Settings() :
    QSettings()
{
}

Settings::~Settings() {
    self = 0;
}

Settings* Settings::instance() {
    return self ? self : self = new Settings;
}

int Settings::userId() const {
    return value("Authorization/userId").toInt();
}

void Settings::setUserId(int id) {
    if (id != userId()) {
        setValue("Authorization/userId", id);
        emit userIdChanged();
    }
}

QString Settings::token() const {
    return value("Authorization/token").toString();
}

void Settings::setToken(const QString &t) {
    if (t != token()) {
        setValue("Authorization/token", t);
        emit tokenChanged();
    }
}

bool Settings::sendPlayedStationsData() const {
    return value("Media/sendPlayedStationsData", false).toBool();
}

void Settings::setSendPlayedStationsData(bool enabled) {
    if (enabled != sendPlayedStationsData()) {
        setValue("Media/sendPlayedStationsData", enabled);
        emit sendPlayedStationsDataChanged();
    }
}

int Settings::screenOrientation() const {
    return value("Other/screenOrientation", Qt::WA_Maemo5LandscapeOrientation).toInt();
}

void Settings::setScreenOrientation(int orientation) {
    if (orientation != screenOrientation()) {
        setValue("Other/screenOrientation", orientation);
        emit screenOrientationChanged();
    }
}

int Settings::sleepTimerDuration() const {
    return value("Media/sleepTimerDuration", 30).toInt();
}

void Settings::setSleepTimerDuration(int duration) {
    if (duration != sleepTimerDuration()) {
        setValue("Media/sleepTimerDuration", duration);
        emit sleepTimerDurationChanged();
    }
}

QString Settings::language() const {
    return value("Other/language", "en").toString();
}

void Settings::setLanguage(const QString &l) {
    if (l != language()) {
        setValue("Other/language", l);
        emit languageChanged();
    }
}

QString Settings::togglePlaybackShortcut() const {
    return value("Shortcuts/togglePlayback", tr("Space")).toString();
}

void Settings::setTogglePlaybackShortcut(const QString &keys) {
    if (keys != togglePlaybackShortcut()) {
        setValue("Shortcuts/togglePlayback", keys);
        emit togglePlaybackShortcutChanged();
    }
}

QString Settings::playbackNextShortcut() const {
    return value("Shortcuts/playbackNext", tr("Right")).toString();
}

void Settings::setPlaybackNextShortcut(const QString &keys) {
    if (keys != playbackNextShortcut()) {
        setValue("Shortcuts/playbackNext", keys);
        emit playbackNextShortcutChanged();
    }
}

QString Settings::playbackPreviousShortcut() const {
    return value("Shortcuts/playbackPrevious", tr("Left")).toString();
}

void Settings::setPlaybackPreviousShortcut(const QString &keys) {
    if (keys != playbackPreviousShortcut()) {
        setValue("Shortcuts/playbackPrevious", keys);
        emit playbackPreviousShortcutChanged();
    }
}

QString Settings::nowPlayingShortcut() const {
    return value("Shortcuts/nowPlaying", tr("Ctrl+P")).toString();
}

void Settings::setNowPlayingShortcut(const QString &keys) {
    if (keys != nowPlayingShortcut()) {
        setValue("Shortcuts/nowPlaying", keys);
        emit nowPlayingShortcutChanged();
    }
}

QString Settings::sleepTimerShortcut() const {
    return value("Shortcuts/sleepTimer", tr("Ctrl+T")).toString();
}

void Settings::setSleepTimerShortcut(const QString &keys) {
    if (keys != sleepTimerShortcut()) {
        setValue("Shortcuts/sleepTimer", keys);
        emit sleepTimerShortcutChanged();
    }
}

QString Settings::playUrlShortcut() const {
    return value("Shortcuts/playUrl", tr("Ctrl+U")).toString();
}

void Settings::setPlayUrlShortcut(const QString &keys) {
    if (keys != playUrlShortcut()) {
        setValue("Shortcuts/playUrl", keys);
        emit playUrlShortcutChanged();
    }
}

QString Settings::searchShortcut() const {
    return value("Shortcuts/search", tr("Ctrl+F")).toString();
}

void Settings::setSearchShortcut(const QString &keys) {
    if (keys != searchShortcut()) {
        setValue("Shortcuts/search", keys);
        emit searchShortcutChanged();
    }
}

QString Settings::settingsShortcut() const {
    return value("Shortcuts/settings", tr("Ctrl+S")).toString();
}

void Settings::setSettingsShortcut(const QString &keys) {
    if (keys != settingsShortcut()) {
        setValue("Shortcuts/settings", keys);
        emit settingsShortcutChanged();
    }
}

QString Settings::addStationShortcut() const {
    return value("Shortcuts/addStation", tr("Ctrl+N")).toString();
}

void Settings::setAddStationShortcut(const QString &keys) {
    if (keys != addStationShortcut()) {
        setValue("Shortcuts/addStation", keys);
        emit addStationShortcutChanged();
    }
}

QString Settings::stationDetailsShortcut() const {
    return value("Shortcuts/stationDetails", tr("I")).toString();
}

void Settings::setStationDetailsShortcut(const QString &keys) {
    if (keys != stationDetailsShortcut()) {
        setValue("Shortcuts/stationDetails", keys);
        emit stationDetailsShortcut();
    }
}

QString Settings::editStationShortcut() const {
    return value("Shortcuts/editStation", tr("E")).toString();
}

void Settings::setEditStationShortcut(const QString &keys) {
    if (keys != editStationShortcut()) {
        setValue("Shortcuts/editStation", keys);
        emit editStationShortcutChanged();
    }
}

QString Settings::stationFavouriteShortcut() const {
    return value("Shortcuts/stationFavourite", tr("F")).toString();
}

void Settings::setStationFavouriteShortcut(const QString &keys) {
    if (keys != stationFavouriteShortcut()) {
        setValue("Shortcuts/stationFavourite", keys);
        emit stationFavouriteShortcutChanged();
    }
}

QString Settings::reloadShortcut() const {
    return value("Shortcuts/reload", tr("R")).toString();
}

void Settings::setReloadShortcut(const QString &keys) {
    if (keys != reloadShortcut()) {
        setValue("Shortcuts/reload", keys);
        emit reloadShortcutChanged();
    }
}
