/****************************************************************************
**
** Original work Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** Modified work Copyright (C) 2018  DH Electroncis GmbH
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
import Qt.labs.settings
import Settings 1.0

Rectangle {
    id: root

    Column{
        LabeledSpinbox {
            id: rotation

            text.text: qsTr("Screen Rotation")

            spinbox.value: GlobalSettings.viewRotation
            spinbox.from: 0
            spinbox.to: 270
            spinbox.stepSize: 90

        }

        LabeledSpinbox {
            id: screensavertime

            text.text: qsTr("Screensaver Activation Time")

            spinbox.value: GlobalSettings.screensaverActivationTime
            spinbox.from: 0
            spinbox.to: 60
            spinbox.stepSize: 1

        }

        LabeledSwitch {
            id: autoLoadImages

            text.text: qsTr("Auto Load Images")

            switchControl.checked: GlobalSettings.autoLoadImages

        }

        LabeledSwitch {
            id: javaScriptDisabled

            text.text: qsTr("Disable JavaScript")

            switchControl.checked: GlobalSettings.javaScriptDisabled

        }

        LabeledSwitch {
            id: kioskmode

            text.text: qsTr("Kioskmode")

            switchControl.checked: GlobalSettings.kioskmodeEnabled

        }



    }

    onStateChanged:
    {
        //update the settings when done was clicked
        if(state == "disabled")
        {
            GlobalSettings.viewRotation = rotation.spinbox.value
            GlobalSettings.screensaverActivationTime = screensavertime.spinbox.value
            GlobalSettings.autoLoadImages = autoLoadImages.switchControl.checked
            GlobalSettings.javaScriptDisabled = javaScriptDisabled.switchControl.checked
            GlobalSettings.kioskmodeEnabled = kioskmode.switchControl.checked

            GlobalSettings.save()
        }

    }


    state: "disabled"

    states: [
        State {
            name: "enabled"
            AnchorChanges {
                target: root
                anchors.top: navigation.bottom
            }
            PropertyChanges {
                target: settingsToolBar
                opacity: 1.0
            }
        },
        State {
            name: "disabled"
            AnchorChanges {
                target: root
                anchors.top: root.parent.bottom
            }
            PropertyChanges {
                target: settingsToolBar
                opacity: 0.0
            }
        }
    ]

    transitions: Transition {
        AnchorAnimation { duration: animationDuration; easing.type : Easing.InSine }
    }


}
