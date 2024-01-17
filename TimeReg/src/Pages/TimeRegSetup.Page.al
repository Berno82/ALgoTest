page 75003 "BNO TimeReg Setup"
{
    ApplicationArea = All;
    Caption = 'TimeReg Setup';
    PageType = Card;
    SourceTable = "BNO TimeReg Setup";
    UsageCategory = Administration;

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
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }
                field("Cosumption Warning %"; Rec."Cosumption Warning %")
                {
                    ToolTip = 'Specifies the value of the Cosumption Warning % field.';
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

    trigger OnOpenPage()
    begin
        if not Rec.Get(UserId()) then begin
            Rec.Init();
            Rec.Insert();
        end;

    end;
}
