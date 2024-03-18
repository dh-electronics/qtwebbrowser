/****************************************************************************
**
** Copyright (C) 2018  DH Electroncis GmbH
** Contact: https://www.dh-electronics.com/
**
** This file is part of the Qt WebBrowser application.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Qt.labs.settings 1.0

Rectangle
{
    id: spinboxComponent

    property alias spinbox: control
    property alias text: text

    height: 100
    width: 560
    anchors.horizontalCenter: parent.horizontalCenter
    Text {
        id: text
        anchors.verticalCenter: parent.verticalCenter
        font.family: defaultFontFamily
        font.pixelSize: 28
    }
    Rectangle {
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        SpinBox{
            id: control

            anchors.centerIn: parent

            contentItem: TextInput {
                z: 2
                text: control.textFromValue(control.value, control.locale)

                font: control.font
                color: "#21be2b"
                selectionColor: "#21be2b"
                selectedTextColor: "#ffffff"
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter

                readOnly: !control.editable
                validator: control.validator
                inputMethodHints: Qt.ImhFormattedNumbersOnly
            }

            up.indicator: Rectangle {
                x: control.mirrored ? 0 : parent.width - width
                height: parent.height
                implicitWidth: 40
                implicitHeight: 40
                color: control.up.pressed ? "#e4e4e4" : "#f6f6f6"
                border.color: enabled ? "#21be2b" : "#bdbebf"

                Text {
                    text: "+"
                    font.pixelSize: control.font.pixelSize * 2
                    color: "#21be2b"
                    anchors.fill: parent
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            down.indicator: Rectangle {
                x: control.mirrored ? parent.width - width : 0
                height: parent.height
                implicitWidth: 40
                implicitHeight: 40
                color: control.down.pressed ? "#e4e4e4" : "#f6f6f6"
                border.color: enabled ? "#21be2b" : "#bdbebf"

                Text {
                    text: "-"
                    font.pixelSize: control.font.pixelSize * 2
                    color: "#21be2b"
                    anchors.fill: parent
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            background: Rectangle {
                implicitWidth: 140
                border.color: "#bdbebf"
            }
        }

    }
}


