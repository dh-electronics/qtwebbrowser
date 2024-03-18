VERSION = 1.3.0

TEMPLATE = subdirs

isEmpty(INSTALL_PREFIX): INSTALL_PREFIX=/opt/qtwebbrowser

SUBDIRS = \
    src

CONFIG += lang-all

startscripts.files = waitForWebserver.py startwebbrowser.py
startscripts.path = $$INSTALL_PREFIX
INSTALLS += startscripts

requires(qtHaveModule(webenginequick))


