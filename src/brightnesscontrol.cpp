/****************************************************************************
**
** Copyright (C) 2018  DH Electroncis GmbH
** Contact: https://www.dh-electronics.com/
**
****************************************************************************/
#include "brightnesscontrol.h"
const QString path = "/sys/class/backlight/display-bl/";

BrightnessControl::BrightnessControl( QObject *parent) : QObject(parent)
{
    brightnessFile.setFileName(path + "/brightness");

    QFile maxBrightnessFile(path + "/max_brightness");
    if(maxBrightnessFile.open(QIODevice::ReadOnly))
    {
        QString value = maxBrightnessFile.readLine();
        if(value.endsWith("\n"))
            value = value.remove(value.length(),1);

        maxBrightnessValue = value.toInt();
        maxBrightnessFile.close();
    }
    else
    {
        maxBrightnessValue = 1;
    }

}

bool BrightnessControl::setBrightness(int value)
{
    bool result = true;

    if(brightnessFile.exists() && brightnessFile.open(QIODevice::WriteOnly))
    {
        if(value <= maxBrightnessValue)
        {
            QString brightness = QString::number(value);
            brightness += "\n";

            if(brightnessFile.write(brightness.toLocal8Bit()) == QString::number(value).length())
            {
                qWarning("Unable to set brightness!");
                result = false;
            }
            else
            {
            }
        }
        else
        {
            qWarning("Brightness level is out or range!");
            result = false;
        }
    }
    else
    {
        qWarning("Unable to open brightness file!");
        result = false;
    }

    brightnessFile.close();

    return result;
}

int BrightnessControl::getBrightness()
{
    if(brightnessFile.exists() && brightnessFile.open(QIODevice::ReadOnly))
    {
        QString brightness = brightnessFile.readLine();
        brightnessFile.close();

        return brightness.toInt();

    }
    else
    {
        qWarning("Unable to open brightness file!");
        return 0;
    }

}
