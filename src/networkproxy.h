/****************************************************************************
**
** Copyright (C) 2018  DH Electroncis GmbH
** Contact: https://www.dh-electronics.com/
**
****************************************************************************/
#ifndef PROXY_H
#define PROXY_H

#include <QObject>
#include <QNetworkProxy>

class NetworkProxy : public QObject
{
    Q_OBJECT

    Q_PROPERTY (int type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY (int port READ port WRITE setPort NOTIFY portChanged)
    Q_PROPERTY (QString user READ user WRITE setUser NOTIFY userChanged)
    Q_PROPERTY (QString password READ password WRITE setPassword NOTIFY passwordChanged)
    Q_PROPERTY (QString hostName READ hostName WRITE setHostName NOTIFY hostNameChanged)

public:
    void setType(int);
    void setPort(int);
    void setUser(QString);
    void setPassword(QString);
    void setHostName(QString);

    int type() const { return (int)m_networkProxy.type(); }
    int port() const { return m_networkProxy.port(); }
    QString user() const { return m_networkProxy.user(); }
    QString password() const { return m_networkProxy.password(); }
    QString hostName() const { return m_networkProxy.hostName(); }

signals:
    void typeChanged(int);
    void portChanged(int);
    void userChanged(QString);
    void passwordChanged(QString);
    void hostNameChanged(QString);

private:
    QNetworkProxy::ProxyType IntToProxyType(int value);

    QNetworkProxy m_networkProxy;
};

#endif // PROXY_H
