#include "networkaccessmanager.h"
#include <QNetworkReply>

NetworkAccessManager* NetworkAccessManager::self = 0;

NetworkAccessManager::NetworkAccessManager(QObject *parent) :
    QNetworkAccessManager(parent)
{
    if (!self) {
        self = this;
    }

    this->connect(this, SIGNAL(sslErrors(QNetworkReply*,QList<QSslError>)), this, SLOT(onSSLErrors(QNetworkReply*,QList<QSslError>)));
}

NetworkAccessManager* NetworkAccessManager::instance() {
    return !self ? new NetworkAccessManager : self;
}

void NetworkAccessManager::onSSLErrors(QNetworkReply *reply, const QList<QSslError> &errors) {
    reply->ignoreSslErrors(errors);
}
