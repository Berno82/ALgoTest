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
                field(TimeConsumptionStatus; TimeConsumptionStatus)
                {
                    ApplicationArea = All;
                    Caption = 'Time Consumption Status';
                    ToolTip = 'Specifies the value of the Time Consumed field.';
                }
            }
        }
    }
    var
        TimeConsumptionStatus: Decimal;

    trigger OnAfterGetRecord()
    var
        ActivityRecord: Record "BNO Activity";
        TimeRegSetup: Record "BNO TimeReg Setup";
    begin
        TimeRegSetup.Get();
        ActivityRecord.Get(Rec.Activity);
        ActivityRecord.CalcFields("Time Consumption", "Time Units Consumption");
        if ActivityRecord."Calculate Consumption" then
            case TimeRegSetup."Unit of Measure" of
                TimeRegSetup."Unit of Measure"::Hours:
                    TimeConsumptionStatus := ActivityRecord."Allowed Time Consumption" - ActivityRecord."Time Consumption";
                TimeRegSetup."Unit of Measure"::Units:
                    TimeConsumptionStatus := ActivityRecord."Allowed Time Units Consumption" - ActivityRecord."Time Units Consumption";
            end;
    end;
}
