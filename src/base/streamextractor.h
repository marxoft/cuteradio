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

#ifndef STREAMEXTRACTOR_H
#define STREAMEXTRACTOR_H

#include <QNetworkReply>
#include <qdeclarative.h>

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
    
public slots:
    void getStreamUrl(const QString &url);
    void cancel();

private:
    void setStatus(Status status);
    void retry(const QUrl &url);

private slots:
    void parseResponse();

signals:
    void statusChanged();

private:
    QNetworkReply *m_reply;
    
    Status m_status;
    
    int m_retries;
    
    QString m_result;
};

QML_DECLARE_TYPE(StreamExtractor)

#endif
