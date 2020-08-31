import QtQuick 2.7
import QtQuick.Window 2.2
import Display 1.0
import EventSpy 1.0
import Settings 1.0

Rectangle {
    id: screensaver
    visible: true
    anchors.fill: parent
    color: "transparent"

    BrightnessControl {
        id:brightness
    }

    // Activates the Screen Saver after a specific time
    Timer {
        id: screenSaverTimer
        interval: { GlobalSettings.screensaverActivationTime * 1000 * 60}
        running: true
        onTriggered: {
            brightness.setBrightness(0);
            mouseArea.visible = true;

        }

        //a interval of 0 should lead to disable the screensaver
        onIntervalChanged: {
            if(interval == 0)
                screenSaver.enabled = false;
            else
                screenSaver.enabled = true;
        }

    }

    // Reset screensaver timer when clicks are received
    MouseArea {
        id: mouseArea
        anchors.fill: parent

        // Pass mouse events through
        propagateComposedEvents: true

        onClicked: {
            mouseArea.visible = false;
            brightness.setBrightness(10);
            screenSaverTimer.restart();
            mouse.accepted = false;
        }

    }

    // At startup the display should be visible
    Component.onCompleted: {
        brightness.setBrightness(10);
    }

    onEnabledChanged: {
        if(enabled === true)
        {
            screenSaverTimer.restart()
        }
        else
        {
            screenSaverTimer.stop()
            brightness.setBrightness(10);
            mouseArea.visible = false;
        }

    }

    // Resets the screensaver even when the screensaver is not in action
    Connections {
        target: TouchEventSpy
        onTouchEventDetected:
        {
            if(screenSaver.enabled)
                screenSaverTimer.restart();
        }
    }
}

