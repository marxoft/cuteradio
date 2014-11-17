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
 
#include "stationmodel.h"
#include "cuteradio.h"
#include "cuteradioreply.h"
#include "urls.h"

StationModel::StationModel(QObject *parent) :
    QStandardItemModel(parent),
    m_reply(0),
    m_status(Null)
{
    m_roleNames[IdRole] = "id";
    m_roleNames[TitleRole] = "title";
    m_roleNames[DescriptionRole] = "description";
    m_roleNames[GenreRole] = "genre";
    m_roleNames[CountryRole] = "country";
    m_roleNames[LanguageRole] = "language";
    m_roleNames[LogoRole] = "logo";
    m_roleNames[SourceRole] = "source";
    m_roleNames[FavouriteRole] = "is_favourite";
    m_roleNames[FavouriteIdRole] = "favourite_id";
    m_roleNames[LastPlayedRole] = "last_played";
    m_roleNames[CreatedRole] = "created";
    m_roleNames[UpdatedRole] = "updated";
    m_roleNames[TitleSectionRole] = "title_section";
    m_roleNames[UpdatedSectionRole] = "updated_section";
#if QT_VERSION < 0x050000
    this->setRoleNames(m_roleNames);
#endif
}

StationModel::~StationModel() {
    if (m_reply) {
        delete m_reply;
        m_reply = 0;
    }
}

QString StationModel::url() const {
    return m_url;
}

StationModel::Status StationModel::status() const {
    return m_status;
}

void StationModel::setStatus(Status status) {
    if (status != this->status()) {
        m_status = status;
        emit statusChanged();
    }
}

QNetworkReply::NetworkError StationModel::error() const {
    return m_reply ? m_reply->error() : QNetworkReply::NoError;
}

QString StationModel::errorString() const {
    return m_reply ? m_reply->errorString() : QString();
}

void StationModel::setReply(CuteRadioReply *reply) {
    if (reply == m_reply) {
        return;
    }
    
    if (m_reply) {
        delete m_reply;
    }
    
    m_reply = reply;
    
    if (reply) {
        this->connect(reply, SIGNAL(canceled(CuteRadioReply*)), this, SLOT(onReplyCanceled(CuteRadioReply*)));
        this->connect(reply, SIGNAL(finished(CuteRadioReply*)), this, SLOT(onReplyFinished(CuteRadioReply*)));
    }
}

void StationModel::clearItems() {
    m_url.clear();
    m_nextUrl.clear();
    this->clear();
    this->setStatus(Null);
    emit countChanged();
}

void StationModel::reloadItems() {
    if (!m_url.isEmpty()) {
        this->getStations(QString(m_url));
    }
}

void StationModel::cancel() {
    if (m_reply) {
        m_reply->cancel();
    }
}

void StationModel::getStations(const QString &url) {
    this->clearItems();
    this->setStatus(Loading);
    this->setReply(CuteRadio::getStations(url));
}

void StationModel::searchStations(const QString &query) {
    this->clearItems();
    this->setStatus(Loading);
    this->setReply(CuteRadio::searchStations(query));
}

void StationModel::getStationsByGenre(const QString &genre) {
    this->clearItems();
    this->setStatus(Loading);
    this->setReply(CuteRadio::getStationsByGenre(genre));
}

void StationModel::getStationsByCountry(const QString &country) {
    this->clearItems();
    this->setStatus(Loading);
    this->setReply(CuteRadio::getStationsByCountry(country));
}

void StationModel::getStationsByLanguage(const QString &language) {
    this->clearItems();
    this->setStatus(Loading);
    this->setReply(CuteRadio::getStationsByLanguage(language));
}

void StationModel::getMyStations() {
    this->clearItems();
    this->setStatus(Loading);
    this->setReply(CuteRadio::getMyStations());
}

void StationModel::getFavouriteStations() {
    this->clearItems();
    this->setStatus(Loading);
    this->setReply(CuteRadio::getFavouriteStations());
}

void StationModel::getRecentlyPlayedStations() {
    this->clearItems();
    this->setStatus(Loading);
    this->setReply(CuteRadio::getRecentlyPlayedStations());
}

bool StationModel::canFetchMore(const QModelIndex &) const {
    switch (this->status()) {
    case Ready:
        return !m_nextUrl.isEmpty();
    default:
        return false;
    }
}

void StationModel::fetchMore(const QModelIndex &) {
    if (this->canFetchMore()) {
        this->setStatus(Loading);
        this->setReply(CuteRadio::getStations(m_nextUrl));
    }
}

#if QT_VERSION >= 0x050000
QHash<int, QByteArray> StationModel::roleNames() const {
    return m_roleNames;
}
#endif

QVariant StationModel::data(int index, const QString &role) const {
    return QStandardItemModel::data(this->index(index, 0, QModelIndex()), m_roleNames.key(role.toUtf8()));
}

QVariantMap StationModel::itemData(int index) const {
    QVariantMap map;
    QMapIterator<int, QVariant> iterator(QStandardItemModel::itemData(this->index(index, 0, QModelIndex())));
    
    while (iterator.hasNext()) {
        iterator.next();
        map[m_roleNames[iterator.key()]] = iterator.value();
    }
    
    return map;
}

bool StationModel::setData(int index, const QVariant &value, const QString &role) {
    return QStandardItemModel::setData(this->index(index, 0, QModelIndex()), value, m_roleNames.key(role.toUtf8()));
}

bool StationModel::setItemData(int index, const QVariantMap &roles) {
    QMap<int, QVariant> map;
    QMapIterator<QString, QVariant> iterator(roles);
    
    while (iterator.hasNext()) {
        iterator.next();
        map[m_roleNames.key(iterator.key().toUtf8())] = iterator.value();
    }

    map[TitleSectionRole] = roles.value("title").toString().left(1).toUpper();
    map[UpdatedSectionRole] = roles.value("updated").toString().left(16);
    
    return QStandardItemModel::setItemData(this->index(index, 0, QModelIndex()), map);
}

int StationModel::match(const QString &role, const QVariant &value) const {
    for (int i = 0; i < this->rowCount(); i++) {
        if (this->data(i, role) == value) {
            return i;
        }
    }
    
    return -1;
}

void StationModel::appendItem(const QVariantMap &roles) {
    QStandardItem *item = new QStandardItem;
    item->setText(roles.value("name").toString());
    
    QHashIterator<int, QByteArray> iterator(m_roleNames);
    
    while (iterator.hasNext()) {
        iterator.next();
        item->setData(roles.value(iterator.value()), iterator.key());
    }

    item->setData(item->text().left(1).toUpper(), TitleSectionRole);
    item->setData(roles.value("updated").toString().left(16), UpdatedSectionRole);
    
    this->appendRow(item);
}

void StationModel::insertItem(int index, const QVariantMap &roles) {
    QStandardItem *item = new QStandardItem;
    item->setText(roles.value("name").toString());
    
    QHashIterator<int, QByteArray> iterator(m_roleNames);
    
    while (iterator.hasNext()) {
        iterator.next();
        item->setData(roles.value(iterator.value()), iterator.key());
    }

    item->setData(item->text().left(1).toUpper(), TitleSectionRole);
    item->setData(roles.value("updated").toString().left(16), UpdatedSectionRole);
    
    this->insertRow(index, item);
}

bool StationModel::removeItem(int index) {
    return this->removeRows(index, 1);
}

void StationModel::onReplyCanceled(CuteRadioReply *) {
    this->setStatus(Canceled);
}
    
void StationModel::onReplyFinished(CuteRadioReply *reply) {
    switch (reply->error()) {
    case QNetworkReply::NoError:
        break;
    case QNetworkReply::OperationCanceledError:
        this->setStatus(Canceled);
        return;
    default:
        this->setStatus(Error);
        return;
    }
    
    QVariantMap result = reply->result().toMap();
    QVariant error = result.value("error");
    
    if ((result.isEmpty()) || (error.isValid())) {
        this->setStatus(Error);
    }
    else {
        QVariantMap urls = result.value("links").toMap();
        QString next = urls.value("next").toMap().value("href").toString();
        m_nextUrl.clear();

        if (m_url.isEmpty()) {
            m_url = reply->url();
        }
        
        if (!next.isEmpty()) {
            m_nextUrl = "https://" + next;
        }
        
        QHashIterator<int, QByteArray> iterator(m_roleNames);
        
        foreach (QVariant item, result.value("items").toList()) {
            QVariantMap station = item.toMap();
            
            if (!station.isEmpty()) {
                QStandardItem *si = new QStandardItem;
                si->setText(station.value("title").toString());
                
                iterator.toFront();
                
                while (iterator.hasNext()) {
                    iterator.next();
                    si->setData(station.value(iterator.value()), iterator.key());
                }

                si->setData(si->text().left(1).toUpper(), TitleSectionRole);
                si->setData(station.value("updated").toString().left(16), UpdatedSectionRole);
                
                this->appendRow(si);
            }
        }
        
        emit countChanged();
        this->setStatus(Ready);
    }
}
