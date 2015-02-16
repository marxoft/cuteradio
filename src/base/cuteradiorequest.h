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
 
#ifndef CUTERADIOREQUEST_H
#define CUTERADIOREQUEST_H

#include "cuteradioreply.h"
#if QT_VERSION >= 0x050000
#include <qqml.h>
#else
#include <qdeclarative.h>
#endif

class CuteRadioRequest : public QObject
{
    Q_OBJECT
    
    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(QVariant data READ data WRITE setData RESET resetData NOTIFY dataChanged)
    Q_PROPERTY(bool authRequired READ authRequired WRITE setAuthRequired NOTIFY authRequiredChanged)
    Q_PROPERTY(Status status READ status NOTIFY statusChanged)
    Q_PROPERTY(QVariant result READ result NOTIFY statusChanged)
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
    
    explicit CuteRadioRequest(QObject *parent = 0);
    ~CuteRadioRequest();
    
    QString url() const;
    void setUrl(const QString &url);
    
    QVariant data() const;
    void setData(const QVariant &data);
    void resetData();
    
    bool authRequired() const;
    void setAuthRequired(bool auth);
    
    Status status() const;
    
    QVariant result() const;
    
    QNetworkReply::NetworkError error() const;
    QString errorString() const;
    
public slots:
    void get();
    void post();
    void put();
    void deleteResource();
    void cancel();
    
private slots:
    void onReplyCanceled(CuteRadioReply *);
    void onReplyFinished(CuteRadioReply *);
    
signals:
    void urlChanged();
    void dataChanged();
    void authRequiredChanged();
    void statusChanged();
    
private:
    void setStatus(Status status);
    void setReply(CuteRadioReply *);
    
    CuteRadioReply *m_reply;
    
    QString m_url;
    QVariant m_data;
    QVariant m_result;
    bool m_auth;
    
    Status m_status;
};

QML_DECLARE_TYPE(CuteRadioRequest)

#endif
