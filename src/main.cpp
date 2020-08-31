/****************************************************************************
**
** Original work Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** Modified work Copyright (C) 2018  DH Electroncis GmbH
** Contact: https://www.dh-electronics.com/
**
** This file is part of the Qt WebBrowser application.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "appengine.h"
#include "navigationhistoryproxymodel.h"
#include "touchtracker.h"
#include "brightnesscontrol.h"
#include "toucheventspy.h"
#include "globalsettings.h"
#include "networkproxy.h"

#if defined(TOUCH_MOCKING)
#include "touchmockingapplication.h"
#endif

#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQuickView>
#include <QtWebEngine/qtwebengineglobal.h>
#include <QTimer>
#include <systemd/sd-daemon.h>

static QObject *engine_factory(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    AppEngine *eng = new AppEngine();
    return eng;
}

static QObject *settings_factory(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    GlobalSettings *settings = new GlobalSettings();

    return settings;
}

int main(int argc, char **argv)
{
    QTimer watchdogtimer;

    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    //do not use any plugins installed on the device
    qputenv("QML2_IMPORT_PATH", QByteArray());

    // We use touch mocking on desktop and apply all the mobile switches.
    QByteArrayList args = QByteArrayList()
            << QByteArrayLiteral("--enable-embedded-switches")
            << QByteArrayLiteral("--log-level=0");
    const int count = args.size() + argc;
    QVector<char*> qargv(count);

    qargv[0] = argv[0];
    for (int i = 0; i < args.size(); ++i)
        qargv[i + 1] = args[i].data();
    for (int i = args.size() + 1; i < count; ++i)
        qargv[i] = argv[i - args.size()];

    int qAppArgCount = qargv.size();

#if defined(TOUCH_MOCKING)
    TouchMockingApplication app(qAppArgCount, qargv.data());
#else
    QGuiApplication app(qAppArgCount, qargv.data());
#endif

    qmlRegisterType<NavigationHistoryProxyModel>("WebBrowser", 1, 0, "SearchProxyModel");
    qmlRegisterType<TouchTracker>("WebBrowser", 1, 0, "TouchTracker");
    qmlRegisterSingletonType<AppEngine>("WebBrowser", 1, 0, "AppEngine", engine_factory);
    qmlRegisterType<BrightnessControl>("Display", 1, 0, "BrightnessControl");
    qmlRegisterSingletonType<TouchEventSpy>("EventSpy", 1, 0, "TouchEventSpy", TouchEventSpy::singletonProvider);
    qmlRegisterSingletonType<GlobalSettings>("Settings", 1, 0, "GlobalSettings", settings_factory);
    qmlRegisterType<NetworkProxy>("NetworkProxy", 1, 0, "NetworkProxy");

    QtWebEngine::initialize();

    app.setOrganizationName("The Qt Company");
    app.setOrganizationDomain("qt.io");
    app.setApplicationName("qtwebbrowser");

    QQuickView view;
    view.setTitle("Qt WebBrowser");
    view.setFlags(Qt::Window | Qt::WindowTitleHint);
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setColor(Qt::black);
    view.setSource(QUrl("qrc:///qml/Main.qml"));

    QObject::connect(view.engine(), SIGNAL(quit()), &app, SLOT(quit()));

#if defined(TOUCH_MOCKING)
    view.show();
    if (view.size().isEmpty())
        view.setGeometry(0, 0, 800, 600);
#else
    view.showFullScreen();
#endif

    if (qgetenv("WATCHDOG_USEC") != "")
    {
        try
        {

            QObject::connect(&watchdogtimer, &QTimer::timeout, []() { sd_notify(0, "WATCHDOG=1"); });

            int timeout_ms = qgetenv("WATCHDOG_USEC").toInt()/1000;
            qInfo() << "Start watchdog timeout with " << timeout_ms << " ms";

            watchdogtimer.start(timeout_ms/2);

            qInfo() << "Trigger watchdog for the first time.";
            sd_notify(0, "WATCHDOG=1");
        }
        catch(...)
        {
            qInfo() << qgetenv("WATCHDOG_USEC") << " is no valid watchdog timeout value. Will not start the watchdog timer.";
        }

    }
    else
    {
        qInfo() << "No Watchdog defined";
    }



    app.exec();
}
