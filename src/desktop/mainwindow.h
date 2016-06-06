/*
 * Copyright (C) 2016 Stuart Howarth <showarth@marxoft.co.uk>
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

#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "streamextractor.h"
#include <cuteradio/resourcesrequest.h>
#include <QMainWindow>
#include <QMediaPlayer>
#include <QTime>
#include <QTimer>
#include <QVariantMap>

namespace CuteRadio {
    class CountriesModel;
    class GenresModel;
    class LanguagesModel;
    class StationsModel;
}

class StreamExtractor;
class QLabel;
class QLineEdit;
class QListView;
class QSplitter;
class QStringListModel;
class QTreeView;

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);

protected:
    virtual void closeEvent(QCloseEvent *event);

private Q_SLOTS:
    void navigate(const QModelIndex &index);

    void showGenres();
    void sortGenres(int section, Qt::SortOrder order);
    
    void showCountries();
    void sortCountries(int section, Qt::SortOrder order);
    
    void showLanguages();
    void sortLanguages(int section, Qt::SortOrder order);
    
    void searchStations();
    void searchStations(const QString &query);
    void showStationsByGenre(const QModelIndex &index);
    void showStationsByCountry(const QModelIndex &index);
    void showStationsByLanguage(const QModelIndex &index);
    void showStations(const QString &title, const QString &resource, const QVariantMap &filters = QVariantMap());
    void sortStations(int section, Qt::SortOrder order);
    
    void playUrl(const QUrl &url);
    void playStation(const QModelIndex &index);
    void playCurrentStation();
    
    void showStationProperties(const QModelIndex &index);
    void showCurrentStationProperties();
    
    void toggleStationFavourite(const QModelIndex &index);
    void toggleCurrentStationFavourite();
    
    void setStationMenuActions();
    void showStationMenu(const QPoint &pos);
    
    void showAccountDialog();
    void showSettingsDialog();
    void showAboutDialog();
    
    void startPlayback();
    void stopPlayback();
    
    void toggleSleepTimer(bool enabled);
    void updateSleepTimer();
    
    void onAuthenticationRequestFinished(CuteRadio::Request* request);
    void onFavouriteRequestFinished(CuteRadio::Request* request);
    
    void onGenresModelStatusChanged(CuteRadio::ResourcesRequest::Status status);
    void onCountriesModelStatusChanged(CuteRadio::ResourcesRequest::Status status);
    void onLanguagesModelStatusChanged(CuteRadio::ResourcesRequest::Status status);
    void onStationsModelStatusChanged(CuteRadio::ResourcesRequest::Status status);
    
    void onStreamExtractorStatusChanged(StreamExtractor::Status status);
    
    void onPlayerMetaDataChanged();
    void onPlayerStateChanged(QMediaPlayer::State state);
    void onPlayerError();
    
    void onCurrentStationRowChanged(const QModelIndex &index);

private:
    void updateLogin(const QString &accessToken);
        
    QStringListModel *m_navigationModel;
    CuteRadio::GenresModel *m_genresModel;
    CuteRadio::CountriesModel *m_countriesModel;
    CuteRadio::LanguagesModel *m_languagesModel;
    CuteRadio::StationsModel *m_stationsModel;
    
    StreamExtractor *m_extractor;
    QMediaPlayer *m_player;
    
    QMenu *m_fileMenu;
    QMenu *m_playbackMenu;
    QMenu *m_stationMenu;
    QMenu *m_editMenu;
    QMenu *m_helpMenu;
    
    QAction *m_accountAction;
    QAction *m_quitAction;
    QAction *m_startAction;
    QAction *m_stopAction;
    QAction *m_sleepTimerAction;
    QAction *m_playAction;
    QAction *m_propertiesAction;
    QAction *m_favouriteAction;
    QAction *m_settingsAction;
    QAction *m_aboutAction;
    
    QToolBar *m_toolBar;
    
    QLineEdit *m_searchEdit;
    
    QListView *m_navigationView;
    QTreeView *m_categoriesView;
    QTreeView *m_stationsView;
    
    QLabel *m_categoriesLabel;
    QLabel *m_stationsLabel;
    QLabel *m_nowPlayingLabel;
    
    QSplitter *m_horizontalSplitter;
    QSplitter *m_verticalSplitter;
    
    QMap<int, QVariant> m_currentStation;
    
    QTimer m_sleepTimer;
    QTime m_sleepTime;
};

#endif // MAINWINDOW_H
