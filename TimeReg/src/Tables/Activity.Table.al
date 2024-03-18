table 75005 "BNO Activity"
{
    Caption = 'Activity';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "User ID"; Text[100])
        {
            Caption = 'User Name';
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; Description; Text[2048])
        {
            Caption = 'Description';
        }
        field(4; "Calculate Consumption"; Boolean)
        {
            Caption = 'Calculate Consumption';
        }
        field(5; "Allowed Time Consumption"; Duration)
        {
            Caption = 'Allowed Time Consumption';

            trigger OnValidate()
            begin
                if "Allowed Time Consumption" <> 0 then
                    "Calculate Consumption" := true
                else
                    "Calculate Consumption" := false;
            end;
        }
        field(6; "Allowed Time Units Consumption"; Integer)
        {
            Caption = 'Allowed Time Consumption';
            trigger OnValidate()
            begin
                if "Allowed Time Units Consumption" <> 0 then
                    "Calculate Consumption" := true
                else
                    "Calculate Consumption" := false;
            end;
        }

        field(7; "Time Units Consumption"; Decimal)
        {
            Caption = 'Time Consumption';
            DecimalPlaces = 2 : 2;
            FieldClass = FlowField;
            CalcFormula = sum("BNO Time Entry Line Archive"."Registred Time Units" where(Activity = field("No."), User = field("User ID")));
            Editable = false;
        }
        field(8; "Time Consumption"; Duration)
        {
            Caption = 'Time Consumption';
            FieldClass = FlowField;
            CalcFormula = sum("BNO Time Entry Line Archive"."Registred Time" where(Activity = field("No."), User = field("User ID")));
            Editable = false;
        }
        field(9; "Remaining Time Units"; Decimal)
        {
            Caption = 'Remining Time';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(10; "Remaining Time"; Duration)
        {
            Caption = 'Remaining Time ';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "User ID", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description) { }
    }
    trigger OnInsert()
    begin
        Rec."User ID" := Format(UserId());
    end;

    procedure CalcRemainingTime(Activity: Record "BNO Activity"; CurrTimeUnits: Decimal; CurrTime: Duration)
    var
        TimeEntryLine: Record "BNO Time Entry Line";
        TimeEntryLineArchive: Record "BNO Time Entry Line Archive";

    begin
        TimeEntryLineArchive.SetRange("Activity", Activity."No.");
        TimeEntryLineArchive.CalcSums("Registred Time Units", "Registred Time");
        TimeEntryLine.SetRange("Activity", Activity."No.");
        TimeEntryLine.CalcSums("Registred Time Units", "Registred Time");
        Activity."Remaining Time Units" := Activity."Allowed Time Units Consumption" - TimeEntryLineArchive."Registred Time Units" - TimeEntryLine."Registred Time Units" - CurrTimeUnits;
        Activity."Remaining Time" := Activity."Allowed Time Consumption" - TimeEntryLine."Registred Time" - TimeEntryLineArchive."Registred Time" - CurrTime;
        Activity.Modify();
    end;

    procedure SetStyleVar(var PstyleVar: Text)
    var
        TimeRegSetup: Record "BNO TimeReg Setup";
        Low: Boolean;
    begin
        TimeRegSetup.Get("User ID");
        case TimeRegSetup."Unit of Measure" of
            TimeRegSetup."Unit of Measure"::Units:
                begin
                    Rec.CalcFields("Time Units Consumption");
                    if (Rec."Time Units Consumption" <> 0) and (Rec."Allowed Time Units Consumption" <> 0) then
                        if (Rec."Time Units Consumption" / Rec."Allowed Time Units Consumption" * 100) > TimeRegSetup."Cosumption Warning %" then
                            Low := true
                        else
                            if Rec."Time Consumption" < Rec."Allowed Time Consumption" then
                                Low := true
                end;
        end;

        if Low then
            PStyleVar := 'Unfavorable'
        else
            PStyleVar := 'None';

    end;
}
