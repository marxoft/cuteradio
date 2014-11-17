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
 
#include "cuteradioreply.h"
#include "json.h"
#ifdef CUTERADIO_DEBUG
#include <QDebug>
#endif

CuteRadioReply::CuteRadioReply(QNetworkReply *reply, QObject *parent) :
    QObject(parent),
    m_reply(reply)
{
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadioReply::CuteRadioReply: request:";
    qDebug() << "operation:" << reply->operation();
    qDebug() << "url:" << reply->url();
    qDebug() << "headers:";
    
    foreach (QByteArray header, reply->request().rawHeaderList()) {
        qDebug() << header + ":" << reply->request().rawHeader(header);
    }
#endif
    this->connect(reply, SIGNAL(finished()), this, SLOT(onReplyFinished()));
}

CuteRadioReply::~CuteRadioReply() {
    if (m_reply) {
        delete m_reply;
        m_reply = 0;
    }
}

QString CuteRadioReply::url() const {
    return m_reply ? m_reply->url().toString() : QString();
}

QVariant CuteRadioReply::result() const {
    return m_result;
}

QNetworkReply::NetworkError CuteRadioReply::error() const {
    return m_reply ? m_reply->error() : QNetworkReply::NoError;
}

QString CuteRadioReply::errorString() const {
    return m_reply ? m_reply->errorString() : QString();
}

void CuteRadioReply::cancel() {
    if (m_reply) {
        m_reply->abort();
    }
    else {
        emit canceled(this);
    }
}

void CuteRadioReply::onReplyFinished() {
    if (!m_reply) {
        return;
    }

    switch (m_reply->error()) {
    case QNetworkReply::OperationCanceledError:
        emit canceled(this);
        return;
    default:
        break;
    }

    m_result = QtJson::Json::parse(QString(m_reply->readAll()));
#ifdef CUTERADIO_DEBUG
    qDebug() << "CuteRadioReply::onReplyFinished: result:" << m_result;
#endif
    emit finished(this);
}
