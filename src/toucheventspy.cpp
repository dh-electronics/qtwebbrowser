/****************************************************************************
**
** Copyright (C) 2018  DH Electroncis GmbH
** Contact: https://www.dh-electronics.com/
**
****************************************************************************/
#include "toucheventspy.h"
#include <QGuiApplication>

TouchEventSpy::TouchEventSpy(QObject *parent) : QObject(parent)
{

}

// singleton type provider function (callback)
QObject* TouchEventSpy::singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    TouchEventSpy *spy = new TouchEventSpy();
    qGuiApp->installEventFilter(spy);

    return spy;
}

// filter for Touch Events
bool TouchEventSpy::eventFilter(QObject* receiver, QEvent* ev)
{
    if(ev->type() == QEvent::TouchUpdate)
        emit touchEventDetected();

    return QObject::eventFilter(receiver, ev);
}
