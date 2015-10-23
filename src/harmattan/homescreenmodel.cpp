/*
 * Copyright (C) 2015 Stuart Howarth <showarth@marxoft.co.uk>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "homescreenmodel.h"
#include "settings.h"

HomescreenModel::HomescreenModel(QObject *parent) :
    QStringListModel(parent)
{
    m_roles[Qt::DisplayRole] = "name";
#if QT_VERSION < 0x050000
    setRoleNames(m_roles);
#endif
    reload();
    connect(Settings::instance(), SIGNAL(tokenChanged()), this, SLOT(reload()));
}

#if QT_VERSION >= 0x050000
QHash<int, QByteArray> HomescreenModel::roleNames() const {
    return m_roles;
}
#endif

void HomescreenModel::reload() {
    if (Settings::instance()->token().isEmpty()) {
        setStringList(QStringList() << tr("All stations") << tr("Stations by genre") << tr("Stations by country")
                                    << tr("Stations by language"));
    }
    else {
        setStringList(QStringList() << tr("All stations") << tr("Stations by genre") << tr("Stations by country")
                                    << tr("Stations by language") << tr("Recently played stations")
                                    << tr("Favourite stations") << tr("My stations"));
    }
}
