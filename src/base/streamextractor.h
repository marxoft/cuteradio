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

#ifndef STREAMEXTRACTOR_H
#define STREAMEXTRACTOR_H

#include <QNetworkReply>

class QNetworkAccessManager;
class QUrl;

class StreamExtractor : public QObject
{
    Q_OBJECT
    
    Q_PROPERTY(Status status READ status NOTIFY statusChanged)
    Q_PROPERTY(QString result READ result NOTIFY statusChanged)
    Q_PROPERTY(QNetworkReply::NetworkError error READ error NOTIFY statusChanged)
    Q_PROPERTY(QString errorString READ errorString NOTIFY statusChanged)
    
    Q_ENUMS(Status QNetworkReply::NetworkError)

public:
    enum Status {
        Null = 0,
        Loading,
        Canceled,
        Ready,
        Error
    };
    
    explicit StreamExtractor(QObject *parent = 0);
    ~StreamExtractor();

    Status status() const;
    
    QString result() const;
    
    QNetworkReply::NetworkError error() const;
    QString errorString() const;
    
public Q_SLOTS:
    void getStreamUrl(const QUrl &url);
    void cancel();

private:    
    void setStatus(Status s);
    
    void retry(const QUrl &url);
    
    QNetworkAccessManager* networkAccessManager();

private Q_SLOTS:
    void parseResponse();

Q_SIGNALS:
    void statusChanged(StreamExtractor::Status status);

private:
    QNetworkAccessManager *m_nam;
    QNetworkReply *m_reply;
    
    Status m_status;
    
    int m_retries;
    
    QString m_result;
};

#endif
