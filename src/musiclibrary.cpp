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
    connection = QSharedPointer<QSparqlConnection>(new QSparqlConnection("QTRACKER_DIRECT"));
    qsrand(QDateTime::currentMSecsSinceEpoch());
    m_count = 0;
    m_execOptions.setExecutionMethod(QSparqlQueryOptions::SyncExec);
}

QString MusicLibrary::currentSong() {
   return m_url;
}

QString MusicLibrary::cover() {
    m_cover = CoverArt::getCover(m_artist, m_album, m_url);
/*    qDebug() << "Artist: " << m_artist << " Album: " << m_album;
    qDebug() << "URL: " << m_url;
    qDebug() << "Art: "<< m_cover; */

    QFile f(m_cover);
    if (!f.exists()) {
        // qDebug() << "Cover does not exist";
        m_cover.clear();
    }
    return m_cover;
}

void MusicLibrary::skip() {
    emit currentSongChanged();
}

void MusicLibrary::next() {
    int count;
    if (m_count == 0) {
        QSparqlQuery countQuery("SELECT count(?url) AS ?itemCount" \
                                "WHERE { ?song a nmm:MusicPiece . " \
                                "?song nie:url ?url . " \
                                "OPTIONAL { ?song nmm:performer ?aName . " \
                                "?song nmm:musicAlbum ?album . } " \
                                "}");

        QScopedPointer<QSparqlResult> result(connection->exec(countQuery, m_execOptions));
        result->next();
        count = result->value(0).toInt();
        // qDebug() << "Result count: " << count;
    } else {
        count = m_count;
        // Let's check next time if count has changed (may happen when tracker has indexed..)
        m_count = 0;
    }

    if (count < 1) {
        qDebug() << "No songs found";
        // No songs
        return;
    }
    int index = qrand() % count;

    QSparqlQuery urlQuery(QString("SELECT ?url ?aName ?album ?title " \
                                  "WHERE { ?song a nmm:MusicPiece . " \
                                  "?song nie:url ?url . " \
                                  "OPTIONAL { ?song nmm:performer ?aName . " \
                                  "?song nmm:musicAlbum ?album . " \
                                  "?song nie:title ?title . } } " \
                                  "OFFSET %1" \
                                  " LIMIT 1").arg(index) );

    QScopedPointer<QSparqlResult> randomResult(connection->exec(urlQuery, m_execOptions));
    randomResult->next();
    m_url = randomResult->value(0).toString();
    m_artist = randomResult->value(1).toString();
    m_album = randomResult->value(2).toString();
    m_title = randomResult->value(3).toString();
    if (m_title.isEmpty()) {
        m_title = pretifyUrl(QUrl(m_url));
    }

    if (m_artist.startsWith("urn:artist:")) {
        m_artist = m_artist.split(QLatin1Literal("urn:artist:")).last();
    }

    if (m_album.startsWith("urn:album:")) {
        m_album = m_album.split(QLatin1Literal("urn:album:")).last();
    }

    emit currentSongChanged();
    emit coverChanged();
    emit titleChanged();
}


QString MusicLibrary::title() {
    return m_title;
}

QString MusicLibrary::pretifyUrl(QUrl url) {
    qDebug() << "Prettify" << url;
    QFileInfo info(url.toString(QUrl::FormattingOptions(QUrl::PreferLocalFile)));
    return info.baseName();

}
