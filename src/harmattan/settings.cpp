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
    return value("Other/screenOrientation", 0).toInt();
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

QColor Settings::activeColor() const {
    return value("Other/activeColor", "#0881cb").value<QColor>();
}

void Settings::setActiveColor(const QColor &color) {
    if (color != activeColor()) {
        setValue("Other/activeColor", color);
        emit activeColorChanged();
    }
}

QString Settings::activeColorString() const {
    return value("Other/activeColorString", "color7").toString();
}

void Settings::setActiveColorString(const QString &s) {
    if (s != activeColorString()) {
        setValue("Other/activeColorString", s);
        emit activeColorStringChanged();
    }
}
