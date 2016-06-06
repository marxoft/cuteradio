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

#include "accountdialog.h"
#include <QDialogButtonBox>
#include <QFormLayout>
#include <QLineEdit>
#include <QPushButton>

AccountDialog::AccountDialog(QWidget *parent) :
    QDialog(parent),
    m_usernameEdit(new QLineEdit(this)),
    m_passwordEdit(new QLineEdit(this)),
    m_buttonBox(new QDialogButtonBox(QDialogButtonBox::Ok | QDialogButtonBox::Cancel, Qt::Horizontal, this)),
    m_layout(new QFormLayout(this))
{
    setWindowTitle(tr("Login"));
    
    m_passwordEdit->setEchoMode(QLineEdit::Password);
    
    m_buttonBox->button(QDialogButtonBox::Ok)->setEnabled(false);
    
    m_layout->addRow(tr("&Username:"), m_usernameEdit);
    m_layout->addRow(tr("&Password:"), m_passwordEdit);
    m_layout->addRow(m_buttonBox);
    
    connect(m_usernameEdit, SIGNAL(textChanged(QString)), this, SLOT(onUsernameChanged(QString)));
    connect(m_passwordEdit, SIGNAL(textChanged(QString)), this, SLOT(onPasswordChanged(QString)));
    connect(m_buttonBox, SIGNAL(accepted()), this, SLOT(accept()));
    connect(m_buttonBox, SIGNAL(rejected()), this, SLOT(reject()));
}

QString AccountDialog::username() const {
    return m_usernameEdit->text();
}

void AccountDialog::setUsername(const QString &u) {
    m_usernameEdit->setText(u);
}

QString AccountDialog::password() const {
    return m_passwordEdit->text();
}

void AccountDialog::setPassword(const QString &p) {
    m_passwordEdit->setText(p);
}

void AccountDialog::onUsernameChanged(const QString &username) {
    m_buttonBox->button(QDialogButtonBox::Ok)->setEnabled((!username.isEmpty()) && (!password().isEmpty()));
}

void AccountDialog::onPasswordChanged(const QString &password) {
    m_buttonBox->button(QDialogButtonBox::Ok)->setEnabled((!password.isEmpty()) && (!username().isEmpty()));
}
