#ifndef NETWORKACCESSMANAGER_H
#define NETWORKACCESSMANAGER_H

#include <QNetworkAccessManager>

class NetworkAccessManager : public QNetworkAccessManager
{
    Q_OBJECT

public:
    explicit NetworkAccessManager(QObject *parent = 0);

    static NetworkAccessManager* instance();

private slots:
    void onSSLErrors(QNetworkReply *reply, const QList<QSslError> &errors);

private:
    static NetworkAccessManager *self;
};

#endif // NETWORKACCESSMANAGER_H
