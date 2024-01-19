page 75001 "BNO Time Entry Card"
{
    ApplicationArea = All;
    Caption = 'TimeReg';
    DeleteAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "BNO Time Entry";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            usercontrol(TimerControl; "BNO TimerControl")
            {
                ApplicationArea = All;

                trigger NewTimeEntry()
                begin
                    StopTime();
                    if (Time() - TimeRegUtillities.GetLastTime()) > TimeRegSetup."Wait Time" then
                        EnterTimeEntryLine();
                    if not TimeRegSetup.Pause then
                        StartTime();
                end;
            }

            group(General)
            {
                Caption = 'General';

                field(User; Rec.User)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the User field.';
                }
                field("Date"; Rec."Date")
                {

                    ToolTip = 'Specifies the value of the Date field.';
                }

                field("Accumulated Time"; Rec."Accumulated Time")
                {
                    Editable = false;
                    Visible = not Units;
                    ToolTip = 'Specifies the value of the Accumulated Time field.';
                }
                field("Accumulated Time Units"; Rec."Accumulated Time Units")
                {
                    Editable = false;
                    Visible = Units;
                    ToolTip = 'Specifies the value of the Accumulated Time Units field.';
                }

            }

            part(Lines; "BNO Time Entry Lines")
            {
                ApplicationArea = All;
                SubPageLink = User = field(User),
                                Date = field(Date);
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("StartTime Action")
            {

                Caption = 'Start Time';
                Image = Start;
                ToolTip = 'Executes the Start Time action.';

                trigger OnAction()
                begin
                    if TimeRegSetup.Pause then
                        TimeRegUtillities.SetLastTime(Time(), false);
                    StartTime();
                end;
            }
            action(Pause)
            {
                Caption = 'Pause';
                Image = Pause;
                ToolTip = 'Pause Time registration';

                trigger OnAction()
                begin
                    TimeRegUtillities.SetLastTime(TimeRegUtillities.GetLastTime(), true);
                    StopTime();
                end;
            }
            action("UnPause Action")
            {
                Caption = 'Unpause';
                Image = DisableBreakpoint;
                ToolTip = 'Pause Time registration';

                trigger OnAction()

                begin
                    Unpause();

                end;
            }
            action("StopTime Action")
            {
                Caption = 'Stop Time';
                Image = Stop;
                ToolTip = 'Executes the Stop Time action.';

                trigger OnAction()
                begin
                    StopTime();
                end;
            }
            action("Enter Time Entry Line")
            {
                Caption = 'Enter Time Entry Line';
                Image = Timesheet;
                ToolTip = 'Enter Time Entry Line manually.';

                trigger OnAction()
                begin
                    EnterTimeEntryLine();
                end;
            }
            action(Sum)
            {
                Caption = 'Sum';
                Image = NewSum;
                ToolTip = 'Executes the Sum action.';

                trigger OnAction()
                var
                    TimeRegUtillities: Codeunit "BNO TimeReg Utillities";
                begin
                    TimeRegUtillities.SumCurrentLines(Rec.User, Rec.Date);
                end;
            }
        }
        area(Navigation)
        {
            action("Archive Entries")
            {
                Caption = 'Archive Entries';
                Image = Archive;
                ToolTip = 'Executes the Archive Time Entries action.';

                trigger OnAction()
                var
                    TimeRegUtillities: Codeunit "BNO TimeReg Utillities";
                begin
                    TimeRegUtillities.ArchiveEntries();
                end;
            }
            action("Archived Entries")
            {
                Caption = 'Archived Time Entries';
                Image = LinesFromTimesheet;
                ToolTip = 'Executes the Archived Time Entries action.';

                trigger OnAction()
                var
                    TimeEntriesArchive: Page "BNO Time Entries Archive list";
                begin
                    TimeEntriesArchive.RunModal();
                end;
            }

        }
        area(Promoted)
        {
            actionref(StartTime_Ref; "StartTime Action") { }
            actionref(Sum_Ref; Sum) { }
            actionref(EnterTimeEntryLine_Ref; "Enter Time Entry Line") { }
            actionref(Unpause_Ref; "UnPause Action") { }
        }
    }


    var
        TimeRegSetup: Record "BNO TimeReg Setup";
        TimeEntry: Record "BNO Time Entry";
        TimeRegUtillities: Codeunit "BNO TimeReg Utillities";
        Units: Boolean;

    trigger OnOpenPage()
    begin
        // InitRecord();
        if not TimeEntry.Get(UserId(), Today()) then
            SetTimeEntry();
        Rec.FilterGroup(2);
        Rec.SetRange(User, UserId());
        Rec.SetRange(Date, Today);
        Rec.FilterGroup(0);
        Units := TimeRegSetup."Unit of Measure" = TimeRegSetup."Unit of Measure"::Units;

    end;

    local procedure SetTimeEntry()
    begin
        TimeEntry.Init();
        TimeEntry.User := Format(UserId());
        TimeEntry.Date := Today();
        TimeEntry.Insert(true);

        TimeRegSetup.Get(UserId());
        TimeRegSetup.Pause := false;
        TimeRegSetup.Modify();
    end;

    local procedure EnterTimeEntryLine()
    var
        TimeEntryLine: Record "BNO Time Entry Line";
        TimeSheet: Page "BNO Time Sheet";
    begin
        TimeRegSetup.Get(UserId());
        TimeEntryLine.SetRange(User, Format(UserId()));
        TimeEntryLine.SetRange(Date, Today());
        TimeEntryLine.SetRange(Paused, false);
        if not TimeEntryLine.FindLast() then begin
            TimeEntryLine.Init();
            TimeEntryLine.User := Format(UserId());
            TimeEntryLine.Date := Today();
        end;

        TimeSheet.SetRecord(TimeEntryLine);
        TimeSheet.RunModal();
    end;

    local procedure Unpause()
    var
        TimeEntryLine: Record "BNO Time Entry Line";
    begin
        TimeRegSetup.Get(UserId());
        if TimeRegSetup.Pause then begin
            TimeEntryLine.InsertTimeEntry(TimeRegSetup.Pause, '', '');
            TimeRegUtillities.SetLastTime(TimeEntryLine."To Time", false);
            StartTime();
        end;
    end;

    local procedure StartTime()
    begin
        TimeRegSetup.Get(UserId());
        CurrPage.TimerControl.StartTime(TimeRegSetup."Wait Time");
    end;

    local procedure StopTime()
    begin
        CurrPage.TimerControl.StopTime();
    end;
}
