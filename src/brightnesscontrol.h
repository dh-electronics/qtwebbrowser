/****************************************************************************
**
** Copyright (C) 2018  DH Electroncis GmbH
** Contact: https://www.dh-electronics.com/
**
****************************************************************************/
#ifndef BRIGHTNESSCONTROL_H
#define BRIGHTNESSCONTROL_H

#include <QObject>
#include <QFile>

class BrightnessControl : public QObject
{
    Q_OBJECT
public:
    explicit BrightnessControl(QObject *parent = 0);
    Q_INVOKABLE bool setBrightness(int value);
    Q_INVOKABLE int getBrightness();

private:
    QFile brightnessFile;
    int maxBrightnessValue;
};

#endif // BRIGHTNESSCONTROL_H
