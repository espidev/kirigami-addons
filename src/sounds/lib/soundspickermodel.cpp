// SPDX-FileCopyrightText: 2021 Han Young <hanyoung@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-or-later
#include "soundspickermodel.h"
#include <vector>
#include <QDirIterator>
#include <QStandardPaths>
class SoundsPickerModel::Private
{
public:
    QStringList defaultAudio;
    std::vector<QString> soundsVec;
    bool notification = false;
    QString theme = QStringLiteral("plasma-mobile");
};
SoundsPickerModel::SoundsPickerModel(QObject *parent)
    : QAbstractListModel(parent)
    , d(std::make_unique<Private>())
{
    loadFiles();
}
void SoundsPickerModel::loadFiles()
{
    d->soundsVec.clear();
    auto locations = QStandardPaths::standardLocations(QStandardPaths::GenericDataLocation);
    QString path = QStringLiteral("/sounds/") + d->theme + QStringLiteral("/stereo/");

    bool found = false; // could use goto, but use flag for readability
    for (const auto &directory : locations) {
        if (QDir(directory + path).exists()) {
            path = directory + path;
            found = true;
            break;
        }
    }

    if (!found)
        return;

    if (!d->notification && QDir(path + QStringLiteral("ringtone")).exists())
        path += QStringLiteral("ringtone");
    else if (d->notification && QDir(path + QStringLiteral("notification")).exists())
        path += QStringLiteral("notificatoin");

    QDirIterator it(path, QDir::Files, QDirIterator::Subdirectories);
    while (it.hasNext()) {
        d->soundsVec.push_back(it.next());
    }
}
SoundsPickerModel::~SoundsPickerModel() = default;
QHash<int, QByteArray> SoundsPickerModel::roleNames() const
{
    return {
        {Roles::NameRole, QByteArrayLiteral("ringtoneName")},
        {Roles::UrlRole, QByteArrayLiteral("sourceUrl")}};
}
bool SoundsPickerModel::notification() const
{
    return d->notification;
}
void SoundsPickerModel::setNotification(bool notification)
{
    if (d->notification != notification)
        d->notification = notification;
    else
        return;

    bool needReset = false;
    QString path = QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation) + QStringLiteral("/") + d->theme + QStringLiteral("/stereo/");
    if (!d->notification && QDir(path + QStringLiteral("ringtone")).exists())
        needReset = true;
    else if (d->notification && QDir(path + QStringLiteral("notification")).exists())
        needReset = true;

    if (needReset) {
        beginResetModel();
        loadFiles();
        endResetModel();
        rearrangeRingtoneOrder();
    }
}
QString SoundsPickerModel::initialSourceUrl(int index)
{
    if (index >= 0 && index < (int)d->soundsVec.size())
        return d->soundsVec.at(index);
    else
        return {};
}
QVariant SoundsPickerModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= (int)d->soundsVec.size()) {
        return {};
    }

    if (role == NameRole) {
        auto ret = d->soundsVec.at(index.row());
        int suffixPos = ret.lastIndexOf(QLatin1Char('.'));
        if (suffixPos > 0)
            ret.truncate(suffixPos);
        int pathPos =  ret.lastIndexOf(QLatin1Char('/'));
        if (pathPos >= 0)
            ret.remove(0, pathPos + 1);
        return ret;
    } else {
        return d->soundsVec.at(index.row());
    }
}
int SoundsPickerModel::rowCount(const QModelIndex& parent) const {
    Q_UNUSED(parent)
    return d->soundsVec.size();
}

const QStringList &SoundsPickerModel::defaultAudio() const
{
    return d->defaultAudio;
}

void SoundsPickerModel::setDefaultAudio(const QStringList &audio)
{
    d->defaultAudio = audio;
    rearrangeRingtoneOrder();
}

const QString &SoundsPickerModel::theme() const
{
    return d->theme;
}

void SoundsPickerModel::setTheme(const QString &theme)
{
    if (d->theme != theme)
        d->theme = theme;
    else
        return;

    beginResetModel();
    loadFiles();
    endResetModel();
    rearrangeRingtoneOrder();
}
void SoundsPickerModel::rearrangeRingtoneOrder()
{
    auto i {0};
    for (int j = 0; j < (int)d->soundsVec.size(); j++) {
        if (d->defaultAudio.contains(data(index(j), NameRole).toString())) {
            std::swap(d->soundsVec[j], d->soundsVec[i]);
            Q_EMIT dataChanged(index(j), index(j));
            Q_EMIT dataChanged(index(i), index(i));
            i++;
        }
    }
}
