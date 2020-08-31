/****************************************************************************
**
** Copyright (C) 2018  DH Electroncis GmbH
** Contact: https://www.dh-electronics.com/
**
****************************************************************************/
#ifndef SETTINGS_H
#define SETTINGS_H
#include <QObject>
#include <QVariantMap>
#include <QFileSystemWatcher>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>

class Settings : public QObject
{
    Q_OBJECT

public:
    explicit Settings(const QString &fileName, QObject *parent = nullptr);

    Q_INVOKABLE QString getValue(const QString &name, const QString &defaultValue);
    Q_INVOKABLE void setValue(const QString &name, const QVariant &value);

    Q_INVOKABLE bool saveSettings();
    Q_INVOKABLE bool loadSettings();

private:
    QFileSystemWatcher m_configFileWatcher;
    QFile m_settingsFile;
    QVariantMap m_settingsMap;

private slots:
    void fileChanged(const QString& str);

signals:
    void fileChanged();
};

#endif // SETTINGS_H
