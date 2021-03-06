# qtwebbrowser
Webbrowser used in DHMI Products

## Intro
This Webbrowser is based on the qtwebbrowser from qt Company.

The original source code came from https://code.qt.io/cgit/qt-apps/qtwebbrowser.git/

Some changes for the DHMI Touch Panel Computers from DH Electronics have been made:
  * Replaced the settings menue with an config file
  * added a screen saver
  * optimization for tslib
  * added a kioskmode
  * added possibility to enable remote debugging for websites
  * support for systemd watchdog

## Access Rights
For the screen saver functionality the Web Browser needs access to the file /sys/class/backlight/display/brightness.

## Runtime Dependencies
The qt WebBrowser only depends on the QT Framework Version.  
The Webbrowser was tested with a QT Version >= 5.9.1 .

## Development Dependencies
Besides the Qt Build Environment the project needs python3 with the module cogapp for some automatic codegeneration.

## Build Project
The project can be built with qmake for touch devices as it is.  
If you want to build the project for desktop system you have to remove the DEFINE TOUCH_MOCKING.

## Starting the Webbrowser
The following environment variables needs to be set on DHMI systems:

```console
QT_QPA_EGLFS_DISABLE_INPUT=1  
QT_QPA_EGLFS_TSLIB=1  
QT_QPA_GENERIC_PLUGINS = tslib  
TSLIB_CALIBFILE = /etc/pointercal  
TSLIB_CONFFILE = /etc/ts.conf  
TSLIB_FBDEVICE = /dev/fb0  
TSLIB_PLUGINDIR = /usr/lib/ts  
TSLIB_TSDEVICE = /dev/input/event0
```

The values for the Environment Variables may differ on other platforms.

The webbrowser can then be started from the application folder:
```console
./qtwebbrowser
```

