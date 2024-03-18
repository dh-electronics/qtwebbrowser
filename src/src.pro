TARGET = qtwebbrowser

CONFIG += c++11
CONFIG -= app_bundle

SOURCES = \
    appengine.cpp \
    main.cpp \
    navigationhistoryproxymodel.cpp \
    touchtracker.cpp \
    brightnesscontrol.cpp \
    toucheventspy.cpp \
    settings.cpp \
    globalsettings.cpp \
    networkproxy.cpp

HEADERS = \
    appengine.h \
    navigationhistoryproxymodel.h \
    touchtracker.h \
    brightnesscontrol.h \
    toucheventspy.h \
    settings.h \
    globalsettings.h \
    networkproxy.h

OTHER_FILES = \
    qml/assets/UIButton.qml \
    qml/assets/UIToolBar.qml \
    qml/ApplicationRoot.qml \
    qml/BrowserWindow.qml \
    qml/FeaturePermissionBar.qml \
    qml/MockTouchPoint.qml \
    qml/PageView.qml \
    qml/NavigationBar.qml \
    qml/HomeScreen.qml \
    qml/SettingsView.qml \
    qml/Keyboard.qml \
    qml/Window.qml \
    qml/ScreenSaver.qml \
    qml/LabeledSpinbox.qml \
    qml/LabeledSwitch.qml \
    qml/Main.qml

QT += qml quick webenginequick webenginewidgets

RESOURCES += resources.qrc
DEFINES += TOUCH_MOCKING
SOURCES += touchmockingapplication.cpp
HEADERS += touchmockingapplication.h
QT += gui-private
LIBS += -lsystemd
# Path for Qt for Device Creation
isEmpty(INSTALL_PREFIX): INSTALL_PREFIX=/opt/qtwebbrowser

target.path = $$INSTALL_PREFIX
INSTALLS += target


##Generates the settings source file every build

# must use a variable as input
PHONY_DEPS = .
PreBuildEvent.input = PHONY_DEPS
# use non-existing file here to execute every time
PreBuildEvent.output = phony.txt
# the system call to the batch file
PreBuildEvent.commands = bash $$_PRO_FILE_PWD_/generateSourceCode.sh $$_PRO_FILE_PWD_
# some name that displays during execution
PreBuildEvent.name = running Pre-Build steps...
# "no_link" tells qmake we don’t need to add the output to the object files for linking, and "no_clean" means there is no clean step for them.
# "target_predeps" tells qmake that the output of this needs to exist before we can do the rest of our compilation.
PreBuildEvent.CONFIG += no_link no_clean target_predeps
# Add the compiler to the list of 'extra compilers'.
QMAKE_EXTRA_COMPILERS += PreBuildEvent

