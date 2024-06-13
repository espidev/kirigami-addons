// SPDX-FileCopyrightText: 2024 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard
import org.kde.kirigamiaddons.delegates as Delegates

Kirigami.ScrollablePage {
    id: root

    property alias model: listView.model

    title: i18ndc("kirigami-addons6", "@title:window", "Shortcuts")

    actions: Kirigami.Action {
        displayComponent: Kirigami.SearchField {
            placeholderText: i18ndc("kirigami-addons6", "@label:textbox", "Filter...")
        }
    }

    ListView {
        id: listView

        delegate: Delegates.RoundedItemDelegate {
            id: shortcutDelegate

            required property int index
            required property string actionName
            required property var shortcut
            required property string shortcutDisplay
            required property string alternateShortcuts

            text: actionName.replace('&', '')

            contentItem: RowLayout {
                QQC2.Label {
                    text: shortcutDelegate.text
                    Layout.fillWidth: true
                }

                QQC2.Label {
                    text: shortcutDelegate.shortcutDisplay
                }
            }

            onClicked: {
                shortcutDialog.title = i18ndc("krigiami-addons6", "@title:window", "Shortcut: %1",  shortcutDelegate.text);
                shortcutDialog.keySequence = shortcutDelegate.shortcut;
                shortcutDialog.index = shortcutDelegate.index;
                shortcutDialog.alternateShortcuts = shortcutDelegate.alternateShortcuts;
                shortcutDialog.open()
            }
        }

        FormCard.FormCardDialog {
            id: shortcutDialog

            property alias keySequence: keySequenceItem.keySequence
            property var alternateShortcuts
            property int index: -1

            parent: root.QQC2.ApplicationWindow.overlay

            KeySequenceItem {
                id: keySequenceItem
                label: i18ndc("krigiami-addons6", "@label", "Shortcut:")
                onKeySequenceModified: {
                    root.model.updateShortcut(shortcutDialog.index, 0, keySequence);
                }
            }

            Repeater {
                id: alternateRepeater

                model: shortcutDialog.alternateShortcuts
                KeySequenceItem {
                    id: alternateKeySequenceItem

                    required property int index
                    required property var modelData

                    label: index === 0 ? i18ndc("krigiami-addons6", "@label", "Alternative:") : ''

                    keySequence: modelData
                    onKeySequenceModified: {
                        shortcutDialog.alternateShortcuts = root.model.updateShortcut(shortcutDialog.index, index + 1, keySequence);
                    }
                }
            }

            KeySequenceItem {
                id: alternateKeySequenceItem

                label: alternateRepeater.count === 0 ? i18ndc("krigiami-addons6", "@label", "Alternative:") : ''

                onKeySequenceModified: {
                    shortcutDialog.alternateShortcuts = root.model.updateShortcut(shortcutDialog.index, alternateRepeater.count + 1, keySequence);
                    keySequence = root.model.emptyKeySequence();
                }
            }

            footer: RowLayout {
                QQC2.DialogButtonBox {
                    Layout.fillWidth: true
                    standardButtons: QQC2.DialogButtonBox.Close | QQC2.DialogButtonBox.Reset
                    onRejected: shortcutDialog.close();
                    onReset: shortcutDialog.alternateShortcuts = root.model.reset(shortcutDialog.index)
                    leftPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
                    topPadding: Kirigami.Units.smallSpacing
                    rightPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
                    bottomPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
                }
            }
        }

        Kirigami.PlaceholderMessage {
            width: parent.width - Kirigami.Units.gridUnit * 4
            anchors.centerIn: parent
            text: i18ndc("kirigami-addons6", "Placeholder message", "No shortcuts found")
            visible: listView.count === 0
        }
    }

    footer: QQC2.ToolBar {
        padding: 0

        contentItem: QQC2.DialogButtonBox {
            padding: Kirigami.Units.largeSpacing
            standardButtons: QQC2.Dialog.Save | QQC2.Dialog.Reset

            onAccepted: {
                root.model.save()
                root.closeDialog();
            }
            onReset: root.model.resetAll()
        }
    }
}