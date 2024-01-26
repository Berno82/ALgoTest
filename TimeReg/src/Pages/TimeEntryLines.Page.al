page 75002 "BNO Time Entry Lines"
{
    Caption = 'Time Entry Lines';
    PageType = ListPart;
    SourceTable = "BNO Time Entry Line";

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
                field("Remaining Time"; Rec."Remaining Time")
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = StyleVar;
                    ToolTip = 'Specifies the value of the Remaining Time field.';
                    Visible = not Units;
                }
                field("Remaining Time Units"; Rec."Remaining Time Units")
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = StyleVar;
                    ToolTip = 'Specifies the value of the Remaining Time Units field.';
                    Visible = Units;
                }
            }
        }
    }
    var
        Units: Boolean;
        StyleVar: Text;

    trigger OnOpenPage();
    var
        TimeRegSetup: Record "BNO TimeReg Setup";
    begin
        TimeRegSetup.Get();
        if TimeRegSetup."Unit of Measure" = TimeRegSetup."Unit of Measure"::Units then
            Units := true;
    end;

    trigger OnAfterGetRecord()
    var
        PActivity: Record "BNO Activity";
    begin
        if PActivity.Get(Rec.User, Rec.Activity) then
            PActivity.SetStyleVar(StyleVar);
    end;
}
