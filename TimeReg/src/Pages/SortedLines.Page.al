page 75008 "BNO Sorted Lines"
{
    ApplicationArea = All;
    Caption = 'Sorted Time Entry Lines';
    Editable = false;
    PageType = ListPart;
    SourceTable = "BNO Time Entry Line Sorted";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';
                }
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
                field("Registred Time"; Rec."Registred Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Registred Time field.';
                }
            }
        }
    }
}
