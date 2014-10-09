#ifndef MUSICLIBRARY_H
#define MUSICLIBRARY_H

#include <QObject>
#include <QSharedPointer>
#include <QtSparql>

class MusicLibrary : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString nextSong READ nextSong NOTIFY nextSongChanged)
    Q_PROPERTY(QString currentSong READ currentSong NOTIFY currentSongChanged)

public:
    explicit MusicLibrary(QObject *parent = 0);
    Q_INVOKABLE void skip();
    Q_INVOKABLE void next();
    Q_INVOKABLE QString pretifyUrl(QUrl url);

    QString nextSong() const;
    QString currentSong() const;


signals:
    void nextSongChanged();
    void currentSongChanged();

public slots:

private:
    QSharedPointer<QSparqlConnection> connection;

};

#endif // MUSICLIBRARY_H
