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
 
#ifndef NAMECOUNTMODEL_H
#define NAMECOUNTMODEL_H

#include "cuteradioreply.h"
#include <QStandardItemModel>
#if QT_VERSION >= 0x050000
#include <qqml.h>
#else
#include <qdeclarative.h>
#endif

class NameCountModel : public QStandardItemModel
{
    Q_OBJECT
    
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(bool canFetchMore READ canFetchMore NOTIFY canFetchMoreChanged)
    Q_PROPERTY(QString url READ url NOTIFY statusChanged)
    Q_PROPERTY(Status status READ status NOTIFY statusChanged)
    Q_PROPERTY(QNetworkReply::NetworkError error READ error NOTIFY statusChanged)
    Q_PROPERTY(QString errorString READ errorString NOTIFY statusChanged)
    
    Q_ENUMS(Roles Status QNetworkReply::NetworkError)
    
public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        NameRole,
        ItemCountRole,
        CreatedRole,
        UpdatedRole,
        SectionRole
    };
    
    enum Status {
        Null = 0,
        Loading,
        Canceled,
        Ready,
        Error
    };
    
    explicit NameCountModel(QObject *parent = 0);
    ~NameCountModel();
    
    QString url() const;
    
    Status status() const;
    
    QNetworkReply::NetworkError error() const;
    QString errorString() const;
    
    Q_INVOKABLE void getItems(const QString &url = QString());
    Q_INVOKABLE void getGenres();
    Q_INVOKABLE void getCountries();
    Q_INVOKABLE void getLanguages();
    Q_INVOKABLE void getSearches();
    
    virtual bool canFetchMore(const QModelIndex &parent = QModelIndex()) const;
    Q_INVOKABLE virtual void fetchMore(const QModelIndex &parent = QModelIndex());
    
#if QT_VERSION >= 0x050000
    virtual QHash<int, QByteArray> roleNames() const;
#endif
    
    Q_INVOKABLE QVariant data(int index, const QString &role) const;
    Q_INVOKABLE QVariantMap itemData(int index) const;
    Q_INVOKABLE bool setData(int index, const QVariant &value, const QString &role);
    Q_INVOKABLE bool setItemData(int index, const QVariantMap &roles);
    
    Q_INVOKABLE int match(const QString &role, const QVariant &value) const;
    
    Q_INVOKABLE void appendItem(const QVariantMap &roles);
    Q_INVOKABLE void insertItem(int index, const QVariantMap &roles);
    Q_INVOKABLE bool removeItem(int index);
    
public slots:
    void clearItems();
    void reloadItems();
    void cancel();
    
private slots:
    void onReplyCanceled(CuteRadioReply *);
    void onReplyFinished(CuteRadioReply *);
    
signals:
    void countChanged();
    void statusChanged();
    void canFetchMoreChanged();
    
private:
    void setStatus(Status status);
    void setReply(CuteRadioReply *);
    
    CuteRadioReply *m_reply;
    
    Status m_status;
    
    QString m_url;
    QString m_nextUrl;
    
    QHash<int, QByteArray> m_roleNames;
};

QML_DECLARE_TYPE(NameCountModel)

#endif
