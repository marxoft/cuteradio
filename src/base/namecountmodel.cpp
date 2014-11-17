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
 
#include "namecountmodel.h"
#include "cuteradio.h"
#include "cuteradioreply.h"
#include "urls.h"

NameCountModel::NameCountModel(QObject *parent) :
    QStandardItemModel(parent),
    m_reply(0),
    m_status(Null)
{
    m_roleNames[IdRole] = "id";
    m_roleNames[NameRole] = "name";
    m_roleNames[ItemCountRole] = "item_count";
    m_roleNames[CreatedRole] = "created";
    m_roleNames[UpdatedRole] = "updated";
    m_roleNames[SectionRole] = "section";
#if QT_VERSION < 0x050000
    this->setRoleNames(m_roleNames);
#endif
}

NameCountModel::~NameCountModel() {
    if (m_reply) {
        delete m_reply;
        m_reply = 0;
    }
}

QString NameCountModel::url() const {
    return m_url;
}

NameCountModel::Status NameCountModel::status() const {
    return m_status;
}

void NameCountModel::setStatus(Status status) {
    if (status != this->status()) {
        m_status = status;
        emit statusChanged();
    }
}

QNetworkReply::NetworkError NameCountModel::error() const {
    return m_reply ? m_reply->error() : QNetworkReply::NoError;
}

QString NameCountModel::errorString() const {
    return m_reply ? m_reply->errorString() : QString();
}

void NameCountModel::setReply(CuteRadioReply *reply) {
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

void NameCountModel::clearItems() {
    m_url.clear();
    m_nextUrl.clear();
    this->clear();
    this->setStatus(Null);
    emit countChanged();
}

void NameCountModel::reloadItems() {
    if (!m_url.isEmpty()) {
        this->getItems(QString(m_url));
    }
}

void NameCountModel::cancel() {
    if (m_reply) {
        m_reply->cancel();
    }
}

void NameCountModel::getItems(const QString &url) {
    this->clearItems();
    this->setStatus(Loading);
    this->setReply(CuteRadio::get(url));
}

void NameCountModel::getGenres() {
    this->clearItems();
    this->setStatus(Loading);
    this->setReply(CuteRadio::getGenres());
}

void NameCountModel::getCountries() {
    this->clearItems();
    this->setStatus(Loading);
    this->setReply(CuteRadio::getCountries());
}

void NameCountModel::getLanguages() {
    this->clearItems();
    this->setStatus(Loading);
    this->setReply(CuteRadio::getLanguages());
}

void NameCountModel::getSearches() {
    this->clearItems();
    this->setStatus(Loading);
    this->setReply(CuteRadio::getSearches());
}

bool NameCountModel::canFetchMore(const QModelIndex &) const {
    switch (this->status()) {
    case Ready:
        return !m_nextUrl.isEmpty();
    default:
        return false;
    }
}

void NameCountModel::fetchMore(const QModelIndex &) {
    if (this->canFetchMore()) {
        this->setStatus(Loading);
        this->setReply(CuteRadio::get(m_nextUrl));
    }
}

#if QT_VERSION >= 0x050000
QHash<int, QByteArray> NameCountModel::roleNames() const {
    return m_roleNames;
}
#endif

QVariant NameCountModel::data(int index, const QString &role) const {
    return QStandardItemModel::data(this->index(index, 0, QModelIndex()), m_roleNames.key(role.toUtf8()));
}

QVariantMap NameCountModel::itemData(int index) const {
    QVariantMap map;
    QMapIterator<int, QVariant> iterator(QStandardItemModel::itemData(this->index(index, 0, QModelIndex())));
    
    while (iterator.hasNext()) {
        iterator.next();
        map[m_roleNames[iterator.key()]] = iterator.value();
    }
    
    return map;
}

bool NameCountModel::setData(int index, const QVariant &value, const QString &role) {
    return QStandardItemModel::setData(this->index(index, 0, QModelIndex()), value, m_roleNames.key(role.toUtf8()));
}

bool NameCountModel::setItemData(int index, const QVariantMap &roles) {
    QMap<int, QVariant> map;
    QMapIterator<QString, QVariant> iterator(roles);
    
    while (iterator.hasNext()) {
        iterator.next();
        map[m_roleNames.key(iterator.key().toUtf8())] = iterator.value();
    }

    map[SectionRole] = roles.value("name").toString().left(1).toUpper();
    
    return QStandardItemModel::setItemData(this->index(index, 0, QModelIndex()), map);
}

int NameCountModel::match(const QString &role, const QVariant &value) const {
    for (int i = 0; i < this->rowCount(); i++) {
        if (this->data(i, role) == value) {
            return i;
        }
    }
    
    return -1;
}

void NameCountModel::appendItem(const QVariantMap &roles) {
    QStandardItem *item = new QStandardItem;
    item->setText(roles.value("name").toString());
    
    QHashIterator<int, QByteArray> iterator(m_roleNames);
    
    while (iterator.hasNext()) {
        iterator.next();
        item->setData(roles.value(iterator.value()), iterator.key());
    }

    item->setData(item->text().left(1).toUpper(), SectionRole);
    
    this->appendRow(item);
}

void NameCountModel::insertItem(int index, const QVariantMap &roles) {
    QStandardItem *item = new QStandardItem;
    item->setText(roles.value("name").toString());
    
    QHashIterator<int, QByteArray> iterator(m_roleNames);
    
    while (iterator.hasNext()) {
        iterator.next();
        item->setData(roles.value(iterator.value()), iterator.key());
    }

    item->setData(item->text().left(1).toUpper(), SectionRole);
    
    this->insertRow(index, item);
}

bool NameCountModel::removeItem(int index) {
    return this->removeRows(index, 1);
}

void NameCountModel::onReplyCanceled(CuteRadioReply *) {
    this->setStatus(Canceled);
}
    
void NameCountModel::onReplyFinished(CuteRadioReply *reply) {
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
                si->setText(station.value("name").toString());
                
                iterator.toFront();
                
                while (iterator.hasNext()) {
                    iterator.next();
                    si->setData(station.value(iterator.value()), iterator.key());
                }

                si->setData(si->text().left(1).toUpper(), SectionRole);
                
                this->appendRow(si);
            }
        }
        
        emit countChanged();
        this->setStatus(Ready);
    }
}
