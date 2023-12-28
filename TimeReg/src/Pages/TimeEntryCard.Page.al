page 75001 "BNO Time Entry Card"
{
    ApplicationArea = All;
    Caption = 'TimeReg';
    PageType = Card;
    SourceTable = "BNO Time Entry";
    UsageCategory = Administration;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
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
            action(StartTime)
            {

                Caption = 'Start Time';

                Image = TimesheetWindowLauncher;
                ToolTip = 'Executes the Start Time action.';

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
                    end;


                    TimeSheet.SetRecord(TimeEntryLine);
                    TimeSheet.Run();
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
                Caption = 'Archive Time Entries';
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
                Caption = 'Archive Time Lines';
                Image = LinesFromTimesheet;
                ToolTip = 'Executes the Archive Time Lines action.';

                trigger OnAction()
                var
                    TimeEntryArchive: Record "BNO Time Entry Archive";
                    TimeEntriesArchive: Page "BNO Time Entries Archive";
                begin
                    TimeEntryArchive.FilterGroup(2);
                    TimeEntryArchive.SetRange(User, Rec.User);
                    TimeEntryArchive.SetRange(Date, Rec.Date);
                    TimeEntryArchive.FilterGroup(0);
                    TimeEntriesArchive.SetRecord(TimeEntryArchive);
                    TimeEntriesArchive.Run();
                end;
            }
        }
        area(Promoted)
        {
            actionref(StartTime_Ref; StartTime) { }
            actionref(Sum_Ref; Sum) { }
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
            TimeRegSetup.Pause := false;
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
