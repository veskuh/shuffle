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

#ifndef MUSICLIBRARY_H
#define MUSICLIBRARY_H

#include <QObject>
#include <QSharedPointer>
#include <QtSparql>

class MusicLibrary : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString currentSong READ currentSong NOTIFY currentSongChanged)
    Q_PROPERTY(QString cover READ cover NOTIFY coverChanged)
    Q_PROPERTY(QString title READ title NOTIFY titleChanged)

public:
    explicit MusicLibrary(QObject *parent = 0);
    Q_INVOKABLE void skip();
    Q_INVOKABLE void next();
    Q_INVOKABLE QString pretifyUrl(QUrl url);

    QString currentSong();
    QString cover();
    QString title();

signals:
    void currentSongChanged();
    void coverChanged();
    void titleChanged();


public slots:

private:
    QSharedPointer<QSparqlConnection> connection;
    QString m_cover;
    QString m_url;
    QString m_title;
    QString m_artist;
    QString m_album;
    int m_count;
    QSparqlQueryOptions m_execOptions;

};

#endif // MUSICLIBRARY_H
