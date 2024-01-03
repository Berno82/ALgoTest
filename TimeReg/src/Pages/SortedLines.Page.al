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
                    StyleExpr = StyleVar;
                    Visible = not Units;
                    ToolTip = 'Specifies the value of the Registred Time field.';
                }
                field("Registred Time Units"; Rec."Registred Time Units")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleVar;
                    Visible = Units;
                    ToolTip = 'Specifies the value of the Registred Time Units field.';
                }
            }
        }
    }

    var
        TimeRegSetup: Record "BNO TimeReg Setup";
        StyleVar: Text[50];
        Units: Boolean;

    trigger OnOpenPage();
    begin
        TimeRegSetup.Get(UserID);
        Units := TimeRegSetup."Unit of Measure" = TimeRegSetup."Unit of Measure"::Units;
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."Registred Time Units" < 0.5 then
            StyleVar := 'Unfavorable'
        else
            StyleVar := 'None';

    end;
}
