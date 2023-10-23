/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami

import "private" as Private

/**
 * @brief A Form delegate that corresponds to a clickable button.
 *
 * Use the inherited QtQuick.Controls.AbstractButton.text property to define
 * the main text of the button.
 *
 * The trailing property (right-most side of the button) includes an arrow
 * pointing to the right by default and cannot be overridden.
 *
 * @since KirigamiAddons 0.11.0
 *
 * @inherit AbstractFormDelegate
 */
AbstractFormDelegate {
    id: root

    /**
     * @brief A label containing secondary text that appears under the
     * inherited text property.
     *
     * This provides additional information shown in a faint gray color.
     *
     * This is supposed to be a short text and the API user should avoid
     * making it longer than two lines.
     */
    property string description: ""

    /**
     * @brief This property allows to override the internal description
     * item (a QtQuick.Controls.Label) with a custom component.
     */
    property alias descriptionItem: internalDescriptionItem

    /**
     * @brief This property holds an item that will be displayed to the
     * left of the delegate's contents.
     *
     * default: `null`
     */
    property var leading: null

    /**
     * @brief This property holds the padding after the leading item.
     *
     * It is recommended to use Kirigami.Units here instead of direct values.
     *
     * @see Kirigami.Units
     */
    property real leadingPadding: Kirigami.Units.smallSpacing

    focusPolicy: Qt.StrongFocus

    contentItem: RowLayout {
        spacing: 0

        Private.ContentItemLoader {
            Layout.rightMargin: visible ? root.leadingPadding : 0
            visible: root.leading
            implicitHeight: visible ? root.leading.implicitHeight : 0
            implicitWidth: visible ? root.leading.implicitWidth : 0
            contentItem: root.leading
        }

        Kirigami.Icon {
            visible: root.icon.name !== ""
            source: root.icon.name
            color: root.icon.color
            Layout.rightMargin: (root.icon.name !== "") ? Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing : 0
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
                wrapMode: Text.Wrap
                maximumLineCount: 2
                color: root.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
                Accessible.ignored: true // base class sets this text on root already
            }

            Label {
                id: internalDescriptionItem
                Layout.fillWidth: true
                text: root.description
                color: Kirigami.Theme.disabledTextColor
                elide: Text.ElideRight
                visible: root.description !== ""
                wrapMode: Text.Wrap
                Accessible.ignored: !visible
            }
        }

        FormArrow {
            Layout.leftMargin: Kirigami.Units.smallSpacing
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            direction: Qt.RightArrow
            visible: root.background.visible
        }
    }

    Accessible.onPressAction: action ? action.trigger() : root.clicked()
}
