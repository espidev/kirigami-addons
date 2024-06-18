// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQml
import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.statefulapp.private as Private
import org.kde.kirigamiaddons.statefulapp as StatefulApp

/**
 * A Kirigami.Action defined by a QAction.
 *
 * This requires setting both the actionName defined in your AbstractKirigamiApplication
 * implementation and your AbstractKirigamiApplication.
 *
 * @code{qml}
 * import org.kde.kirigamiaddons.statefulapp as StatefulApp
 *
 * StatefulApp.StatefulWindow {
 *     application: MyKoolApp
 *
 *     ManagedApp.Action {
 *         actionName: 'add_notebook'
 *         application: MyKoolApp
 *     }
 * }
 * @endcode{}
 */
Kirigami.Action {
    id: root

    required property string actionName
    required property StatefulApp.AbstractKirigamiApplication application
    readonly property QtObject _action: application.action(actionName)

    shortcut: _action.shortcut
    text: _action.text
    icon.name: Private.Helper.iconName(_action.icon)
    onTriggered: _action.trigger()
    visible: _action.text.length > 0
    checkable: _action.checkable
    checked: _action.checked

    readonly property Shortcut alternateShortcut : Shortcut {
        sequences: Private.Helper.alternateShortcuts(_action)
        onActivated: root.trigger()
    }
}
