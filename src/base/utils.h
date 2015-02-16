/*
 * Copyright (C) 2014 Stuart Howarth <showarth@marxoft.co.uk>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms and conditions of the GNU Lesser General Public License,
 * version 3, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
 * more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef UTILS_H
#define UTILS_H

#include <QObject>

class QString;
class QUrl;
class QStringList;

class Utils : public QObject
{
    Q_OBJECT

public:
    explicit Utils(QObject *parent = 0);
    ~Utils();

    Q_INVOKABLE static QString durationFromSecs(int secs);
    Q_INVOKABLE static QString durationFromMSecs(int msecs);
    Q_INVOKABLE static QString fileSizeFromPath(const QString &filePath);
    Q_INVOKABLE static QString fileSizeFromBytes(double bytes);
    Q_INVOKABLE static QString httpErrorString(int errorCode);
    Q_INVOKABLE static bool urlIsPlaylist(const QUrl &url);
    Q_INVOKABLE static QString capitalise(const QString &string);
    Q_INVOKABLE static QString buildString(const QString &str, const QStringList &args);
    Q_INVOKABLE static void log(const QString &filePath, const QByteArray &message);
};

#endif
