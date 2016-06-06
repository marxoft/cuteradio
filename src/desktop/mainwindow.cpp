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

#include "mainwindow.h"
#include "aboutdialog.h"
#include "accountdialog.h"
#include "settingsdialog.h"
#include "utils.h"
#include <cuteradio/countriesmodel.h>
#include <cuteradio/genresmodel.h>
#include <cuteradio/languagesmodel.h>
#include <cuteradio/stationsmodel.h>
#include <QHeaderView>
#include <QLabel>
#include <QLineEdit>
#include <QListView>
#include <QMenu>
#include <QMenuBar>
#include <QMessageBox>
#include <QSettings>
#include <QStringListModel>
#include <QSplitter>
#include <QStatusBar>
#include <QToolBar>
#include <QTreeView>
#include <QVBoxLayout>

static QString NOW_PLAYING_TEXT = MainWindow::tr("Title: %1\nArtist: %2");

static QString STATION_PROPERTIES_TEXT = MainWindow::tr("Title: %1<br><br>Description: %2<br><br>Genre: %3<br><br>Country: %4<br><br>Language: %5<br><br>Source: <a href='%6'>%6</a>");

using namespace CuteRadio;

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    m_navigationModel(new QStringListModel(QStringList() << tr("Search stations") << tr("All stations")
                                                         << tr("Stations by genre") << tr("Stations by country")
                                                         << tr("Stations by language"), this)),
    m_genresModel(new GenresModel(this)),
    m_countriesModel(new CountriesModel(this)),
    m_languagesModel(new LanguagesModel(this)),
    m_stationsModel(new StationsModel(this)),
    m_extractor(new StreamExtractor(this)),
    m_player(new QMediaPlayer(this)),
    m_fileMenu(new QMenu(tr("&File"), this)),
    m_playbackMenu(new QMenu(tr("&Playback"), this)),
    m_stationMenu(new QMenu(tr("&Station"), this)),
    m_editMenu(new QMenu(tr("&Edit"), this)),
    m_helpMenu(new QMenu(tr("&Help"), this)),
    m_accountAction(new QAction(tr("Login/create &account"), this)),
    m_quitAction(new QAction(QIcon::fromTheme("application-exit"), tr("&Quit"), this)),
    m_startAction(new QAction(QIcon::fromTheme("media-playback-start"), tr("&Play"), this)),
    m_stopAction(new QAction(QIcon::fromTheme("media-playback-stop"), tr("&Stop"), this)),
    m_sleepTimerAction(new QAction(QIcon::fromTheme("appointment-soon"), tr("Enable sleep &timer"), this)),
    m_playAction(new QAction(QIcon::fromTheme("media-playback-start"), tr("&Play"), this)),
    m_propertiesAction(new QAction(QIcon::fromTheme("document-properties"), tr("P&roperties"), this)),
    m_favouriteAction(new QAction(QIcon::fromTheme("starred"), tr("&Favourite"), this)),
    m_settingsAction(new QAction(QIcon::fromTheme("preferences-desktop"), tr("&Preferences"), this)),
    m_aboutAction(new QAction(QIcon::fromTheme("help-about"), tr("&About"), this)),
    m_toolBar(new QToolBar(this)),
    m_searchEdit(new QLineEdit(this)),
    m_navigationView(new QListView(this)),
    m_categoriesView(new QTreeView(this)),
    m_stationsView(new QTreeView(this)),
    m_categoriesLabel(new QLabel(tr("Categories"), this)),
    m_stationsLabel(new QLabel(tr("Stations"), this)),
    m_nowPlayingLabel(new QLabel(this)),
    m_horizontalSplitter(new QSplitter(Qt::Horizontal, this)),
    m_verticalSplitter(new QSplitter(Qt::Vertical, this))
{
    setWindowTitle("cuteRadio");
    setCentralWidget(m_horizontalSplitter);
    setToolButtonStyle(Qt::ToolButtonIconOnly);
    addToolBar(Qt::TopToolBarArea, m_toolBar);
    statusBar();
    
    menuBar()->addMenu(m_fileMenu);
    menuBar()->addMenu(m_playbackMenu);
    menuBar()->addMenu(m_stationMenu);
    menuBar()->addMenu(m_editMenu);
    menuBar()->addMenu(m_helpMenu);
        
    m_quitAction->setShortcut(tr("Ctrl+Q"));
    m_startAction->setShortcut(tr("Ctrl+Return"));
    m_startAction->setEnabled(false);
    m_stopAction->setShortcut(tr("Ctrl+."));
    m_stopAction->setEnabled(false);
    m_sleepTimerAction->setShortcut(tr("Ctrl+T"));
    m_sleepTimerAction->setCheckable(true);
    m_sleepTimerAction->setEnabled(false);
    m_settingsAction->setShortcut(tr("Ctrl+P"));
    
    m_fileMenu->addAction(m_accountAction);
    m_fileMenu->addSeparator();
    m_fileMenu->addAction(m_quitAction);
    
    m_playbackMenu->addAction(m_startAction);
    m_playbackMenu->addAction(m_stopAction);
    m_playbackMenu->addAction(m_sleepTimerAction);
    
    m_stationMenu->addAction(m_playAction);
    m_stationMenu->addAction(m_propertiesAction);
    m_stationMenu->addAction(m_favouriteAction);
    m_stationMenu->setEnabled(false);
    
    m_editMenu->addAction(m_settingsAction);
    
    m_helpMenu->addAction(m_aboutAction);
            
    m_toolBar->setMovable(false);
    m_toolBar->setAllowedAreas(Qt::TopToolBarArea);
    m_toolBar->setWindowTitle(tr("Main toolbar"));
    m_toolBar->addAction(m_startAction);
    m_toolBar->addAction(m_stopAction);
    m_toolBar->addAction(m_sleepTimerAction);
    m_toolBar->addSeparator();
    m_toolBar->addWidget(m_nowPlayingLabel);
    m_toolBar->addSeparator();
    m_toolBar->addWidget(m_searchEdit);
    
    QFont font = m_nowPlayingLabel->font();
    font.setPointSize(9);
    m_nowPlayingLabel->setFont(font);
    m_nowPlayingLabel->setSizePolicy(QSizePolicy::MinimumExpanding, QSizePolicy::Preferred);
    
    m_searchEdit->setPlaceholderText(tr("Search stations"));

    m_navigationView->setModel(m_navigationModel);

    m_categoriesView->setModel(m_genresModel);
    m_categoriesView->setSelectionBehavior(QTreeView::SelectRows);
    m_categoriesView->setEditTriggers(QTreeView::NoEditTriggers);
    m_categoriesView->setItemsExpandable(false);
    m_categoriesView->setIndentation(0);
    m_categoriesView->setUniformRowHeights(true);
    m_categoriesView->setAllColumnsShowFocus(true);
    m_categoriesView->header()->setSortIndicatorShown(true);
    m_categoriesView->header()->setSortIndicator(0, Qt::AscendingOrder);
    
    m_stationsView->setModel(m_stationsModel);
    m_stationsView->setSelectionBehavior(QTreeView::SelectRows);
    m_stationsView->setContextMenuPolicy(Qt::CustomContextMenu);
    m_stationsView->setEditTriggers(QTreeView::NoEditTriggers);
    m_stationsView->setItemsExpandable(false);
    m_stationsView->setIndentation(0);
    m_stationsView->setUniformRowHeights(true);
    m_stationsView->setAllColumnsShowFocus(true);
    
    QWidget *categoriesContainer = new QWidget(this);
    QVBoxLayout *categoriesLayout = new QVBoxLayout(categoriesContainer);
    categoriesLayout->addWidget(m_categoriesLabel);
    categoriesLayout->addWidget(m_categoriesView);
    categoriesLayout->setStretch(1, 1);
    
    QMargins margins = categoriesLayout->contentsMargins();
    margins.setLeft(0);
    margins.setRight(0);
    margins.setBottom(0);
    
    categoriesLayout->setContentsMargins(margins);
    
    QWidget *stationsContainer = new QWidget(this);
    QVBoxLayout *stationsLayout = new QVBoxLayout(stationsContainer);
    stationsLayout->addWidget(m_stationsLabel);
    stationsLayout->addWidget(m_stationsView);
    stationsLayout->setStretch(1, 1);
    stationsLayout->setContentsMargins(margins);

    m_horizontalSplitter->addWidget(m_navigationView);
    m_horizontalSplitter->addWidget(m_verticalSplitter);
    m_horizontalSplitter->setStretchFactor(1, 1);

    m_verticalSplitter->addWidget(categoriesContainer);
    m_verticalSplitter->addWidget(stationsContainer);
    m_verticalSplitter->setStretchFactor(1, 1);
        
    QSettings settings;
    settings.beginGroup("MainWindow");
    
    if (!restoreGeometry(settings.value("windowGeometry").toByteArray())) {
        resize(1000, 600);
    }

    if (!m_categoriesView->header()->restoreState(settings.value("categoriesHeaderViewState").toByteArray())) {
        m_categoriesView->header()->resizeSection(0, 400);
    }
    
    if (!m_stationsView->header()->restoreState(settings.value("stationsHeaderViewState").toByteArray())) {
        m_stationsView->header()->resizeSection(0, 400);
    }
    
    m_horizontalSplitter->restoreState(settings.value("horizontalSplitterState").toByteArray());
    m_verticalSplitter->restoreState(settings.value("verticalSplitterState").toByteArray());
    settings.endGroup();
    
    m_sleepTimer.setInterval(60000);
    
    updateLogin(settings.value("Account/accessToken").toString());

    connect(m_genresModel, SIGNAL(statusChanged(CuteRadio::ResourcesRequest::Status)),
            this, SLOT(onGenresModelStatusChanged(CuteRadio::ResourcesRequest::Status)));
    connect(m_countriesModel, SIGNAL(statusChanged(CuteRadio::ResourcesRequest::Status)),
            this, SLOT(onCountriesModelStatusChanged(CuteRadio::ResourcesRequest::Status)));
    connect(m_languagesModel, SIGNAL(statusChanged(CuteRadio::ResourcesRequest::Status)),
            this, SLOT(onLanguagesModelStatusChanged(CuteRadio::ResourcesRequest::Status)));
    connect(m_stationsModel, SIGNAL(statusChanged(CuteRadio::ResourcesRequest::Status)),
            this, SLOT(onStationsModelStatusChanged(CuteRadio::ResourcesRequest::Status)));
    connect(m_extractor, SIGNAL(statusChanged(StreamExtractor::Status)),
            this, SLOT(onStreamExtractorStatusChanged(StreamExtractor::Status)));
    connect(m_player, SIGNAL(metaDataChanged()), this, SLOT(onPlayerMetaDataChanged()));
    connect(m_player, SIGNAL(stateChanged(QMediaPlayer::State)), this, SLOT(onPlayerStateChanged(QMediaPlayer::State)));
    connect(m_player, SIGNAL(error(QMediaPlayer::Error)), this, SLOT(onPlayerError()));
    connect(m_stationMenu, SIGNAL(aboutToShow()), this, SLOT(setStationMenuActions()));
    connect(m_accountAction, SIGNAL(triggered()), this, SLOT(showAccountDialog()));
    connect(m_quitAction, SIGNAL(triggered()), this, SLOT(close()));
    connect(m_startAction, SIGNAL(triggered()), this, SLOT(startPlayback()));
    connect(m_stopAction, SIGNAL(triggered()), this, SLOT(stopPlayback()));
    connect(m_sleepTimerAction, SIGNAL(triggered(bool)), this, SLOT(toggleSleepTimer(bool)));
    connect(m_playAction, SIGNAL(triggered()), this, SLOT(playCurrentStation()));
    connect(m_propertiesAction, SIGNAL(triggered()), this, SLOT(showCurrentStationProperties()));
    connect(m_favouriteAction, SIGNAL(triggered()), this, SLOT(toggleCurrentStationFavourite()));
    connect(m_settingsAction, SIGNAL(triggered()), this, SLOT(showSettingsDialog()));
    connect(m_aboutAction, SIGNAL(triggered()), this, SLOT(showAboutDialog()));
    connect(m_searchEdit, SIGNAL(returnPressed()), this, SLOT(searchStations()));
    connect(m_navigationView, SIGNAL(clicked(QModelIndex)), this, SLOT(navigate(QModelIndex)));
    connect(m_categoriesView, SIGNAL(clicked(QModelIndex)), this, SLOT(showStationsByGenre(QModelIndex)));
    connect(m_categoriesView->header(), SIGNAL(sortIndicatorChanged(int, Qt::SortOrder)),
            this, SLOT(sortGenres(int, Qt::SortOrder)));
    connect(m_stationsView, SIGNAL(clicked(QModelIndex)), this, SLOT(playStation(QModelIndex)));
    connect(m_stationsView, SIGNAL(customContextMenuRequested(QPoint)), this, SLOT(showStationMenu(QPoint)));
    connect(m_stationsView->header(), SIGNAL(sortIndicatorChanged(int, Qt::SortOrder)),
            this, SLOT(sortStations(int, Qt::SortOrder)));
    connect(m_stationsView->selectionModel(), SIGNAL(currentRowChanged(QModelIndex, QModelIndex)),
            this, SLOT(onCurrentStationRowChanged(QModelIndex)));
    connect(&m_sleepTimer, SIGNAL(timeout()), this, SLOT(updateSleepTimer()));    
}

void MainWindow::closeEvent(QCloseEvent *event) {
    QSettings settings;
    settings.beginGroup("MainWindow");
    settings.setValue("windowGeometry", saveGeometry());
    settings.setValue("categoriesHeaderViewState", m_categoriesView->header()->saveState());
    settings.setValue("stationsHeaderViewState", m_stationsView->header()->saveState());
    settings.setValue("horizontalSplitterState", m_horizontalSplitter->saveState());
    settings.setValue("verticalSplitterState", m_verticalSplitter->saveState());
    settings.endGroup();
    QMainWindow::closeEvent(event);
}

void MainWindow::navigate(const QModelIndex &index) {
    switch (index.row()) {
    case 0:
        if (m_searchEdit->text().isEmpty()) {
            m_searchEdit->setFocus(Qt::OtherFocusReason);
        }
        else {
            searchStations(m_searchEdit->text());
        }
        
        break;
    case 1:
        showStations(index.data().toString(), "stations");
        break;
    case 2:
        showGenres();
        break;
    case 3:
        showCountries();
        break;
    case 4:
        showLanguages();
        break;
    case 5:
        showStations(index.data().toString(), "playedstations");
        break;
    case 6:
        showStations(index.data().toString(), "favourites");
        break;
    case 7: {
        QVariantMap filters;
        filters["mine"] = true;
        showStations(index.data().toString(), "stations", filters);
        break;
    }
    default:
        break;
    }
}

void MainWindow::showGenres() {
    m_categoriesLabel->setText(tr("Genres"));
    
    if (m_categoriesView->model() != m_genresModel) {
        QMetaObject::invokeMethod(m_categoriesView->model(), "cancel");
        m_categoriesView->setModel(m_genresModel);
        disconnect(m_categoriesView, SIGNAL(clicked(QModelIndex)), this, 0);
        disconnect(m_categoriesView->header(), SIGNAL(sortIndicatorChanged(int, Qt::SortOrder)), this, 0);
        connect(m_categoriesView, SIGNAL(clicked(QModelIndex)), this, SLOT(showStationsByGenre(QModelIndex)));
        connect(m_categoriesView->header(), SIGNAL(sortIndicatorChanged(int, Qt::SortOrder)),
                this, SLOT(sortGenres(int, Qt::SortOrder)));
    }
    
    if ((m_categoriesView->header()->sortIndicatorSection() != 0)
        || (m_categoriesView->header()->sortIndicatorOrder() != Qt::AscendingOrder)) {
        m_categoriesView->header()->setSortIndicator(0, Qt::AscendingOrder);
    }
    else if (m_genresModel->rowCount() == 0) {
        m_genresModel->reload();
    }
}

void MainWindow::sortGenres(int section, Qt::SortOrder order) {
    QVariantMap filters = m_genresModel->filters();
    
    switch (section) {
    case 0:
        filters["sort"] = "name";
        break;
    case 1:
        filters["sort"] = "count";
        break;
    default:
        return;
    }
    
    filters["sortDescending"] = (order == Qt::DescendingOrder);
    m_genresModel->setFilters(filters);
    m_genresModel->reload();
}

void MainWindow::showCountries() {
    m_categoriesLabel->setText(tr("Countries"));
    
    if (m_categoriesView->model() != m_countriesModel) {
        QMetaObject::invokeMethod(m_categoriesView->model(), "cancel");
        m_categoriesView->setModel(m_countriesModel);
        disconnect(m_categoriesView, SIGNAL(clicked(QModelIndex)), this, 0);
        disconnect(m_categoriesView->header(), SIGNAL(sortIndicatorChanged(int, Qt::SortOrder)), this, 0);
        connect(m_categoriesView, SIGNAL(clicked(QModelIndex)), this, SLOT(showStationsByCountry(QModelIndex)));
        connect(m_categoriesView->header(), SIGNAL(sortIndicatorChanged(int, Qt::SortOrder)),
                this, SLOT(sortCountries(int, Qt::SortOrder)));
    }

    if ((m_categoriesView->header()->sortIndicatorSection() != 0)
        || (m_categoriesView->header()->sortIndicatorOrder() != Qt::AscendingOrder)) {
        m_categoriesView->header()->setSortIndicator(0, Qt::AscendingOrder);
    }
    else if (m_countriesModel->rowCount() == 0) {
        m_countriesModel->reload();
    }
}

void MainWindow::sortCountries(int section, Qt::SortOrder order) {
    QVariantMap filters = m_countriesModel->filters();
    
    switch (section) {
    case 0:
        filters["sort"] = "name";
        break;
    case 1:
        filters["sort"] = "count";
        break;
    default:
        return;
    }
    
    filters["sortDescending"] = (order == Qt::DescendingOrder);
    m_countriesModel->setFilters(filters);
    m_countriesModel->reload();
}

void MainWindow::showLanguages() {
    m_categoriesLabel->setText(tr("Languages"));
    
    if (m_categoriesView->model() != m_languagesModel) {
        QMetaObject::invokeMethod(m_categoriesView->model(), "cancel");
        m_categoriesView->setModel(m_languagesModel);
        disconnect(m_categoriesView, SIGNAL(clicked(QModelIndex)), this, 0);
        disconnect(m_categoriesView->header(), SIGNAL(sortIndicatorChanged(int, Qt::SortOrder)), this, 0);
        connect(m_categoriesView, SIGNAL(clicked(QModelIndex)), this, SLOT(showStationsByLanguage(QModelIndex)));
        connect(m_categoriesView->header(), SIGNAL(sortIndicatorChanged(int, Qt::SortOrder)),
                this, SLOT(sortLanguages(int, Qt::SortOrder)));
    }

    if ((m_categoriesView->header()->sortIndicatorSection() != 0)
        || (m_categoriesView->header()->sortIndicatorOrder() != Qt::AscendingOrder)) {
        m_categoriesView->header()->setSortIndicator(0, Qt::AscendingOrder);
    }
    else if (m_languagesModel->rowCount() == 0) {
        m_languagesModel->reload();
    }
}

void MainWindow::sortLanguages(int section, Qt::SortOrder order) {
    QVariantMap filters = m_languagesModel->filters();
    
    switch (section) {
    case 0:
        filters["sort"] = "name";
        break;
    case 1:
        filters["sort"] = "count";
        break;
    default:
        return;
    }
    
    filters["sortDescending"] = (order == Qt::DescendingOrder);
    m_languagesModel->setFilters(filters);
    m_languagesModel->reload();
}

void MainWindow::searchStations() {
    searchStations(m_searchEdit->text());
}

void MainWindow::searchStations(const QString &query) {
    QVariantMap filters;
    filters["search"] = query;
    showStations(tr("Search (%1)").arg(query), "stations", filters);
    m_navigationView->setCurrentIndex(m_navigationModel->index(0, 0));
}

void MainWindow::showStationsByGenre(const QModelIndex &index) {
    const QString genre = index.data(GenresModel::NameRole).toString();
    QVariantMap filters;
    filters["genre"] = genre;
    showStations(genre, "stations", filters);
}

void MainWindow::showStationsByCountry(const QModelIndex &index) {
    const QString country = index.data(CountriesModel::NameRole).toString();
    QVariantMap filters;
    filters["genre"] = country;
    showStations(country, "stations", filters);
}

void MainWindow::showStationsByLanguage(const QModelIndex &index) {
    const QString language = index.data(LanguagesModel::NameRole).toString();
    QVariantMap filters;
    filters["genre"] = language;
    showStations(language, "stations", filters);
}

void MainWindow::showStations(const QString &title, const QString &resource, const QVariantMap &filters) {
    m_stationsLabel->setText(title);
    m_stationsModel->setResource(resource);
    m_stationsModel->setFilters(filters);
    
    if (resource == "stations") {
        m_stationsView->header()->setSortIndicatorShown(true);
        
        if ((m_stationsView->header()->sortIndicatorSection() != 0)
            || (m_stationsView->header()->sortIndicatorOrder() != Qt::AscendingOrder)) {
            m_stationsView->header()->setSortIndicator(0, Qt::AscendingOrder);
        }
        else {
            m_stationsModel->reload();
        }
    }
    else {
        m_stationsView->header()->setSortIndicatorShown(false);
        m_stationsModel->reload();
    }
}

void MainWindow::sortStations(int section, Qt::SortOrder order) {
    QVariantMap filters = m_stationsModel->filters();
    
    switch (section) {
    case 0:
        filters["sort"] = "title";
        break;
    case 1:
        filters["sort"] = "genre";
        break;
    case 2:
        filters["sort"] = "country";
        break;
    case 3:
        filters["sort"] = "language";
        break;
    default:
        return;
    }
    
    filters["sortDescending"] = (order == Qt::DescendingOrder);
    m_stationsModel->setFilters(filters);
    m_stationsModel->reload();
}

void MainWindow::playUrl(const QUrl &url) {
    QNetworkRequest request(url);
    request.setRawHeader("Icy-MetaData", "1");
    m_player->setMedia(request);
    startPlayback();
}

void MainWindow::playStation(const QModelIndex &index) {
    m_currentStation = m_stationsModel->itemData(index);
    const QUrl url = m_currentStation.value(StationsModel::SourceRole).toString();
    
    if (Utils::isPlaylist(url)) {
        m_extractor->getStreamUrl(url);
    }
    else {
        playUrl(url);
    }
}

void MainWindow::playCurrentStation() {
    playStation(m_stationsView->currentIndex());
}

void MainWindow::showStationProperties(const QModelIndex &index) {
    const QString text = STATION_PROPERTIES_TEXT.arg(index.data(StationsModel::TitleRole).toString())
                                                .arg(index.data(StationsModel::DescriptionRole).toString())
                                                .arg(index.data(StationsModel::GenreRole).toString())
                                                .arg(index.data(StationsModel::CountryRole).toString())
                                                .arg(index.data(StationsModel::LanguageRole).toString())
                                                .arg(index.data(StationsModel::SourceRole).toString());
    
    QMessageBox box(this);
    box.setWindowTitle(tr("Station properties"));
    box.setText(text);
    box.exec();
}

void MainWindow::showCurrentStationProperties() {
    showStationProperties(m_stationsView->currentIndex());
}

void MainWindow::toggleStationFavourite(const QModelIndex &index) {    
    const QString stationId = index.data(StationsModel::IdRole).toString();
    ResourcesRequest *request = new ResourcesRequest(this);
    request->setAccessToken(QSettings().value("Account/accessToken").toString());
    request->setProperty("stationId", stationId);
    connect(request, SIGNAL(finished(CuteRadio::Request*)),
            this, SLOT(onFavouriteRequestFinished(CuteRadio::Request*)));
    
    if (index.data(StationsModel::FavouriteRole).toBool()) {
        request->del("/favourites/" + stationId);
        statusBar()->showMessage(tr("Deleting station from favourites"));
    }
    else {
        QVariantMap favourite;
        favourite["stationId"] = stationId;
        request->insert(favourite, "/favourites");
        statusBar()->showMessage(tr("Adding station to favourites"));
    }
}

void MainWindow::toggleCurrentStationFavourite() {
    toggleStationFavourite(m_stationsView->currentIndex());
}

void MainWindow::setStationMenuActions() {
    if (m_favouriteAction->isVisible()) {
        if (m_stationsView->currentIndex().data(StationsModel::FavouriteRole).toBool()) {
            m_favouriteAction->setIcon(QIcon::fromTheme("non-starred"));
            m_favouriteAction->setText(tr("Un&favourite"));
        }
        else {
            m_favouriteAction->setIcon(QIcon::fromTheme("starred"));
            m_favouriteAction->setText(tr("&Favourite"));
        }
    }
}

void MainWindow::showStationMenu(const QPoint &pos) {
    if (m_stationsView->currentIndex().isValid()) {        
        m_stationMenu->popup(m_stationsView->mapToGlobal(pos), m_playAction);
    }
}

void MainWindow::showAccountDialog() {
    AccountDialog dialog(this);
    
    if (dialog.exec() == QDialog::Accepted) {        
        QVariantMap login;
        login["username"] = dialog.username();
        login["password"] = dialog.password();
        ResourcesRequest *request = new ResourcesRequest(this);
        connect(request, SIGNAL(finished(CuteRadio::Request*)),
                this, SLOT(onAuthenticationRequestFinished(CuteRadio::Request*)));
        request->insert(login, "/token");
        statusBar()->showMessage(tr("Authenticating"));
    }
}

void MainWindow::showSettingsDialog() {
    SettingsDialog(this).exec();
}

void MainWindow::showAboutDialog() {
    AboutDialog(this).exec();
}

void MainWindow::startPlayback() {
    m_player->play();
    QSettings settings;
    
    if (settings.value("sendPlayedStationsData", false).toBool()) {
        const QString accessToken = settings.value("Account/accessToken").toString();
        
        if ((!accessToken.isEmpty()) && (m_currentStation.contains(StationsModel::IdRole))) {
            QVariantMap station;
            station["stationId"] = m_currentStation.value(StationsModel::IdRole);
            ResourcesRequest *request = new ResourcesRequest(this);
            request->setAccessToken(accessToken);
            request->insert(station, "/playedstations");
            connect(request, SIGNAL(finished(CuteRadio::Request*)), request, SLOT(deleteLater()));
        }
    }
}

void MainWindow::stopPlayback() {
    m_player->stop();
    toggleSleepTimer(false);
}

void MainWindow::toggleSleepTimer(bool enabled) {
    if (enabled) {
        const QString remaining = QSettings().value("sleepTimerDuration", 30).toString();
        m_sleepTimer.start();
        m_sleepTime.start();
        m_sleepTimerAction->setChecked(true);
        m_sleepTimerAction->setText(tr("Enable sleep &timer (%1 mins)").arg(remaining));
        m_sleepTimerAction->setToolTip(tr("%1 minute(s) remaining").arg(remaining));
    }
    else {
        m_sleepTimer.stop();
        m_sleepTimerAction->setChecked(false);
        m_sleepTimerAction->setText(tr("Enable sleep &timer"));
        m_sleepTimerAction->setToolTip(tr("Enable sleep timer"));
    }
}

void MainWindow::updateSleepTimer() {
    const int remaining = QSettings().value("sleepTimerDuration", 30).toInt() * 60000 - m_sleepTime.elapsed();
    
    if (remaining > 0) {
        const int mins = remaining / 60000;
        m_sleepTimerAction->setText(tr("Enable sleep &timer (%1 mins)").arg(mins));
        m_sleepTimerAction->setToolTip(tr("%1 minute(s) remaining").arg(mins));
    }
    else {
        stopPlayback();
    }
}

void MainWindow::onAuthenticationRequestFinished(Request *request) {
    switch (request->status()) {
    case Request::Ready: {
        const QVariantMap result = request->result().toMap();
        QSettings settings;
        
        if ((result.contains("token")) && (result.contains("id"))) {
            settings.beginGroup("Account");
            settings.setValue("accessToken", result.value("token"));
            settings.setValue("userId", result.value("id"));
            settings.endGroup();
        }
        else {
            settings.remove("Account");
        }
        
        updateLogin(result.value("token").toString());
        statusBar()->showMessage(tr("Authentication successful"));
        break;
    }
    case Request::Failed:
        QMessageBox::critical(this, tr("Authentication error"), request->errorString());
        break;
    default:
        break;
    }
    
    request->deleteLater();
}

void MainWindow::onFavouriteRequestFinished(Request *request) {
    switch (request->status()) {
    case Request::Ready: {
        const int row = m_stationsModel->find("id", request->property("stationId"));
        
        if (request->operation() == Request::DeleteOperation) {
            if (row != -1) {
                if (m_stationsModel->resource() == "favourites") {
                    m_stationsModel->remove(row);
                }
                else {
                    m_stationsModel->setProperty(row, "favourite", false);
                }
            }
            
            statusBar()->showMessage(tr("Station deleted from favourites"));
        }
        else {
            if (row != -1) {
                m_stationsModel->setProperty(row, "favourite", true);
            }
            
            statusBar()->showMessage(tr("Station added to favourites"));
        }
        
        break;
    }
    case Request::Failed:
        QMessageBox::critical(this, tr("Request error"), request->errorString());
        break;
    default:
        break;
    }
    
    request->deleteLater();
}

void MainWindow::onGenresModelStatusChanged(ResourcesRequest::Status status) {
    bool clickable = false;
    
    switch (status) {
    case ResourcesRequest::Loading:
        statusBar()->showMessage(tr("Loading genres"));
        break;
    case ResourcesRequest::Ready:
        if (m_genresModel->rowCount() > 0) {
            clickable = true;
            statusBar()->showMessage(tr("Finished"));
        }
        else {
            statusBar()->showMessage(tr("No genres found"));
        }
        
        break;
    case ResourcesRequest::Canceled:
        statusBar()->showMessage(tr("Canceled"));
        break;
    case ResourcesRequest::Failed:
        QMessageBox::critical(this, tr("Genres error"), m_genresModel->errorString());
        break;
    default:
        break;
    }
#if QT_VERSION >= 0x050000
    m_categoriesView->header()->setSectionsClickable(clickable);
#else
    m_categoriesView->header()->setClickable(clickable);
#endif
}

void MainWindow::onCountriesModelStatusChanged(ResourcesRequest::Status status) {
    bool clickable = false;
    
    switch (status) {
    case ResourcesRequest::Loading:
        statusBar()->showMessage(tr("Loading countries"));
        break;
    case ResourcesRequest::Ready:
        if (m_countriesModel->rowCount() > 0) {
            clickable = true;
            statusBar()->showMessage(tr("Finished"));
        }
        else {
            statusBar()->showMessage(tr("No countries found"));
        }
        
        break;
    case ResourcesRequest::Canceled:
        statusBar()->showMessage(tr("Canceled"));
        break;
    case ResourcesRequest::Failed:
        QMessageBox::critical(this, tr("Countries error"), m_countriesModel->errorString());
        break;
    default:
        break;
    }
#if QT_VERSION >= 0x050000
    m_categoriesView->header()->setSectionsClickable(clickable);
#else
    m_categoriesView->header()->setClickable(clickable);
#endif
}

void MainWindow::onLanguagesModelStatusChanged(ResourcesRequest::Status status) {
    bool clickable = false;
    
    switch (status) {
    case ResourcesRequest::Loading:
        statusBar()->showMessage(tr("Loading languages"));
        break;
    case ResourcesRequest::Ready:
        if (m_languagesModel->rowCount() > 0) {
            clickable = true;
            statusBar()->showMessage(tr("Finished"));
        }
        else {
            statusBar()->showMessage(tr("No languages found"));
        }
        
        break;
    case ResourcesRequest::Canceled:
        statusBar()->showMessage(tr("Canceled"));
        break;
    case ResourcesRequest::Failed:
        QMessageBox::critical(this, tr("Languages error"), m_languagesModel->errorString());
        break;
    default:
        break;
    }
#if QT_VERSION >= 0x050000
    m_categoriesView->header()->setSectionsClickable(clickable);
#else
    m_categoriesView->header()->setClickable(clickable);
#endif
}

void MainWindow::onStationsModelStatusChanged(ResourcesRequest::Status status) {
    bool clickable = false;
    
    switch (status) {
    case ResourcesRequest::Loading:
        statusBar()->showMessage(tr("Loading stations"));
        break;
    case ResourcesRequest::Ready:
        if (m_stationsModel->rowCount() > 0) {
            clickable = (m_stationsModel->resource() == "stations");
            statusBar()->showMessage(tr("Finished"));
        }
        else {
            statusBar()->showMessage(tr("No stations found"));
        }
        
        break;
    case ResourcesRequest::Canceled:
        statusBar()->showMessage(tr("Canceled"));
        break;
    case ResourcesRequest::Failed:
        QMessageBox::critical(this, tr("Stations error"), m_stationsModel->errorString());
        break;
    default:
        break;
    }
#if QT_VERSION >= 0x050000
    m_stationsView->header()->setSectionsClickable(clickable);
#else
    m_stationsView->header()->setClickable(clickable);
#endif
}

void MainWindow::onStreamExtractorStatusChanged(StreamExtractor::Status status) {
    switch (status) {
    case StreamExtractor::Loading:
        statusBar()->showMessage(tr("Retrieving stream URL from playlist"));
        break;
    case StreamExtractor::Ready:
        playUrl(m_extractor->result());
        break;
    case StreamExtractor::Canceled:
        statusBar()->showMessage(tr("Canceled"));
        break;
    case StreamExtractor::Error:
        QMessageBox::critical(this, tr("Stream error"), m_extractor->errorString());
        break;
    default:
        break;
    }
}

void MainWindow::onPlayerMetaDataChanged() {
    const QString title = m_player->metaData("Title").isNull()
                          ? m_currentStation.value(StationsModel::TitleRole).toString()
                          : m_player->metaData("Title").toString();
    
    const QString artist = m_player->metaData("Artist").isNull()
                           ? tr("Unknown artist")
                           : m_player->metaData("Artist").toString();
    
    m_nowPlayingLabel->setText(NOW_PLAYING_TEXT.arg(title).arg(artist));
}

void MainWindow::onPlayerStateChanged(QMediaPlayer::State state) {
    switch (state) {
    case QMediaPlayer::StoppedState:
        m_startAction->setEnabled(true);
        m_stopAction->setEnabled(false);
        m_sleepTimerAction->setEnabled(false);
        m_nowPlayingLabel->clear();
        statusBar()->showMessage(tr("Stopped"));
        break;
    case QMediaPlayer::PlayingState:
        m_startAction->setEnabled(false);
        m_stopAction->setEnabled(true);
        m_sleepTimerAction->setEnabled(true);
        onPlayerMetaDataChanged();
        statusBar()->showMessage(tr("Playing"));
        break;
    default:
        break;
    }
}

void MainWindow::onPlayerError() {
    QMessageBox::critical(this, tr("Playback error"), m_player->errorString());
}

void MainWindow::onCurrentStationRowChanged(const QModelIndex &index) {
    m_stationMenu->setEnabled(index.isValid());
}

void MainWindow::updateLogin(const QString &accessToken) {
    const bool loggedIn = !accessToken.isEmpty();
    m_accountAction->setText(loggedIn ? tr("Switch &account") : tr("Login/create &account"));
    m_favouriteAction->setVisible(loggedIn);
    m_genresModel->setAccessToken(accessToken);
    m_countriesModel->setAccessToken(accessToken);
    m_languagesModel->setAccessToken(accessToken);
    m_stationsModel->setAccessToken(accessToken);
    
    if (loggedIn) {
        if (m_navigationModel->rowCount() == 5) {
            if (m_navigationModel->insertRows(5, 3)) {
                m_navigationModel->setData(m_navigationModel->index(5, 0), tr("Recently played stations"), Qt::DisplayRole);
                m_navigationModel->setData(m_navigationModel->index(6, 0), tr("Favourite stations"), Qt::DisplayRole);
                m_navigationModel->setData(m_navigationModel->index(7, 0), tr("My stations"), Qt::DisplayRole);
            }
        }
    }
    else if (m_navigationModel->rowCount() > 5) {
        m_navigationModel->removeRows(5, m_navigationModel->rowCount() - 5);
    }
}
