
var timerObject;

Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ControlAddInReady');

function StartTime(milliSeconds) {
    timerObject = window.setInterval(TimerAction, milliSeconds);
}

function StopTime() {
    clearInterval(timerObject);
}

function TimerAction() {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('NewTimeEntry');
}