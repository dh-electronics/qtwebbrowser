/****************************************************************************
**
** Copyright (C) 2018  DH Electroncis GmbH
** Contact: https://www.dh-electronics.com/
**
****************************************************************************/
#include "networkproxy.h"
#include <QtNetwork/QNetworkProxy>

void NetworkProxy::setType(int value)
{
    if((int)(m_networkProxy.type())!=value)
    {
        m_networkProxy.setType( IntToProxyType(value) );
        emit typeChanged(value);

        QNetworkProxy::setApplicationProxy(m_networkProxy);
    }
}

void NetworkProxy::setPort(int value)
{
    if(m_networkProxy.port()!=value)
    {
        m_networkProxy.setPort( value );
        emit portChanged(value);

        QNetworkProxy::setApplicationProxy(m_networkProxy);
    }
}

void NetworkProxy::setUser(QString value)
{
    if(m_networkProxy.user()!=value)
    {
        m_networkProxy.setUser( value );
        emit userChanged(value);

        QNetworkProxy::setApplicationProxy(m_networkProxy);
    }
}

void NetworkProxy::setPassword(QString value)
{
    if(m_networkProxy.password()!=value)
    {
        m_networkProxy.setPassword( value );
        emit passwordChanged(value);

        QNetworkProxy::setApplicationProxy(m_networkProxy);
    }
}

void NetworkProxy::setHostName(QString value)
{
    if(m_networkProxy.hostName()!=value)
    {
        m_networkProxy.setHostName( value );
        emit hostNameChanged(value);

        QNetworkProxy::setApplicationProxy(m_networkProxy);
    }
}

QNetworkProxy::ProxyType NetworkProxy::IntToProxyType(int value)
{
    switch (value) {
    case 0:
        return QNetworkProxy::ProxyType::DefaultProxy;
        break;
    case 1:
        return QNetworkProxy::ProxyType::Socks5Proxy;
        break;
    case 2:
        return QNetworkProxy::ProxyType::NoProxy;
        break;
    case 3:
        return QNetworkProxy::ProxyType::HttpProxy;
        break;
    case 4:
        return QNetworkProxy::ProxyType::HttpCachingProxy;
        break;
    case 5:
        return QNetworkProxy::ProxyType::FtpCachingProxy;
        break;
    default:
        return QNetworkProxy::ProxyType::DefaultProxy;
        break;
    }
}
