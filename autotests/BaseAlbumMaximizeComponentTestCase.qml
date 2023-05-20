// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick 2.15
import QtTest 1.2

import org.kde.kirigami 2.15 as Kirigami
import org.kde.kirigamiaddons.labs.components 1.0

TestCase {
    id: root

    property var model

    readonly property string testImage: dataDir + "/kmail.png"
    readonly property string testVideo: dataDir + "/discover_hl_720p.webm"

    when: windowShown

    function test_hasItems() {
        var testAlbum = createTemporaryObject(album, root);
        testAlbum.open();
        compare(testAlbum.content.count == 3, true);
        testAlbum.destroy();
    }

    // Select the image item and check that the current delegate has the correct properties.
    function test_imageParams() {
        var testAlbum = createTemporaryObject(album, root);
        testAlbum.content.currentIndex = 0;
        compare(testAlbum.content.currentItem.type, AlbumModelItem.Image)
        compare(testAlbum.content.currentItem.source, root.testImage)
        compare(testAlbum.content.currentItem.tempSource, root.testImage)
        compare(testAlbum.content.currentItem.caption, "A test image")
        testAlbum.destroy();
    }

    // Select the video item and check that the current delegate has the correct properties.
    function test_videoParams() {
        var testAlbum = createTemporaryObject(album, root);
        testAlbum.content.currentIndex = 1;
        compare(testAlbum.content.currentItem.type, AlbumModelItem.Video)
        compare(testAlbum.content.currentItem.source, root.testVideo)
        compare(testAlbum.content.currentItem.tempSource, root.testImage)
        compare(testAlbum.content.currentItem.caption, "A test video")
        testAlbum.destroy();
    }

    // Select the image item and check that the image only actions are visible.
    function test_imageActions() {
        var testAlbum = createTemporaryObject(album, root);
        testAlbum.content.currentIndex = 0;
        compare(testAlbum.actions[2].visible, true)
        compare(testAlbum.actions[3].visible, true)
        testAlbum.destroy();
    }

    // Select the video item and check that the image only actions are not visible.
    function test_videoActions() {
        var testAlbum = createTemporaryObject(album, root);
        testAlbum.content.currentIndex = 1;
        compare(testAlbum.actions[2].visible, false)
        compare(testAlbum.actions[3].visible, false)
        testAlbum.destroy();
    }

    // Test that the caption is only visible if showCaption is true and a
    // captions string exists.
    function test_captionVisibility() {
        var testAlbum = createTemporaryObject(album, root);
        testAlbum.open()

        // Check that caption will be visible for the first item with
        // showCaption = true.
        testAlbum.showCaption = true
        testAlbum.content.currentIndex = 0;
        compare(testAlbum.footer.visible, true)

        // Check that caption will be visible for the second item with
        // showCaption = true.
        testAlbum.content.currentIndex = 1;
        compare(testAlbum.footer.visible, true)

        // Check that caption will not be visible for the third item with
        // showCaption = true.
        testAlbum.content.currentIndex = 2;
        compare(testAlbum.footer.visible, false)

        // Check that caption will not be visible for the first item with
        // showCaption = false.
        testAlbum.showCaption = false
        testAlbum.content.currentIndex = 0;
        compare(testAlbum.footer.visible, false)

        // Check that caption will not be visible for the second item with
        // showCaption = false.
        testAlbum.content.currentIndex = 1;
        compare(testAlbum.footer.visible, false)

        // Check that caption will not be visible for the third item with
        // showCaption = false.
        testAlbum.content.currentIndex = 2;
        compare(testAlbum.footer.visible, false)
        testAlbum.destroy();
    }

    Component {
        id: album
        AlbumMaximizeComponent {
            parent: undefined
            width: 100
            height: 100

            initialIndex: 0
            model: root.model
        }
    }
}
