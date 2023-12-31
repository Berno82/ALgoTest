page 75001 "BNO Time Entry Card"
{
    ApplicationArea = All;
    Caption = 'TimeReg';
    PageType = Card;
    SourceTable = "BNO Time Entry";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(User; Rec.User)
                {
                    ToolTip = 'Specifies the value of the User field.';
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Accumulated Time"; Rec."Accumulated Time")
                {
                    ToolTip = 'Specifies the value of the Accumulated Time field.';
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
            action("Start Time")
            {

                Caption = 'Start Time';
                Image = TimesheetWindowLauncher;
                ToolTip = 'Executes the Start Time action.';
                // Visible = false;

                trigger OnAction()
                var
                    TimeEntryLine: Record "BNO Time Entry Line";
                    TimeSheet: Page "BNO Time Sheet";
                begin
                    TimeRegSetup.Get(UserId());
                    TimeEntry.Get(Format(UserId()), Today());
                    TimeEntryLine.SetRange(User, Format(UserId()));
                    TimeEntryLine.SetRange(Date, Today());
                    TimeEntryLine.SetRange(Paused, false);
                    if not TimeEntryLine.FindLast() then begin
                        TimeEntryLine.Init();
                        TimeEntryLine.User := Format(UserId());
                        TimeEntryLine.Date := Today();
                        TimeEntryLine.Insert();
                    end;


                    TimeSheet.SetRecords(TimeEntryLine);
                    TimeSheet.RunModal();
                end;
            }
            action(Pause)
            {
                Caption = 'Pause';
                Image = Pause;
                ToolTip = 'Pause Time registration';

                trigger OnAction()
                begin
                    TimeRegSetup.Get(UserId());
                    TimeRegSetup.Pause := true;
                    TimeRegSetup.Modify();
                end;
            }
        }
        area(Promoted)
        {
            actionref(StartTime; "Start Time") { }
            actionref(PauseRef; Pause) { }
        }
    }

    trigger OnOpenPage()

    begin
        if not TimeRegSetup.Get(UserId()) then begin
            TimeRegSetup.Init();
            TimeRegSetup.User := Format(UserId());
            TimeRegSetup.Insert();
        end else begin
            TimeRegSetup."Last Time" := Time();
            TimeRegSetup.Modify(false);
        end;

        if not TimeEntry.Get(UserId(), Today()) then begin
            TimeEntry.Init();
            TimeEntry.User := Format(UserId());
            TimeEntry.Date := Today();
            TimeEntry.Insert(true);
        end;

        Rec.FilterGroup(2);
        Rec.SetRange(User, UserId());
        Rec.SetRange(Date, Today);
        Rec.FilterGroup(0);
    end;

    var
        TimeRegSetup: Record "BNO TimeReg Setup";
        TimeEntry: Record "BNO Time Entry";
}
