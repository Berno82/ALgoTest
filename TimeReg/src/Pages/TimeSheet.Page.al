page 75000 "BNO Time Sheet"
{
    Caption = 'Time Sheet';
    PageType = Card;
    SourceTable = "BNO Time Entry Line";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Activity; Rec.Activity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Activity field.';
                }
            }
        }
    }
}