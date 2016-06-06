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

#include "settingsdialog.h"
#include <QCheckBox>
#include <QDialogButtonBox>
#include <QFormLayout>
#include <QSettings>
#include <QSpinBox>

SettingsDialog::SettingsDialog(QWidget *parent) :
    QDialog(parent),
    m_playCheckBox(new QCheckBox(tr("Send &played stations data"), this)),
    m_timerSpinBox(new QSpinBox(this)),
    m_buttonBox(new QDialogButtonBox(QDialogButtonBox::Save | QDialogButtonBox::Cancel, Qt::Horizontal, this)),
    m_layout(new QFormLayout(this))
{
    setWindowTitle(tr("Preferences"));
    
    QSettings settings;
    
    if (settings.value("Account/accessToken").toString().isEmpty()) {
        m_playCheckBox->setEnabled(false);
    }
    else {
        m_playCheckBox->setChecked(settings.value("sendPlayedStationsData", false).toBool());
    }
    
    m_timerSpinBox->setMinimum(1);
    m_timerSpinBox->setMaximum(10000);
    m_timerSpinBox->setValue(settings.value("sleepTimerDuration", 30).toInt());
    
    m_layout->addRow(m_playCheckBox);
    m_layout->addRow(tr("Sleep &timer duration (minutes):"), m_timerSpinBox);
    m_layout->addRow(m_buttonBox);
    
    connect(m_buttonBox, SIGNAL(accepted()), this, SLOT(accept()));
    connect(m_buttonBox, SIGNAL(rejected()), this, SLOT(reject()));
}

void SettingsDialog::accept() {
    QSettings settings;
    
    if (m_playCheckBox->isEnabled()) {
        settings.setValue("sendPlayedStationsData", m_playCheckBox->isChecked());
    }
    
    settings.setValue("sleepTimerDuration", m_timerSpinBox->value());
    QDialog::accept();
}
