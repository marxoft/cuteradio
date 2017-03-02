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
    Q_PROPERTY(QString togglePlaybackShortcut READ togglePlaybackShortcut WRITE setTogglePlaybackShortcut
               NOTIFY togglePlaybackShortcutChanged)
    Q_PROPERTY(QString playbackNextShortcut READ playbackNextShortcut WRITE setPlaybackNextShortcut
               NOTIFY playbackNextShortcutChanged)
    Q_PROPERTY(QString playbackPreviousShortcut READ playbackPreviousShortcut WRITE setPlaybackPreviousShortcut
               NOTIFY playbackPreviousShortcutChanged)
    Q_PROPERTY(QString nowPlayingShortcut READ nowPlayingShortcut WRITE setNowPlayingShortcut
               NOTIFY nowPlayingShortcutChanged)
    Q_PROPERTY(QString sleepTimerShortcut READ sleepTimerShortcut WRITE setSleepTimerShortcut
               NOTIFY sleepTimerShortcutChanged)
    Q_PROPERTY(QString playUrlShortcut READ playUrlShortcut WRITE setPlayUrlShortcut NOTIFY playUrlShortcutChanged)
    Q_PROPERTY(QString searchShortcut READ searchShortcut WRITE setSearchShortcut NOTIFY searchShortcutChanged)
    Q_PROPERTY(QString settingsShortcut READ settingsShortcut WRITE setSettingsShortcut NOTIFY settingsShortcutChanged)
    Q_PROPERTY(QString addStationShortcut READ addStationShortcut WRITE setAddStationShortcut
               NOTIFY addStationShortcutChanged)
    Q_PROPERTY(QString stationDetailsShortcut READ stationDetailsShortcut WRITE setStationDetailsShortcut
               NOTIFY stationDetailsShortcutChanged)
    Q_PROPERTY(QString editStationShortcut READ editStationShortcut WRITE setEditStationShortcut
               NOTIFY editStationShortcutChanged)
    Q_PROPERTY(QString stationFavouriteShortcut READ stationFavouriteShortcut WRITE setStationFavouriteShortcut
               NOTIFY stationFavouriteShortcutChanged)
    Q_PROPERTY(QString reloadShortcut READ reloadShortcut WRITE setReloadShortcut NOTIFY reloadShortcutChanged)

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
    
    QString togglePlaybackShortcut() const;
    void setTogglePlaybackShortcut(const QString &keys);
    QString playbackNextShortcut() const;
    void setPlaybackNextShortcut(const QString &keys);
    QString playbackPreviousShortcut() const;
    void setPlaybackPreviousShortcut(const QString &keys);
    QString nowPlayingShortcut() const;
    void setNowPlayingShortcut(const QString &keys);
    QString sleepTimerShortcut() const;
    void setSleepTimerShortcut(const QString &keys);
    QString playUrlShortcut() const;
    void setPlayUrlShortcut(const QString &keys);
    QString searchShortcut() const;
    void setSearchShortcut(const QString &keys);
    QString settingsShortcut() const;
    void setSettingsShortcut(const QString &keys);
    QString addStationShortcut() const;
    void setAddStationShortcut(const QString &keys);
    QString stationDetailsShortcut() const;
    void setStationDetailsShortcut(const QString &keys);
    QString editStationShortcut() const;
    void setEditStationShortcut(const QString &keys);
    QString stationFavouriteShortcut() const;
    void setStationFavouriteShortcut(const QString &keys);
    QString reloadShortcut() const;
    void setReloadShortcut(const QString &keys);

Q_SIGNALS:
    void userIdChanged();
    void tokenChanged();
    void sendPlayedStationsDataChanged();
    void screenOrientationChanged();
    void sleepTimerEnabledChanged();
    void sleepTimerDurationChanged();
    void languageChanged();
    void togglePlaybackShortcutChanged();
    void playbackNextShortcutChanged();
    void playbackPreviousShortcutChanged();
    void nowPlayingShortcutChanged();
    void sleepTimerShortcutChanged();
    void playUrlShortcutChanged();
    void searchShortcutChanged();
    void settingsShortcutChanged();
    void addStationShortcutChanged();
    void stationDetailsShortcutChanged();
    void editStationShortcutChanged();
    void stationFavouriteShortcutChanged();
    void reloadShortcutChanged();
    
private:
    Settings();
    
    static Settings *self;
};

#endif
