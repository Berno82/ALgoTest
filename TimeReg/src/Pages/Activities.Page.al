page 75004 "BNO Activities"
{
    ApplicationArea = All;
    Caption = 'TimeReg Activities';
    PageType = List;
    SourceTable = "BNO Activity";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Allowed Time Consumption"; Rec."Allowed Time Consumption")
                {
                    ToolTip = 'Specifies the value of the Allowed Time Consumption field.';
                    Visible = not Units;
                }
                field("Allowed Time Units Consumption"; Rec."Allowed Time Units Consumption")
                {
                    ToolTip = 'Specifies the value of the Allowed Time Unit Consumption.';
                    Visible = Units;
                }
                field("Time Consumption"; Rec."Time Consumption")
                {

                    ToolTip = 'Specifies the value of the Time Consumption field.';
                    Visible = not Units;
                }
                field("Time Units Consumption"; Rec."Time Units Consumption")
                {
                    ToolTip = 'Specifies the value of the Time Units Consumption field.';
                    Visible = Units;
                }
                field("Remaining Time"; Rec."Remaining Time")
                {
                    StyleExpr = StyleVar;
                    ToolTip = 'Specifies the value of the Remaining Time field.';
                    Visible = not Units;
                }
                field("Remaining Time Units"; Rec."Remaining Time Units")
                {
                    StyleExpr = StyleVar;
                    ToolTip = 'Specifies the value of the Remaining Time Units field.';
                    Visible = Units;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Update Remaining Time")
            {
                Caption = 'Update Remaining Time';
                ToolTip = 'Executes the Update Remaining Time action.';
                trigger OnAction()
                var
                    Activity: Record "BNO Activity";
                begin
                    Activity.SetRange("Calculate Consumption", true);
                    if Activity.FindSet() then
                        repeat
                            Activity.CalcRemainingTime(Activity, 0, 0);
                        until Activity.Next() = 0;

                end;
            }
        }

        area(Promoted)
        {
            actionref(UpdateRemainingTime_Ref; "Update Remaining Time") { }
        }
    }
    var
        TimeRegSetup: Record "BNO TimeReg Setup";
        Units: Boolean;
        StyleVar: Text;

    trigger OnOpenPage();
    begin
        TimeRegSetup.Get();
        if TimeRegSetup."Unit of Measure" = TimeRegSetup."Unit of Measure"::Units then
            Units := true
        else
            Units := false;
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.SetStyleVar(StyleVar);
    end;


}
