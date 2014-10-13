TARGET = shuffle

CONFIG += qtsparql \
          link_pkgconfig

CONFIG += sailfishapp
PKGCONFIG += libmediaart-1.0

SOURCES += src/shuffle.cpp \
    src/musiclibrary.cpp \
    src/coverart.cpp

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
    src/musiclibrary.h \
    src/coverart.h

