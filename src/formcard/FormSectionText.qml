/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

/**
 * @brief A standard delegate label.
 *
 * This is a simple label containing secondary text that was modified to fit
 * the role of Form delegate.
 *
 * If you need a primary text label with optional secondary text, use
 * FormTextDelegate instead.
 *
 * @since KirigamiAddons 0.11.0
 *
 * @see FormTextDelegate
 *
 * @inherit QtQuick.Controls.Label
 */
Label {
    color: Kirigami.Theme.disabledTextColor
    wrapMode: Label.Wrap

    Layout.maximumWidth: Kirigami.Units.gridUnit * 30
    Layout.alignment: Qt.AlignHCenter
    Layout.leftMargin: Kirigami.Units.gridUnit
    Layout.rightMargin: Kirigami.Units.gridUnit
    Layout.bottomMargin: Kirigami.Units.largeSpacing
    Layout.topMargin: Kirigami.Units.largeSpacing
    Layout.fillWidth: true
}
