/*
Shuffle - a simple music player application
Copyright (C) 2014 Vesa-Matti Hartikainen <vesku.h@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include "musiclibrary.h"
#include <QString>
#include <QtSparql>
#include <QDebug>
#include <QUrl>
#include <QUrlQuery>
#include "coverart.h"

MusicLibrary::MusicLibrary(QObject *parent) :
    QObject(parent)
{
    CoverArt art;

    QString test;
    test = CoverArt::getCover(QString("The Beatles"), QString("07 WhileMyGuitarGentlyWeeps.MP3"), QString("file:///media/sdcard/9016-4EF8/iTunes%20Music/The%20Beatles/The%20Beatles/07%20WhileMyGuitarGentlyWeeps.MP3.MP3"));
    qDebug() << "Does it work " << test;

    connection = QSharedPointer<QSparqlConnection>(new QSparqlConnection("QTRACKER_DIRECT"));
    qsrand(QDateTime::currentMSecsSinceEpoch());
}

QString MusicLibrary::nextSong() const {
    return QString();
}

QString MusicLibrary::currentSong() {
    QSparqlQueryOptions execOptions;
    execOptions.setExecutionMethod(QSparqlQueryOptions::SyncExec);
    QSparqlQuery countQuery("SELECT count(?url) AS ?itemCount" \
                            "WHERE { ?song a nmm:MusicPiece . " \
                            "?song nie:url ?url . " \
                            "OPTIONAL { ?song nmm:performer ?aName . " \
                            "?song nmm:musicAlbum ?album . } " \
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

    QSparqlQuery urlQuery(QString("SELECT ?url ?aName ?album " \
                                  "WHERE { ?song a nmm:MusicPiece . " \
                                  "?song nie:url ?url . " \
                                  "OPTIONAL { ?song nmm:performer ?aName . " \
                                  "?song nmm:musicAlbum ?album . " \
                                  "} } " \
                                  "OFFSET %1" \
                                  " LIMIT 1").arg(index) );

    QScopedPointer<QSparqlResult> randomResult(connection->exec(urlQuery, execOptions));
    randomResult->next();
    QString url = randomResult->value(0).toString();
    QString artist = randomResult->value(1).toString();
    QString album = randomResult->value(2).toString();

    if (artist.startsWith("urn:artist:")) {
        artist = artist.split(QLatin1Literal("urn:artist:")).last();
    }

    if (album.startsWith("urn:album:")) {
        album = album.split(QLatin1Literal("urn:album:")).last();
    }

    m_cover = CoverArt::getCover(artist, album, url);
    emit coverChanged();
    qDebug() << "Artist: " << artist << " Album: " << album;
    qDebug() << "URL: " << url;
    qDebug() << "Art: "<< m_cover;
    return url;
}

QString MusicLibrary::cover() const {
    QFile f(m_cover);
    if (f.exists()) {
        return m_cover;
    } else {
        qDebug() << "Cover does not exist";
        return QString();
    }
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
