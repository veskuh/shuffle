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

#include "coverart.h"
#include <libmediaart/mediaart.h>
#include <glib-object.h>
#include <QDebug>

CoverArt::CoverArt()
{
}

QString CoverArt::getCover(const QString& artist,
                           const QString& album,
                           const QString& path)
{
    gchar* artPath = NULL;
    gchar* localUri = NULL;
    media_art_get_path (artist.toUtf8().constData(),
                        album.toUtf8().constData(),
                        "album",
                        path.toUtf8().constData(),
                        &artPath,
                        &localUri);
    return QString(artPath);
}


