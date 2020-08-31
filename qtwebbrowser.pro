VERSION = 1.0.0

TEMPLATE = subdirs

SUBDIRS = \
    src

CONFIG += lang-all

requires(qtHaveModule(webengine))


