page 75005 "BNO Time Entries Archive"
{
    ApplicationArea = All;
    Caption = 'BNO Time Entries Archive';
    PageType = Card;
    SourceTable = "BNO Time Entry Archive";
    UsageCategory = Lists;

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
            part("Archive Lines"; "BNO Time Entry Archive Lines")
            {
                Caption = 'Archived Lines';
                Visible = VisibleSum;
                SubPageLink = Date = field(Date),
                            User = field(User);
            }
            part("Sorted Lines"; "BNO Sorted Lines")
            {
                Caption = 'Sorted TimeReg Lines';
                Visible = VisibleSum;
                SubPageLink = Date = field(Date),
                            User = field(User);
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
                ToolTip = 'Executes the Sum action.';
                Visible = VisibleSum;

                trigger OnAction()
                var
                    TimeEntryLineSorted: Record "BNO Time Entry Line Sorted";
                begin
                    if not Rec.Sorted then
                        TimeRegUtillities.SumLines(Rec.User, Rec.Date);

                    TimeEntryLineSorted.SetRange("User", Rec.User);
                    TimeEntryLineSorted.SetRange("Date", Rec.Date);
                    CurrPage."Sorted Lines".Page.SetTableView(TimeEntryLineSorted);
                end;
            }
            action(Log)
            {
                Caption = 'Log';
                Image = Log;
                Visible = VisibleSum;
                ToolTip = 'Executes the Log action.';

                trigger OnAction()
                begin
                    VisibleSum := false;
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        TimeRegUtillities: Codeunit "BNO TimeReg Utillities";
        VisibleSum: Boolean;
}
