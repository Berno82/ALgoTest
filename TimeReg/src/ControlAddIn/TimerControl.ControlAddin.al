/// <summary>
/// Timer control for TimeReg
/// </summary>
controladdin "BNO TimerControl"
{
    Scripts = 'Scripts/TimerControl.js';
    StartupScript = 'Scripts/TimerControl.js';

    HorizontalShrink = true;
    HorizontalStretch = true;
    MinimumHeight = 1;
    MinimumWidth = 1;
    RequestedHeight = 1;
    RequestedWidth = 1;
    VerticalShrink = true;
    VerticalStretch = true;

    procedure StartTime(miliseconds: Integer);
    procedure StopTime();

    ///<summary>Triggers a new time entry</summary>
    event NewTimeEntry();
}