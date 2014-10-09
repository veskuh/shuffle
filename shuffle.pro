# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = shuffle

CONFIG += sailfishapp \
           qtsparql

SOURCES += src/shuffle.cpp \
    src/musiclibrary.cpp

OTHER_FILES += qml/shuffle.qml \
    qml/cover/CoverPage.qml \
    qml/pages/*.qml \
    rpm/shuffle.changes.in \
    rpm/shuffle.spec \
    rpm/shuffle.yaml \
    translations/*.ts \
    shuffle.desktop

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/shuffle-de.ts

HEADERS += \
    src/musiclibrary.h

