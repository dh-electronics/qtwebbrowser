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
import QtQuick.Controls
import QtQuick.Layouts
import WebBrowser
import Settings 1.0

import "assets"

ToolBar {
    id: root

    property alias addressBar: urlBar
    property Item webView: null
    property bool changedToTracking: false
    property bool touch: touchGesture
    property bool fullscreenMode: false

    onWebViewChanged: {

    }

    visible: opacity != 0.0
    opacity: tabView.viewState == "page" ? 1.0 : 0.0

    function load(url) {
        if (url)
            webView.url = url
        homeScreen.state = "disabled"
    }

    state: {
        if(GlobalSettings.kioskmodeEnabled || fullscreenMode)
        {
            return "disabled";
        }
        else
        {
            if(GlobalSettings.touchtrackingEnabled)
                return "tracking"
            else
                return "enabled";
        }
    }

    onStateChanged: {if(state=="tracking") changedToTracking=true; else changedToTracking=false;}

    //after the first touch event we are not changed to Tracking we are already tracking
    onTouchChanged: changedToTracking= false

    background: Rectangle {
        color: uiColor
        implicitHeight: toolBarSize + 3
    }
    padding: 0

    Behavior on y {
        NumberAnimation { duration: animationDuration }
    }

    states: [
        State {
            name: "enabled"
            PropertyChanges {
                target: root
                y: 0
            }
        },
        State {
            name: "tracking"
            PropertyChanges {
                target: root
                y: {
                    if(changedToTracking || activeFocus)
                        return 0

                    var diff = touchReference - touchY

                    if (velocityY > velocityThreshold) {
                        if (diff > 0)
                            return -root.height
                        else
                            return 0
                    }

                    if (!touchGesture || diff == 0) {
                        if (y < -root.height / 2)
                            return -root.height
                        else
                            return 0
                    }

                    if (diff > root.height)
                        return -root.height

                    if (diff > 0) {
                        if (y == -root.height)
                            return -root.height
                        return -diff
                    }

                    // diff < 0

                    if (y == 0)
                        return 0

                    diff = Math.abs(diff)
                    if (diff >= root.height)
                        return 0

                    return -root.height + diff
                }
            }
        },
        State {
            name: "disabled"
            PropertyChanges {
                target: root
                y: -root.height+progressBar.height
            }
        }
    ]

    RowLayout {
        height: toolBarSize
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
        }
        spacing: 0

        UIButton {
            id: backButton
            source: "icons/Btn_Back.png"
            color: uiColor
            highlightColor: buttonPressedColor
            onClicked: webView.goBack()
            enabled: webView && webView.canGoBack
        }
        Rectangle {
            width: 1
            height: parent.height
            color: uiSeparatorColor
        }
        UIButton {
            id: forwardButton
            source: "icons/Btn_Forward.png"
            color: uiColor
            highlightColor: buttonPressedColor
            onClicked: webView.goForward()
            enabled: webView && webView.canGoForward
        }
        Rectangle {
            width: 1
            height: parent.height
            color: uiSeparatorColor
        }
        Rectangle {
            Layout.fillWidth: true
            implicitWidth: 10
            height: parent.height
            color: uiColor
        }
        TextField {
            id: urlBar
            Layout.fillWidth: true
            text: webView ? webView.url : ""
            activeFocusOnPress: true
            inputMethodHints: Qt.ImhUrlCharactersOnly | Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase | Qt.ImhPreferLowercase
            placeholderText: qsTr("Search or type a URL")

            onActiveFocusChanged: {
                if (activeFocus) {
                    urlBar.selectAll()
                    homeScreen.state = "disabled"
                    urlDropDown.state = "enabled"
                } else {
                    urlDropDown.state = "disabled"
                }
            }

            UIButton {
                id: reloadButton
                state: cancelButton.visible ? "edit" : "load"
                states: [
                    State {
                        name: "load"
                        PropertyChanges {
                            target: reloadButton
                            source: webView && webView.loading ? "icons/Btn_Clear.png" : "icons/Btn_Reload.png"
                            height: 54
                        }
                    },
                    State {
                        name: "edit"
                        PropertyChanges {
                            target: reloadButton
                            source: "icons/Btn_Clear.png"
                            height: 45
                            visible: urlBar.text != ""
                        }
                    }
                ]
                height: 54
                width: height
                color: "transparent"
                highlightColor: "#eeeeee"
                radius: width / 2
                anchors {
                    rightMargin: 1
                    right: parent.right
                    verticalCenter: addressBar.verticalCenter;
                }
                onClicked: {
                    if (state == "load") {
                        webView.loading ? webView.stop() : webView.reload()
                        webView.forceActiveFocus()
                        return
                    }
                    urlBar.selectAll()
                    urlBar.remove(urlBar.selectionStart, urlBar.selectionEnd)
                }
            }

            
            color: "black"
            font.family: defaultFontFamily
            font.pixelSize: 20
            selectionColor: uiHighlightColor
            selectedTextColor: "black"
            placeholderTextColor: placeholderColor
            background: Rectangle {
                implicitWidth: 514
                implicitHeight: 56
                border.color: textFieldStrokeColor
                border.width: 1
            }

            leftPadding: 15
            rightPadding: reloadButton.width
            topPadding: 10

            onAccepted: {
                webView.url = AppEngine.fromUserInput(text)
                homeScreen.state = "disabled"
                tabView.viewState = "page"
            }

            onEditingFinished: {
                selectAll()
                webView.forceActiveFocus()
            }
        }
        Rectangle {
            visible: !cancelButton.visible
            Layout.fillWidth: true
            implicitWidth: 10
            height: parent.height
            color: uiColor
        }

        UIButton {
            id: cancelButton
            color: uiColor
            visible: urlDropDown.state === "enabled"
            highlightColor: buttonPressedColor
            Text {
                color: "white"
                anchors.centerIn: parent
                text: "Cancel"
                font.family: defaultFontFamily
                font.pixelSize: 28
            }
            implicitWidth: 120
            onClicked: {
                urlDropDown.state = "disabled"
                webView.forceActiveFocus()
            }
        }
        Rectangle {
            width: 1
            height: parent.height
            color: uiSeparatorColor
        }
        Rectangle {
            width: 1
            height: parent.height
            color: uiSeparatorColor
        }
        UIButton {
            id: pageViewButton
            source: "icons/Btn_Tabs.png"
            color: uiColor
            highlightColor: buttonPressedColor
            onClicked: {
                if (tabView.viewState == "list") {
                    tabView.viewState = "page"
                } else {
                    tabView.get(tabView.currentIndex).item.webView.takeSnapshot()
                    homeScreen.state = "disabled"
                    tabView.viewState = "list"
                }
            }
            Text {
                anchors {
                    centerIn: parent
                    verticalCenterOffset: 4
                }

                text: tabView.count
                font.family: defaultFontFamily
                font.pixelSize: 16
                font.weight: Font.DemiBold
                color: "white"
            }
        }
        Rectangle {
            width: 1
            height: parent.height
            color: uiSeparatorColor
        }
        Rectangle {
            width: 1
            height: parent.height
            color: uiSeparatorColor
        }

    }
    ProgressBar {
        id: progressBar
        height: 3
        anchors {
            left: parent.left
            bottom: parent.bottom
            right: parent.right
            leftMargin: -10
            rightMargin: -10
        }

        background: Rectangle {
            height: 3
            color: emptyBackgroundColor
        }

        contentItem: Rectangle {
            width: progressBar.visualPosition * parent.width
            color: GlobalSettings.progressBarColor
        }

        from: 0
        to: 100
        value: (webView && webView.loadProgress < 100) ? webView.loadProgress : 0
    }
}
