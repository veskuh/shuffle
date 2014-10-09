#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include <QScopedPointer>
#include <QGuiApplication>
#include <QQuickView>
#include <QtQml>
#include "musiclibrary.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());

    qmlRegisterType<MusicLibrary>("harbour.shuffle.MusicLibrary", 1, 0, "MusicLibrary");

    view->setSource(SailfishApp::pathTo("qml/shuffle.qml"));
    view->show();
    return app->exec();
}

