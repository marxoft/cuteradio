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

#ifndef UPDATEMANAGER_H
#define UPDATEMANAGER_H

#include <QObject>
#include <qdeclarative.h>

class QNetworkAccessManager;
class QNetworkReply;

class UpdateManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(QString latestVersion READ latestVersion NOTIFY statusChanged)
    Q_PROPERTY(Status status READ status NOTIFY statusChanged)
    Q_PROPERTY(QString statusString READ statusString NOTIFY statusChanged)
    
    Q_ENUMS(Status)

public:
    enum Status {
        Null = 0,
        Loading,
        Canceled,
        Ready,
        Error
    };
    
    explicit UpdateManager(QObject *parent = 0);
    ~UpdateManager();
    
    QString url() const;
    void setUrl(const QString &url);

    QString latestVersion() const;

    Status status() const;
    QString statusString() const;

public Q_SLOTS:
    void checkForUpdate();
    void cancel();

private:
    void setStatus(Status status, const QString &desc);
    void downloadUpdate(const QUrl &url);

private Q_SLOTS:
    void checkServerResponse();
    void installUpdate();

Q_SIGNALS:
    void urlChanged();
    void statusChanged();

private:
    QNetworkAccessManager *m_nam;
    QNetworkReply *m_reply;
    
    QString m_url;

    QVariantMap m_latestVersionInfo;
    
    Status m_status;
    QString m_statusString;
};

QML_DECLARE_TYPE(UpdateManager)

#endif // UPDATEMANAGER_H
