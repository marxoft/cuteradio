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
 
#include "cuteradiorequest.h"
#include "cuteradio.h"
#include <QDebug>

CuteRadioRequest::CuteRadioRequest(QObject *parent) :
    QObject(parent),
    m_reply(0),
    m_auth(true),
    m_status(Null)
{
}

CuteRadioRequest::~CuteRadioRequest() {
    if (m_reply) {
        delete m_reply;
        m_reply = 0;
    }
}

QString CuteRadioRequest::url() const {
    return m_url;
}

void CuteRadioRequest::setUrl(const QString &url) {
    if (url != this->url()) {
        m_url = url;
        emit urlChanged();
    }
}

QVariant CuteRadioRequest::data() const {
    return m_data;
}

void CuteRadioRequest::setData(const QVariant &data) {
    if (data != this->data()) {
        m_data = data;
        emit dataChanged();
    }
}

void CuteRadioRequest::resetData() {
    this->setData(QVariant());
}

bool CuteRadioRequest::authRequired() const {
    return m_auth;
}

void CuteRadioRequest::setAuthRequired(bool auth) {
    if (auth != this->authRequired()) {
        m_auth = auth;
        emit authRequiredChanged();
    }
}

CuteRadioRequest::Status CuteRadioRequest::status() const {
    return m_status;
}

void CuteRadioRequest::setStatus(Status status) {
    if (status != this->status()) {
        m_status = status;
        emit statusChanged();
    }
}

QVariant CuteRadioRequest::result() const {
    return m_result;
}

QNetworkReply::NetworkError CuteRadioRequest::error() const {
    return m_reply ? m_reply->error() : QNetworkReply::NoError;
}

QString CuteRadioRequest::errorString() const {
    return m_reply ? m_reply->errorString() : QString();
}

void CuteRadioRequest::setReply(CuteRadioReply *reply) {
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

void CuteRadioRequest::get() {
    if (this->url().isEmpty()) {
        qDebug() << "CuteRadioRequest::get: url is empty";
        return;
    }
    
    this->setStatus(Loading);
    this->setReply(CuteRadio::get(this->url(), this->authRequired()));
}

void CuteRadioRequest::post() {
    if (this->url().isEmpty()) {
        qDebug() << "CuteRadioRequest::post: url is empty";
        return;
    }
    
    if (this->data().isNull()) {
        qDebug() << "CuteRadioRequest::post: data is null";
        return;
    }
    
    this->setStatus(Loading);
    this->setReply(CuteRadio::post(this->url(), this->data(), this->authRequired()));
}

void CuteRadioRequest::put() {
    if (this->url().isEmpty()) {
        qDebug() << "CuteRadioRequest::put: url is empty";
        return;
    }
    
    if (this->data().isNull()) {
        qDebug() << "CuteRadioRequest::put: data is null";
        return;
    }
    
    this->setStatus(Loading);
    this->setReply(CuteRadio::put(this->url(), this->data(), this->authRequired()));
}

void CuteRadioRequest::deleteResource() {
    if (this->url().isEmpty()) {
        qDebug() << "CuteRadioRequest::deleteResource: url is empty";
        return;
    }
    
    this->setStatus(Loading);
    this->setReply(CuteRadio::deleteResource(this->url(), this->authRequired()));
}

void CuteRadioRequest::cancel() {
    if (m_reply) {
        m_reply->cancel();
    }
}

void CuteRadioRequest::onReplyCanceled(CuteRadioReply *) {
    this->setStatus(Canceled);
}

void CuteRadioRequest::onReplyFinished(CuteRadioReply *reply) {
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
    
    m_result = reply->result();
    this->setStatus(Ready);
}
