page 75005 "BNO Time Entries Archive"
{
    ApplicationArea = All;
    Caption = 'Time Entries Archive';
    PageType = Card;
    SourceTable = "BNO Time Entry Archive";

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
                    Visible = not Units;
                    ToolTip = 'Specifies the value of the Accumulated Time field.';
                }
                field("Accumulated Time Units"; Rec."Accumulated Time Units")
                {
                    Editable = false;
                    Visible = Units;
                    ToolTip = 'Specifies the value of the Accumulated Time Units field.';
                }
                field(Pause; Rec.Pause)
                {
                    Editable = false;
                    Visible = not Units;
                    ToolTip = 'Specifies the value of the Pause field.';
                }
                field("Pause Units"; Rec."Pause Units")
                {
                    Editable = false;
                    Visible = Units;
                    ToolTip = 'Specifies the value of the Pause Units field.';
                }
            }
            part("Archive Lines"; "BNO Time Entry Archive Lines")
            {
                Caption = 'Archived Lines';
                SubPageLink = Date = field(Date),
                            User = field(User);
                Visible = VisibleSum;
            }
            part("Sorted Lines"; "BNO Sorted Lines")
            {
                Caption = 'Sorted Lines';
                SubPageLink = Date = field(Date),
                            User = field(User);
                Visible = not VisibleSum;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Sum)
            {
                Caption = 'Sum';
                Image = NewSum;
                ToolTip = 'Sums up the lines.';
                Visible = VisibleSum;

                trigger OnAction()
                var
                    TimeEntryLineSorted: Record "BNO Time Entry Line Sorted";
                begin
                    TimeEntryLineSorted.SetRange("User", Rec.User);
                    TimeEntryLineSorted.SetRange("Date", Rec.Date);
                    if not Rec.Sorted then begin
                        TimeEntryLineSorted.DeleteAll(false);
                        TimeRegUtillities.SumLines(Rec.User, Rec.Date);
                    end;

                    CurrPage."Sorted Lines".Page.SetTableView(TimeEntryLineSorted);
                    CurrPage."Sorted Lines".Page.Update(false);
                    VisibleSum := false;
                end;
            }
            action(Lines)
            {
                Caption = 'Lines';
                Image = Timesheet;
                ToolTip = 'Shows the lines.';
                Visible = not VisibleSum;

                trigger OnAction()
                begin
                    VisibleSum := true;
                end;
            }
        }

        area(Promoted)
        {
            actionref(Sum_ref;Sum) {}
            actionref(Lines_ref;Lines) {}
        }
    }

    var
        TimeRegSetup: Record "BNO TimeReg Setup";
        TimeRegUtillities: Codeunit "BNO TimeReg Utillities";
        Units: Boolean;
        VisibleSum: Boolean;

    trigger OnOpenPage()
    begin
        TimeRegSetup.Get(UserID);
        Units := TimeRegSetup."Unit of Measure" = Timeregsetup."Unit of Measure"::Units;
        // VisibleSum := true;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        VisibleSum := Not Rec.Sorted
    end;
}
