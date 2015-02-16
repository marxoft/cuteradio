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

#ifndef SELECTIONMODELS_H
#define SELECTIONMODELS_H

#include <QStandardItemModel>
#include <qplatformdefs.h>
#if QT_VERSION >= 0x050000
#include <qqml.h>
#else
#include <qdeclarative.h>
#endif

class SelectionModel : public QStandardItemModel
{
    Q_OBJECT

public:
    explicit SelectionModel(QObject *parent = 0);
    ~SelectionModel();

#if QT_VERSION >= 0x050000
    QHash<int, QByteArray> roleNames() const;
#endif

    void addItem(const QString &name, const QVariant &value);

    Q_INVOKABLE QString name(int row) const;
    Q_INVOKABLE QVariant value(int row) const;
    Q_INVOKABLE QVariantMap get(int row) const;
    Q_INVOKABLE int match(const QString &role, const QVariant &value) const;

    Q_INVOKABLE inline Qt::Alignment textAlignment() const { return m_textAlignment; }
    Q_INVOKABLE inline void setTextAlignment(Qt::Alignment alignment) { m_textAlignment = alignment; }

private:
    Qt::Alignment m_textAlignment;
    QHash<int, QByteArray> m_roleNames;
};

class ScreenOrientationModel : public SelectionModel
{
    Q_OBJECT

    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)

public:
    explicit ScreenOrientationModel(QObject *parent = 0);

signals:
    void countChanged();
};

class LanguageModel : public SelectionModel
{
    Q_OBJECT

    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)

public:
    explicit LanguageModel(QObject *parent = 0);

signals:
    void countChanged();
};

#ifdef MEEGO_EDITION_HARMATTAN
class ActiveColorModel : public SelectionModel
{
    Q_OBJECT

    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)

public:
    explicit ActiveColorModel(QObject *parent = 0);

signals:
    void countChanged();
};

QML_DECLARE_TYPE(ActiveColorModel)
#endif

QML_DECLARE_TYPE(SelectionModel)
QML_DECLARE_TYPE(ScreenOrientationModel)

#endif // SELECTIONMODELS_H
