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
                    Style = Ambiguous;
                    StyleExpr = ApplyStyle;
                    Visible = not Units;
                    ToolTip = 'Specifies the value of the Registred Time field.';
                }
                field("Registred Time Units"; Rec."Registred Time Units")
                {
                    ApplicationArea = All;
                    Style = Ambiguous;
                    StyleExpr = ApplyStyle;
                    Visible = Units;
                    ToolTip = 'Specifies the value of the Registred Time Units field.';
                }
                field("Remaining Time"; Rec."Remaining Time")
                {
                    ApplicationArea = All;
                    Caption = 'Time Remaining';
                    StyleExpr = StyleVar;
                    ToolTip = 'Specifies the value of the Time Consumed field.';
                    Visible = not Units;
                }
                field("Remaining Time Units"; Rec."Remaining Time Units")
                {
                    ApplicationArea = All;
                    Caption = 'Time Remaining';
                    StyleExpr = StyleVar;
                    ToolTip = 'Specifies the value of the Time Units Consumed field.';
                    Visible = Units;
                }
            }
        }
    }

    var
        TimeRegSetup: Record "BNO TimeReg Setup";
        StyleVar: Text;
        Units: Boolean;
        ApplyStyle: Boolean;

    trigger OnOpenPage();
    begin
        TimeRegSetup.Get(UserID);
        Units := TimeRegSetup."Unit of Measure" = TimeRegSetup."Unit of Measure"::Units;
    end;

    trigger OnAfterGetRecord()
    var
        PActivity: Record "BNO Activity";
    begin
        if Rec."Registred Time Units" < 0.5 then
            ApplyStyle := true;
        PActivity.Get(Rec.User, Rec.Activity);
        PActivity.SetStyleVar(StyleVar);
    end;
}
