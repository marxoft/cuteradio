#include "updatemanager.h"
#include "networkaccessmanager.h"
#include "json.h"
#include "definitions.h"
#include <QNetworkReply>
#include <QFile>
#include <QDebug>
#include <qplatformdefs.h>
#include <QCryptographicHash>
#if QT_VERSION >= 0x050000
#include <QStandardPaths>
#else
#include <QDesktopServices>
#endif

using namespace QtJson;

UpdateManager::UpdateManager(QObject *parent) :
    QObject(parent),
    m_reply(0),
    m_status(Null)
{
}

UpdateManager::~UpdateManager() {
    if (m_reply) {
        delete m_reply;
        m_reply = 0;
    }
}

QString UpdateManager::url() const {
    return m_url;
}

void UpdateManager::setUrl(const QString &url) {
    if (url != this->url()) {
        m_url = url;
        emit urlChanged();
    }
}

QString UpdateManager::latestVersion() const {
    return m_latestVersionInfo.value("version").toString();
}

UpdateManager::Status UpdateManager::status() const {
    return m_status;
}

QString UpdateManager::statusString() const {
    return m_statusString;
}

void UpdateManager::setStatus(Status status, const QString &desc) {
    m_status = status;
    m_statusString = desc;
    emit statusChanged();
}

void UpdateManager::checkForUpdate() {
    this->setStatus(Loading, tr("Checking for update"));
    QNetworkRequest request(this->url());
    m_reply = NetworkAccessManager::instance()->get(request);
    this->connect(m_reply, SIGNAL(finished()), this, SLOT(checkServerResponse()));
}

void UpdateManager::cancel() {
    if (m_reply) {
        m_reply->deleteLater();
        m_reply = 0;
        this->setStatus(Canceled, tr("Canceled"));
    }
}

void UpdateManager::checkServerResponse() {
    if (!m_reply) {
        return;
    }

    QString response(m_reply->readAll());
    m_latestVersionInfo = Json::parse(response).toMap();
    QString newVersion = m_latestVersionInfo.value("version").toString();
    QUrl url = m_latestVersionInfo.value("url").toUrl();

    if (newVersion.isEmpty()) {
        this->setStatus(Error, tr("No update information found. Please try again later"));
    }
    else {
        QString oldVersion = VERSION_NUMBER;

        qDebug() << "Old version: " + oldVersion;
        qDebug() << "New version: " + newVersion;

        int newMajor = newVersion.section('.', 0, 0).toInt();
        int newMinor = newVersion.section('.', 1, 1).toInt();
        int newPatch = newVersion.section('.', -1).toInt();

        int oldMajor = oldVersion.section('.', 0, 0).toInt();
        int oldMinor = oldVersion.section('.', 1, 1).toInt();
        int oldPatch = oldVersion.section('.', -1).toInt();

        if ((newMajor > oldMajor) || (newMinor > oldMinor) || (newPatch > oldPatch)) {
            if (url.isEmpty()) {
                this->setStatus(Error, tr("No update information found. Please try again later"));
            }
            else {
                this->downloadUpdate(url);
            }
        }
        else {
            this->setStatus(Ready, QString("%1\n\n%2: %3\n%4: %5")
                                   .arg(tr("Latest version already installed"))
                                   .arg(tr("Current version"))
                                   .arg(oldVersion)
                                   .arg(tr("Latest version"))
                                   .arg(newVersion));
        }
    }
}

void UpdateManager::downloadUpdate(const QUrl &url) {
    this->setStatus(Loading, QString("%1 %2 %3. %4")
                             .arg(tr("Version"))
                             .arg(this->latestVersion())
                             .arg(tr("available"))
                             .arg(tr("Downloading and checking Md5 hash sum")));
                             
    QNetworkRequest request(url);
    m_reply = NetworkAccessManager::instance()->get(request);
    this->connect(m_reply, SIGNAL(finished()), this, SLOT(installUpdate()));
}

void UpdateManager::installUpdate() {
    if (!m_reply) {
        return;
    }

    QUrl redirect = m_reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();

    if (!redirect.isEmpty()) {
        this->downloadUpdate(redirect);
    }
    else {
        QByteArray data = m_reply->readAll();
        QByteArray storedHash = m_latestVersionInfo.value("hash").toByteArray();
        QByteArray actualHash = QCryptographicHash::hash(data, QCryptographicHash::Md5).toHex();

        qDebug() << "Stored hash: " + storedHash;
        qDebug() << "Actual hash: " + actualHash;

        if (actualHash != storedHash) {
            this->setStatus(Error, QString("%1.\n\n%2: %3\n%4: %5")
                                   .arg(tr("Md5 hash sum of installation package does not match the stored hash sum"))
                                   .arg(tr("Stored hash sum"))
                                   .arg(QString(storedHash))
                                   .arg(tr("Actual hash sum"))
                                   .arg(QString(actualHash)));
        }
        else {
#ifdef SYMBIAN_OS
            QFile file("E:/" + m_reply->request().url().toString().section('/', -1));
#elif QT_VERSION >= 0x050000
            QFile file(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation)
                       + "/" + m_reply->request().url().toString().section('/', -1));
#else
            QFile file(QDesktopServices::storageLocation(QDesktopServices::DocumentsLocation)
                       + "/" + m_reply->request().url().toString().section('/', -1));
#endif
            if (file.exists()) {
                file.remove();
            }

            if (file.open(QIODevice::WriteOnly)) {
                file.write(data);
                file.close();
#ifdef MEEGO_EDITION_HARMATTAN
                this->setStatus(Ready, QString("%1 %2. %3.")
                                       .arg(tr("Installation package saved to"))
                                       .arg(file.fileName())
                                       .arg(tr("Please ensure that installations \
                                       from non-Store sources are enabled before installing")));
#else
                this->setStatus(Ready, QString("%1 %2.")
                                       .arg(tr("Installation package saved to"))
                                       .arg(file.fileName()));
#endif
            }
            else {
                this->setStatus(Error, tr("Unable to save installation package"));
            }
        }
    }
}
