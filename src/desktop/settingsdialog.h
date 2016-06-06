/*
 * Copyright (C) 2016 Stuart Howarth <showarth@marxoft.co.uk>
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

#ifndef SETTINGSDIALOG_H
#define SETTINGSDIALOG_H

#include <QDialog>

class QCheckBox;
class QDialogButtonBox;
class QFormLayout;
class QSpinBox;

class SettingsDialog : public QDialog
{
    Q_OBJECT

public:
    explicit SettingsDialog(QWidget *parent = 0);

public Q_SLOTS:
    virtual void accept();

private:
    QCheckBox *m_playCheckBox;
    
    QSpinBox *m_timerSpinBox;
    
    QDialogButtonBox *m_buttonBox;
    
    QFormLayout *m_layout;
};

#endif // SETTINGSDIALOG_H
