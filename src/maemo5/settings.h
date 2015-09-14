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

#ifndef SETTINGS_H
#define SETTINGS_H

#include <QSettings>

class Settings : public QSettings
{
    Q_OBJECT
    
    Q_PROPERTY(int userId READ userId WRITE setUserId NOTIFY userIdChanged)
    Q_PROPERTY(QString token READ token WRITE setToken NOTIFY tokenChanged)
    Q_PROPERTY(bool sendPlayedStationsData READ sendPlayedStationsData WRITE setSendPlayedStationsData
               NOTIFY sendPlayedStationsDataChanged)
    Q_PROPERTY(int screenOrientation READ screenOrientation WRITE setScreenOrientation NOTIFY screenOrientationChanged)
    Q_PROPERTY(int sleepTimerDuration READ sleepTimerDuration WRITE setSleepTimerDuration
               NOTIFY sleepTimerDurationChanged)
    Q_PROPERTY(QString language READ language WRITE setLanguage NOTIFY languageChanged)

public:
    ~Settings();

    static Settings* instance();
    
    int userId() const;
    void setUserId(int id);
    
    QString token() const;
    void setToken(const QString &t);
    
    bool sendPlayedStationsData() const;
    void setSendPlayedStationsData(bool enabled);

    int screenOrientation() const;
    void setScreenOrientation(int orientation);

    int sleepTimerDuration() const;
    void setSleepTimerDuration(int duration);

    QString language() const;
    void setLanguage(const QString &l);

Q_SIGNALS:
    void userIdChanged();
    void tokenChanged();
    void sendPlayedStationsDataChanged();
    void screenOrientationChanged();
    void sleepTimerEnabledChanged();
    void sleepTimerDurationChanged();
    void languageChanged();
    
private:
    Settings();
    
    static Settings *self;
};

#endif
