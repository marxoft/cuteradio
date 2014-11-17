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

#include "homescreenmodel.h"

HomescreenModel::HomescreenModel(QObject *parent) :
    QStringListModel(QStringList()
                     << tr("All stations")
                     << tr("Stations by genre")
                     << tr("Stations by country")
                     << tr("Stations by language")
                     << tr("Recently played stations")
                     << tr("Favourite stations")
                     << tr("My stations"),
                     parent)
{
    m_roleNames[Qt::DisplayRole] = "name";
#if QT_VERSION < 0x050000
    this->setRoleNames(m_roleNames);
#endif
}

HomescreenModel::~HomescreenModel() {}

#if QT_VERSION >= 0x050000
QHash<int, QByteArray> HomescreenModel::roleNames() const {
    return m_roleNames;
}
#endif
