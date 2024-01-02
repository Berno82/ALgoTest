page 75001 "BNO Time Entry Card"
{
    ApplicationArea = All;
    Caption = 'TimeReg';
    Editable = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "BNO Time Entry";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            usercontrol(TimerControl; "BNO TimerControl")
            {
                ApplicationArea = All;

                // trigger ControlAddInReady();
                // begin

                // end;

                trigger NewTimeEntry()
                begin
                    Message('NewTimeEntry');
                    CurrPage.TimerControl.StopTime();
                    EnterTimeEntryLine();
                    if not TimeRegSetup.Pause then
                        CurrPage.TimerControl.StartTime(TimeRegSetup.Interval * 60000);
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
            action(StartTime)
            {

                Caption = 'Start Time';
                Image = Start;
                ToolTip = 'Executes the Start Time action.';
                Visible = OnPrem;

                trigger OnAction()
                begin
                    CurrPage.TimerControl.StartTime(TimeRegSetup.Interval * 60000);
                end;
            }
            action(StopTime)
            {
                Caption = 'Stop Time';
                Image = Stop;
                ToolTip = 'Executes the Stop Time action.';
                Visible = OnPrem;

                trigger OnAction()
                begin
                    CurrPage.TimerControl.StopTime();
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
            action("Archive Lines")
            {
                Caption = 'Archived Time Lines';
                Image = LinesFromTimesheet;
                ToolTip = 'Executes the Archive Time Lines action.';

                trigger OnAction()
                var
                    TimeEntryArchive: Record "BNO Time Entry Archive";
                    TimeEntriesArchive: Page "BNO Time Entries Archive";
                begin
                    TimeEntryArchive.FilterGroup(2);
                    TimeEntryArchive.SetRange(User, Rec.User);
                    TimeEntryArchive.FilterGroup(0);
                    TimeEntryArchive.FindLast();
                    TimeEntriesArchive.SetRecord(TimeEntryArchive);
                    TimeEntriesArchive.Run();
                end;
            }
        }
        area(Promoted)
        {
            actionref(StartTime_Ref; StartTime) { }
            actionref(Sum_Ref; Sum) { }
            actionref(EnterTimeEntryLine_Ref; "Enter Time Entry Line") { }
        }
    }


    var
        TimeRegSetup: Record "BNO TimeReg Setup";
        TimeEntry: Record "BNO Time Entry";
        EnvironmentInformation: Codeunit "Environment Information";
        OnPrem: Boolean;
        Units: Boolean;

    trigger OnOpenPage()

    begin
        if not TimeRegSetup.Get(UserId()) then begin
            TimeRegSetup.Init();
            TimeRegSetup.User := Format(UserId());
            TimeRegSetup.Insert();
        end else begin
            TimeRegSetup."Last Time" := Time();
            TimeRegSetup.Pause := false;
            TimeRegSetup.Modify(false);
        end;

        if not TimeEntry.Get(UserId(), Today()) then
            SetTimeEntry();
        Rec.FilterGroup(2);
        Rec.SetRange(User, UserId());
        Rec.SetRange(Date, Today);
        Rec.FilterGroup(0);
        Units := TimeRegSetup."Unit of Measure" = TimeRegSetup."Unit of Measure"::Units;
        OnPrem := not EnvironmentInformation.IsSaaSInfrastructure();
    end;

    local procedure SetTimeEntry()
    begin
        TimeEntry.Init();
        TimeEntry.User := Format(UserId());
        TimeEntry.Date := Today();
        TimeEntry.Insert(true);
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
        TimeRegSetup.Get(UserId());
    end;
}
