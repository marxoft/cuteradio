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

#ifndef HOMESCREENMODEL_H
#define HOMESCREENMODEL_H

#include <QStringListModel>
#if QT_VERSION >= 0x050000
#include <qqml.h>
#else
#include <qdeclarative.h>
#endif

class HomescreenModel : public QStringListModel
{
    Q_OBJECT

public:
    explicit HomescreenModel(QObject *parent = 0);
    ~HomescreenModel();

#if QT_VERSION >= 0x050000
    QHash<int, QByteArray> roleNames() const;
#endif

private:
    QHash<int, QByteArray> m_roleNames;
};

QML_DECLARE_TYPE(HomescreenModel)

#endif // HOMESCREENMODEL_H
