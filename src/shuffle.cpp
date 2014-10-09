#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include <QScopedPointer>
#include <QGuiApplication>
#include <QQuickView>

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());
    /*
                qmlRegisterType<ImageUploader>("harbour.tweetian.Uploader", 1, 0, "ImageUploader");
  */
    view->setSource(SailfishApp::pathTo("qml/shuffle.qml"));
    view->show();
    return app->exec();
}

