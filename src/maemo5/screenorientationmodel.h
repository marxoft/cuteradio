/*
 * Copyright (C) 2015 Stuart Howarth <showarth@marxoft.co.uk>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef SCREENORIENTATIONMODEL_H
#define SCREENORIENTATIONMODEL_H

#include "selectionmodel.h"

class ScreenOrientationModel : public SelectionModel
{
    Q_OBJECT

public:
    explicit ScreenOrientationModel(QObject *parent = 0) :
        SelectionModel(parent)
    {
        append(tr("Automatic"), Qt::WA_Maemo5AutoOrientation);
        append(tr("Portrait"), Qt::WA_Maemo5PortraitOrientation);
        append(tr("Landscape"), Qt::WA_Maemo5LandscapeOrientation);
    }
};

#endif // SCREENORIENTATIONMODEL_H
