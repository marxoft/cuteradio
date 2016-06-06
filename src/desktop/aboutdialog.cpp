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

#include "aboutdialog.h"
#include "definitions.h"
#include <QDialogButtonBox>
#include <QLabel>
#include <QVBoxLayout>

AboutDialog::AboutDialog(QWidget *parent) :
    QDialog(parent),
    m_buttonBox(new QDialogButtonBox(QDialogButtonBox::Close, Qt::Horizontal, this)),
    m_iconLabel(new QLabel(this)),
    m_textLabel(new QLabel(this)),
    m_layout(new QVBoxLayout(this))
{
    setWindowTitle(tr("About"));
    setMinimumSize(QSize(400, 300));

    m_iconLabel->setPixmap(QPixmap("/usr/share/icons/hicolor/48x48/apps/cuteradio.png"));
    m_iconLabel->setAlignment(Qt::AlignCenter);
    
    m_textLabel->setText(QString("<p style='font-size: 16pt; font-weight: bold;'>cuteRadio</p><p>Version: %1</p><p>An internet radio browser and player.</p><p>&copy; Stuart Howarth 2016</p><p><a href='http://marxoft.co.uk/projects/cuteradio'>marxoft.co.uk</a></p>").arg(VERSION_NUMBER));
    m_textLabel->setTextFormat(Qt::RichText);
    m_textLabel->setAlignment(Qt::AlignCenter);
    m_textLabel->setWordWrap(true);
    m_textLabel->setOpenExternalLinks(true);

    m_layout->addWidget(m_iconLabel);
    m_layout->addWidget(m_textLabel);
    m_layout->addWidget(m_buttonBox);

    connect(m_buttonBox, SIGNAL(rejected()), this, SLOT(reject()));
}
