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

#ifndef ACCOUNTDIALOG_H
#define ACCOUNTDIALOG_H

#include <QDialog>

class QDialogButtonBox;
class QFormLayout;
class QLineEdit;

class AccountDialog : public QDialog
{
    Q_OBJECT
    
    Q_PROPERTY(QString username READ username WRITE setUsername)
    Q_PROPERTY(QString password READ password WRITE setPassword)

public:
    explicit AccountDialog(QWidget *parent = 0);
    
    QString username() const;
    
    QString password() const;

public Q_SLOTS:
    void setUsername(const QString &u);
    
    void setPassword(const QString &p);

private Q_SLOTS:
    void onUsernameChanged(const QString &username);
    void onPasswordChanged(const QString &password);

private:
    QLineEdit *m_usernameEdit;
    QLineEdit *m_passwordEdit;
    
    QDialogButtonBox *m_buttonBox;
    
    QFormLayout *m_layout;
};

#endif // ACCOUNTDIALOG_H
