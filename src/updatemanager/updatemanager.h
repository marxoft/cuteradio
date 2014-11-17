#ifndef UPDATEMANAGER_H
#define UPDATEMANAGER_H

#include <QObject>
#include <qdeclarative.h>

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

public slots:
    void checkForUpdate();
    void cancel();

private:
    void setStatus(Status status, const QString &desc);
    void downloadUpdate(const QUrl &url);

private slots:
    void checkServerResponse();
    void installUpdate();

signals:
    void urlChanged();
    void statusChanged();

private:
    QNetworkReply *m_reply;
    
    QString m_url;

    QVariantMap m_latestVersionInfo;
    
    Status m_status;
    QString m_statusString;
};

QML_DECLARE_TYPE(UpdateManager)

#endif // UPDATEMANAGER_H
