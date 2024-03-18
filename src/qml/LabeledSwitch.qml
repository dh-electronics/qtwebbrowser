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

Rectangle
{
    property alias switchControl: sw
    property alias text: text

    height: 100
    width: 560
    anchors.horizontalCenter: parent.horizontalCenter
    Text {
        id: text
        anchors.verticalCenter: parent.verticalCenter
        font.family: defaultFontFamily
        font.pixelSize: 28
        text: listModel.get(modelindex).name
        color: sw.enabled ? "black" : "#929495"
    }

    Rectangle {
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        Switch {
            id: sw
            anchors.centerIn: parent

            indicator: Rectangle {
                implicitWidth: 72
                height: 42
                x: sw.width - width - sw.rightPadding
                y: parent.height / 2 - height / 2
                radius: height / 2
                border.color: sw.checked ? "#5caa14" : "#9b9b9b"
                color: sw.checked ? "#5cff14" : "white"
                border.width: 1

                Rectangle {
                    x: sw.checked ? parent.width - width : 0
                    width: 42
                    height: 42
                    radius: height/2
                    color: sw.down ? "#cccccc" : "#ffffff"
                    border.color: sw.checked ? "#5caa14" : "#9b9b9b"
                    border.width: 1
                }
            }
        }
    }
}



