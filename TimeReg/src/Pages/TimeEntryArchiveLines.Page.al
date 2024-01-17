page 75006 "BNO Time Entry Archive Lines"
{
    Caption = 'Time Entry Archive Lines';
    PageType = ListPart;
    SourceTable = "BNO Time Entry Line Archive";

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
                field("From Time"; Rec."From Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From field.';
                }
                field("To Time"; Rec."To Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To field.';
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
                field("Registred Time Units"; Rec."Registred Time Units")
                {
                    ApplicationArea = All;
                    Visible = Units;
                    ToolTip = 'Specifies the value of the Registred Time Units field.';
                }
                field("Registred Time"; Rec."Registred Time")
                {
                    ApplicationArea = All;
                    Visible = not Units;
                    ToolTip = 'Specifies the value of the Registred Time field.';
                }
                field("Remaining Time Units"; Rec."Remaining Time Units")
                {
                    ApplicationArea = All;
                    Visible = Units;
                    StyleExpr = StyleVar;
                    ToolTip = 'Specifies the value of the Remaining Time Units field.';
                }
                field("Remaining Time"; Rec."Remaining Time")
                {
                    ApplicationArea = All;
                    Visible = not Units;
                    StyleExpr = StyleVar;
                    ToolTip = 'Specifies the value of the Remaining Time field.';
                }
            }
        }
    }

    var
        TimeRegSetup: Record "BNO TimeReg Setup";
        Units: Boolean;
        StyleVar: Text;

    trigger OnOpenPage()
    begin
        TimeRegSetup.Get(UserID);
        Units := TimeRegSetup."Unit of Measure" = TimeRegSetup."Unit of Measure"::Units;

    end;

    trigger OnAfterGetRecord()
    var
        PActivity: Record "BNO Activity";
    begin
        PActivity.Get(Rec.User, Rec.Activity);
        PActivity.SetStyleVar(StyleVar);
    end;
}
