page 75003 "BNO TimeReg Setup"
{
    ApplicationArea = All;
    Caption = 'TimeReg Setup';
    PageType = Card;
    SourceTable = "BNO TimeReg Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(Interval; Rec.Interval)
                {
                    ToolTip = 'Specifies the value of the Interval Minutes field.';
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(Activities)
            {
                Caption = 'Activities';
                Image = Agreement;
                RunObject = page "BNO Activities";
                ToolTip = 'Open Activities page';
            }
        }
    }
}
