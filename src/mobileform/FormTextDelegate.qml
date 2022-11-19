/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami

/**
 * Form delegate that corresponds to a text label.
 */
AbstractFormDelegate {
    id: root

    /**
     * Label that appears under the text, providing the value of the label.
     */
    property string description: ""

    /**
     * This property holds the interal description item.
     */
    property alias descriptionItem: internalDescriptionItem

    signal linkActivated(link: string)

    Layout.fillWidth: true

    background: Item {}

    contentItem: RowLayout {
        Kirigami.Icon {
            visible: root.icon.name !== ""
            source: root.icon.name
            Layout.rightMargin: (root.icon.name !== "") ? Kirigami.Units.largeSpacing : 0
            implicitWidth: (root.icon.name !== "") ? Kirigami.Units.iconSizes.small : 0
            implicitHeight: (root.icon.name !== "") ? Kirigami.Units.iconSizes.small : 0
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            Label {
                Layout.fillWidth: true
                text: root.text
                elide: Text.ElideRight
                onLinkActivated: root.linkActivated(link)
            }

            Label {
                id: internalDescriptionItem
                Layout.fillWidth: true
                text: root.description
                color: Kirigami.Theme.disabledTextColor
                elide: Text.ElideRight
                visible: root.description !== ""
                onLinkActivated: root.linkActivated(link)
            }
        }
    }
}

