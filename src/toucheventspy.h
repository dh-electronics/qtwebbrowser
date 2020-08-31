/****************************************************************************
**
** Copyright (C) 2018  DH Electroncis GmbH
** Contact: https://www.dh-electronics.com/
**
****************************************************************************/
#ifndef TOUCHEVENTSPY_H
#define TOUCHEVENTSPY_H

#include <QObject>
#include <QtQml>
#include <QQmlEngine>
#include <QJSEngine>

class TouchEventSpy : public QObject
{
    Q_OBJECT
public:
    explicit TouchEventSpy(QObject* parent = nullptr);

    static QObject* singletonProvider(QQmlEngine* engine, QJSEngine* script);

protected:
    bool eventFilter(QObject* receiver, QEvent* ev);


signals:
    void touchEventDetected();
};

#endif // TOUCHEVENTSPY_H
