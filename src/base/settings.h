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

#ifndef SETTINGS_H
#define SETTINGS_H

#include <QSettings>
#include <qplatformdefs.h>

class Settings : public QSettings
{
    Q_OBJECT

    Q_PROPERTY(QString token
               READ token
               WRITE setToken
               NOTIFY tokenChanged)
    Q_PROPERTY(bool sendPlayedStationsData
               READ sendPlayedStationsData
               WRITE setSendPlayedStationsData
               NOTIFY sendPlayedStationsDataChanged)
    Q_PROPERTY(int screenOrientation
               READ screenOrientation
               WRITE setScreenOrientation
               NOTIFY screenOrientationChanged)
    Q_PROPERTY(int sleepTimerDuration
               READ sleepTimerDuration
               WRITE setSleepTimerDuration
               NOTIFY sleepTimerDurationChanged)
    Q_PROPERTY(QString language
               READ language
               WRITE setLanguage
               NOTIFY languageChanged)
#if (defined MEEGO_EDITION_HARMATTAN) || (defined SYMBIAN_OS)
    Q_PROPERTY(QString activeColor
               READ activeColor
#ifndef SYMBIAN_OS
               WRITE setActiveColor
               NOTIFY activeColorChanged)
#else
               CONSTANT)
#endif
    Q_PROPERTY(QString activeColorString
               READ activeColorString
#ifndef SYMBIAN_OS
               WRITE setActiveColorString
               NOTIFY activeColorStringChanged)
#else
               CONSTANT)
#endif
#endif

public:
    explicit Settings(QObject *parent = 0);
    ~Settings();

    static Settings* instance();
    
    QString token() const;
    void setToken(const QString &token);
    
    bool sendPlayedStationsData() const;
    void setSendPlayedStationsData(bool send);

    int screenOrientation() const;
    void setScreenOrientation(int orientation);

    int sleepTimerDuration() const;
    void setSleepTimerDuration(int duration);

    QString language() const;
    void setLanguage(const QString &language);

#if (defined MEEGO_EDITION_HARMATTAN) || (defined SYMBIAN_OS)
    QString activeColor() const;
#ifndef SYMBIAN_OS
    void setActiveColor(const QString &color);
#endif

    QString activeColorString() const;
#ifndef SYMBIAN_OS
    void setActiveColorString(const QString &colorString);
#endif
#endif

signals:
    void tokenChanged();
    void sendPlayedStationsDataChanged();
    void screenOrientationChanged();
    void sleepTimerEnabledChanged();
    void sleepTimerDurationChanged();
    void languageChanged();

#ifdef MEEGO_EDITION_HARMATTAN
    void activeColorChanged();
    void activeColorStringChanged();
#endif
    
private:
    static Settings *self;
};

#endif
