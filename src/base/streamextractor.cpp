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

#include "streamextractor.h"
#include "utils.h"
#include <QNetworkAccessManager>
#include <QRegExp>
#include <QDomDocument>
#include <QDomElement>
#ifdef CUTERADIO_DEBUG
#include <QDebug>
#endif

static const int MAX_RETRIES = 8;

StreamExtractor::StreamExtractor(QObject *parent) :
    QObject(parent),
    m_nam(0),
    m_reply(0),
    m_status(Null),
    m_retries(0)
{
}

StreamExtractor::~StreamExtractor() {
    if (m_reply) {
        delete m_reply;
        m_reply = 0;
    }
}

static QString getUrlFromUnknownFile(const QString &response) {
    QRegExp re("(http(s|)|mms)://[^\\s\"'<>]+", Qt::CaseInsensitive);

    return re.indexIn(response) >= 0 ? re.cap() : QString();
}

static QString getUrlFromASXFile(const QString &response) {
    QDomDocument doc;
    doc.setContent(response.toLower());
    QDomNode node = doc.documentElement().namedItem("entry");
    QDomElement href = node.isNull() ? doc.documentElement().namedItem("entryref").toElement()
                                     : node.firstChildElement("ref");

    return href.isNull() ? getUrlFromUnknownFile(response) : href.attribute("href");
}

static QString getUrlFromPLSFile(const QString &response) {
    return response.section(QRegExp("File\\d=", Qt::CaseInsensitive), 1, 1).section(QRegExp("\\s"), 0, 0);
}

static QString getUrlFromM3UFile(const QString &response) {
    QRegExp re("(http(s|)|mms)://\\S+", Qt::CaseInsensitive);

    return re.indexIn(response) >= 0 ? re.cap() : getUrlFromUnknownFile(response);
}

static QString getUrlFromSMILFile(const QString &response) {
    QDomDocument doc;
    doc.setContent(response.toLower());
    QDomNode node = doc.documentElement().namedItem("body");

    return node.isNull() ? getUrlFromUnknownFile(response)
                         : node.firstChildElement("audio").attribute("src");
}

static QString getUrlFromRAMFile(const QString &response) {
    QRegExp re("(http(s|)|mms)://\\S+", Qt::CaseInsensitive);

    return re.indexIn(response) >= 0 ? re.cap() : getUrlFromUnknownFile(response);
}

static QString getUrlFromPlaylistFile(const QString &response, const QString &format) {
    if (format == "asx") {
        return getUrlFromASXFile(response);
    }
    else if (format == "pls") {
        return getUrlFromPLSFile(response);
    }
    else if (format == "m3u") {
        return getUrlFromM3UFile(response);
    }
    else if (format == "smil") {
        return getUrlFromSMILFile(response);
    }
    else if (format == "ram") {
        return getUrlFromRAMFile(response);
    }
    else {
        return getUrlFromUnknownFile(response);
    }
}

StreamExtractor::Status StreamExtractor::status() const {
    return m_status;
}

void StreamExtractor::setStatus(Status s) {
    if (s != status()) {
        m_status = s;
        emit statusChanged(s);
    }
}

QString StreamExtractor::result() const {
    return m_result;
}

QNetworkReply::NetworkError StreamExtractor::error() const {
    return m_reply ? m_reply->error() : QNetworkReply::NoError;
}

QString StreamExtractor::errorString() const {
    return m_reply ? m_reply->errorString() : QString();
}

QNetworkAccessManager* StreamExtractor::networkAccessManager() {
    return m_nam ? m_nam : m_nam = new QNetworkAccessManager(this);
}

void StreamExtractor::cancel() {
    if (m_reply) {
        m_reply->abort();
    }
}

void StreamExtractor::getStreamUrl(const QUrl &url) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "StreamExtractor::getStreamUrl:" << url;
#endif
    if (m_reply) {
        delete m_reply;
    }
    
    m_retries = 0;
    setStatus(Loading);
    QNetworkRequest request(url);
    m_reply = networkAccessManager()->get(request);
    connect(m_reply, SIGNAL(finished()), this, SLOT(parseResponse()));
}

void StreamExtractor::retry(const QUrl &url) {
#ifdef CUTERADIO_DEBUG
    qDebug() << "StreamExtractor::retry:" << url;
#endif
    if (m_reply) {
        delete m_reply;
    }
    
    QNetworkRequest request(url);
    m_reply = networkAccessManager()->get(request);
    connect(m_reply, SIGNAL(finished()), this, SLOT(parseResponse()));
}

void StreamExtractor::parseResponse() {
#ifdef CUTERADIO_DEBUG
    qDebug() << "StreamExtractor::parseResponse";
#endif
    if (!m_reply) {
        return;
    }

    switch (m_reply->error()) {
    case QNetworkReply::NoError:
        break;
    case QNetworkReply::OperationCanceledError:
        setStatus(Canceled);
        return;
    default:
        setStatus(Error);
        return;
    }

    QString redirect = m_reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toString();

    if (!redirect.isEmpty()) {
        if (m_retries < MAX_RETRIES) {
            m_retries++;
            retry(redirect);
        }
        else {
            setStatus(Error);
        }
    }
    else {
        const QString response = QString::fromUtf8(m_reply->readAll());
#ifdef CUTERADIO_DEBUG
        qDebug() << "response:" << response;
#endif
        const QString format = m_reply->url().toString().section('.', -1).toLower();
        const QString url = getUrlFromPlaylistFile(response, format);

        if (url.isEmpty()) {
            setStatus(Error);
        }
        else {
            if (Utils::isPlaylist(url)) {
                if (m_retries < MAX_RETRIES) {
                    m_retries++;
                    retry(url);
                }
                else {
                    setStatus(Error);
                }
            }
            else {
                m_result = url;
#ifdef CUTERADIO_DEBUG
                qDebug() << "result:" << m_result;
#endif
                setStatus(Ready);
            }
        }
    }
}
