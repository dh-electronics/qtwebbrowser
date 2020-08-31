/****************************************************************************
**
** Copyright (C) 2018  DH Electroncis GmbH
** Contact: https://www.dh-electronics.com/
**
****************************************************************************/
#include "settings.h"
#include <QDebug>
#include <QDir>
#include <QGuiApplication>
#include <QJsonParseError>

Settings::Settings(const QString &fileName, QObject *parent) : QObject(parent),
    m_settingsFile(fileName, parent)
{
    //touch the file so that it always exists for the filsystemewatcher (otherwise the add path will fail)
    if(!QFile::exists(fileName))
    {
        QFile configFile(fileName);
        configFile.open(QIODevice::WriteOnly);
        configFile.close();
    }

    m_configFileWatcher.addPath(fileName);

    QObject::connect(&m_configFileWatcher, SIGNAL(fileChanged(const QString &)), this, SLOT(fileChanged(const QString &)));
}

bool Settings::loadSettings()
{
    bool result = false;

    if(m_settingsFile.open(QIODevice::ReadOnly | QIODevice::Text) == true)
    {
        QString val = m_settingsFile.readAll();
        m_settingsFile.close();

        QJsonParseError jsonError;
        QJsonDocument doc = QJsonDocument::fromJson(val.toUtf8(), &jsonError);
        if(jsonError.error == QJsonParseError::ParseError::NoError && !doc.isNull())
        {
            m_settingsMap = doc.object().toVariantMap();

            result = true;
        }
        else
        {
            result = false;
        }
    }

    return result;
}

bool Settings::saveSettings()
{
    bool result = false;

    if(m_settingsFile.open(QFile::WriteOnly) == true)
    {
        QByteArray settings = QJsonDocument::fromVariant(m_settingsMap).toJson();
        if(m_settingsFile.write(settings) == settings.size())
            result = true;

        m_settingsFile.close();
    }

    return result;
}

void Settings::fileChanged(const QString& str)
{
    //the settings file changed
    loadSettings();

    //the file has to be readded because the signal gets triggered only once
    m_configFileWatcher.addPath(str);

    emit fileChanged();
}

QString Settings::getValue(const QString &name, const QString &defaultValue)
{
    if(m_settingsMap.contains(name))
        return m_settingsMap.value(name).toString();
    else
        return defaultValue;
}

void Settings::setValue(const QString &name, const QVariant &value)
{
    m_settingsMap.insert(name, value.toString());
}

