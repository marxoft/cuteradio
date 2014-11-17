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

#include "settings.h"

Settings* Settings::self = 0;

Settings::Settings(QObject *parent) :
    QSettings(parent)
{
    if (!self) {
        self = this;
    }
}

Settings::~Settings() {}

Settings* Settings::instance() {
    return !self ? new Settings : self;
}

QString Settings::token() const {
    return this->value("Authorization/token").toString();
}

void Settings::setToken(const QString &token) {
    if (token != this->token()) {
        this->setValue("Authorization/token", token);
        emit tokenChanged();
    }
}

bool Settings::sendPlayedStationsData() const {
    return this->value("Media/sendPlayedStationsData", false).toBool();
}

void Settings::setSendPlayedStationsData(bool send) {
    if (send != this->sendPlayedStationsData()) {
        this->setValue("Media/sendPlayedStationsData", send);
        emit sendPlayedStationsDataChanged();
    }
}

int Settings::screenOrientation() const {
#ifdef Q_WS_MAEMO_5
    return this->value("Other/screenOrientation", Qt::WA_Maemo5LandscapeOrientation).toInt();
#else
    return this->value("Other/screenOrientation", 0).toInt();
#endif
}

void Settings::setScreenOrientation(int orientation) {
    if (orientation != this->screenOrientation()) {
        this->setValue("Other/screenOrientation", orientation);
        emit screenOrientationChanged();
    }
}

int Settings::sleepTimerDuration() const {
    return this->value("Media/sleepTimerDuration", 30).toInt();
}

void Settings::setSleepTimerDuration(int duration) {
    if (duration != this->sleepTimerDuration()) {
        this->setValue("Media/sleepTimerDuration", duration);
        emit sleepTimerDurationChanged();
    }
}

QString Settings::language() const {
    return this->value("Other/language", "en").toString();
}

void Settings::setLanguage(const QString &language) {
    if (language != this->language()) {
        this->setValue("Other/language", language);
        emit languageChanged();
    }
}

#if (defined MEEGO_EDITION_HARMATTAN) || (defined SYMBIAN_OS)
QString Settings::activeColor() const {
    return this->value("Appearance/activeColor", "#0881cb").toString();
}

#ifndef SYMBIAN_OS
void Settings::setActiveColor(const QString &color) {
    if (color != this->activeColor()) {
        this->setValue("Appearance/activeColor", color);
        emit activeColorChanged();
    }
}
#endif

QString Settings::activeColorString() const {
    return this->value("Appearance/activeColorString", "color7").toString();
}

#ifndef SYMBIAN_OS
void Settings::setActiveColorString(const QString &colorString) {
    if (colorString != this->activeColorString()) {
        this->setValue("Appearance/activeColorString", colorString);
        emit activeColorStringChanged();
    }
}
#endif

#endif
