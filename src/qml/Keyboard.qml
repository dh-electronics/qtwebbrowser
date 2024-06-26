/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
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
import QtQuick.VirtualKeyboard

InputPanel {
    id: inputPanel
    property int windowHeight: 0
    property int animationDuration: 0
    property int parentRotation: 0

    rotation: parentRotation
    y: if(rotation == 180) {return -inputPanel.height } else { return windowHeight }
    anchors {
        left: parent.left
        right: parent.right
    }
    states: [
        State {
        name: "visible"
        when: Qt.inputMethod.visible
        PropertyChanges {
            target: inputPanel
            y: if(rotation == 180) {return 0 } else { return windowHeight - inputPanel.height }
        }
    }
    ]
    transitions: Transition {
        from: ""
        to: "visible"
        reversible: true
        NumberAnimation {
            properties: "y"
            duration: animationDuration
            easing.type: Easing.InOutQuad
        }
    }
}
