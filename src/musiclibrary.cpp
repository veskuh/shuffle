#include "musiclibrary.h"
#include <QString>
#include <QtSparql>
#include <QDebug>
#include <QUrl>
#include <QUrlQuery>

MusicLibrary::MusicLibrary(QObject *parent) :
    QObject(parent)
{
    connection = QSharedPointer<QSparqlConnection>(new QSparqlConnection("QTRACKER_DIRECT"));
    qsrand(QDateTime::currentMSecsSinceEpoch());
}

QString MusicLibrary::nextSong() const {
    return QString();
}

QString MusicLibrary::currentSong() const {
    QSparqlQueryOptions execOptions;
    execOptions.setExecutionMethod(QSparqlQueryOptions::SyncExec);
    QSparqlQuery countQuery("SELECT count(?url) AS ?itemCount" \
                            "WHERE { ?song a nmm:MusicPiece . " \
                            "?song nie:url ?url . " \
                            "}");

    QScopedPointer<QSparqlResult> result(connection->exec(countQuery, execOptions));
    result->next();
    int count = result->value(0).toInt();
    qDebug() << "Result count: " << count;
    if (count < 1) {
        qDebug() << "No songs found";
        // No songs
        return QString();
    }
    int index = qrand() % count;

    QSparqlQuery urlQuery(QString("SELECT ?url " \
                                  "WHERE { ?song a nmm:MusicPiece . " \
                                  "?song nie:url ?url . " \
                                  "} " \
                                  "OFFSET %1" \
                                  " LIMIT 1").arg(index) );

    QScopedPointer<QSparqlResult> randomResult(connection->exec(urlQuery, execOptions));
    randomResult->next();
    return randomResult->value(0).toString();
}


void MusicLibrary::skip() {
    emit currentSongChanged();
    emit nextSongChanged();
}

void MusicLibrary::next() {
    emit currentSongChanged();
    emit nextSongChanged();
}


QString MusicLibrary::pretifyUrl(QUrl url) {
    QFileInfo info(url.toString(QUrl::FormattingOptions(QUrl::PreferLocalFile)));
    return info.baseName();

}
