import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

// Bar badge for the cyber lab. It reports capture processes that are already
// running and whether the newest ~/Work/<name>/scope.md names who authorized
// the work. Click opens that scope file. It does not start a capture.
BarWidget {
  id: root
  moduleName: "calledtoconstruct.cyber-lab"

  property var captures: []
  property string scopePath: ""
  property bool authorized: false
  property string statusError: ""
  property bool opened: false
  property bool popoutSwitchClosing: false

  readonly property bool capturing: captures.length > 0
  readonly property string label: capturing ? "cap" : (scopePath !== "" && !authorized ? "scope" : "lab")

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function scriptPath() {
    var url = Qt.resolvedUrl("status.sh").toString()
    if (url.indexOf("file://") === 0)
      url = decodeURIComponent(url.substring(7))
    return url
  }

  function refresh() {
    if (statusProc.running)
      return
    statusProc.command = [scriptPath()]
    statusProc.running = true
  }

  function applyStatus(text) {
    var parsed
    try {
      parsed = JSON.parse(text)
    } catch (error) {
      statusError = "status was not JSON"
      return
    }
    captures = parsed.captures || []
    scopePath = parsed.scope || ""
    authorized = parsed.authorized === true
    statusError = ""
  }

  function tooltip() {
    if (statusError !== "")
      return "Cyber lab: " + statusError
    var lines = []
    if (capturing)
      lines.push("Capturing: " + captures.join(", "))
    else
      lines.push("No capture running")
    if (scopePath === "")
      lines.push("No scope.md under ~/Work")
    else if (authorized)
      lines.push("Scope names who authorized it")
    else
      lines.push("Scope is missing Authorized by")
    lines.push("Click opens the scope file")
    return lines.join("\n")
  }

  function openScope() {
    if (scopePath === "")
      return
    openProc.command = ["xdg-open", scopePath]
    openProc.running = true
  }

  function open() { refresh() }
  function close() { opened = false }
  function toggle() { openScope() }

  Component.onCompleted: refresh()

  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: root.refresh()
  }

  Process {
    id: statusProc
    stdout: StdioCollector {
      id: statusOut
      waitForEnd: true
    }
    onExited: function (exitCode) {
      if (exitCode === 0)
        root.applyStatus(String(statusOut.text || ""))
      else
        root.statusError = "status script failed"
    }
  }

  Process {
    id: openProc
  }

  WidgetButton {
    id: button
    bar: root.bar
    text: root.label
    active: root.capturing
    dimmed: !root.capturing && (root.scopePath === "" || !root.authorized)
    tooltipText: root.tooltip()
    onPressed: root.openScope()
  }
}
