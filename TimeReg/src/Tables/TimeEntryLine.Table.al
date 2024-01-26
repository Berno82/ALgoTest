table 75001 "BNO Time Entry Line"
{
    Caption = 'Time Entry Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; User; Text[100])
        {
            Caption = 'User';
        }
        field(2; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(3; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(4; "From Time"; Time)
        {
            Caption = 'From';
        }
        field(5; "To Time"; Time)
        {
            Caption = 'To';

            trigger OnValidate()
            begin
                Rec."Registred Time Units" := UpdateTime();
                CalcTimeRemaning();
            end;
        }
        field(6; "Registred Time Units"; Decimal)
        {
            Caption = 'Registred Time';
            DecimalPlaces = 2 : 2;
        }
        field(7; "Registred Time"; Duration)
        {
            Caption = 'Registred Time';

        }
        field(8; Description; Text[1024])
        {
            Caption = 'Description';
        }
        field(9; Activity; Code[20])
        {
            Caption = 'Activity';
            TableRelation = "BNO Activity"."No." where("User Name" = FIELD(User));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                CalcTimeRemaning();
            end;
        }
        field(10; Paused; Boolean)
        {
            Caption = 'Paused';

            trigger OnValidate()
            begin
                if Rec.Paused then
                    Rec.Description := 'Pause';
            end;
        }
        field(11; "Remaining Time"; Duration)
        {
            Caption = 'Remaining Time';
            FieldClass = FlowField;
            CalcFormula = lookup("BNO Activity"."Remaining Time" where("User Name" = field(User), "No." = field(Activity)));
        }
        field(12; "Remaining Time Units"; Decimal)
        {
            Caption = 'Remaining Time';
            DecimalPlaces = 2 : 2;
            FieldClass = FlowField;
            CalcFormula = lookup("BNO Activity"."Remaining Time Units" where("User Name" = field(User), "No." = field(Activity)));
        }
        field(13; Accepted; Boolean)
        {
            Caption = 'Accepted';
        }

    }
    keys
    {
        key(PK; User, Date, "Entry No.")
        {
            Clustered = true;
        }
    }
    procedure UpdateTime() Hours: Decimal
    begin
        Hours := (Rec."To Time" - Rec."From Time") / 6000000 * (100 / 60);

        Rec."Registred Time" := Rec."To Time" - Rec."From Time";
    end;

    procedure InsertTimeEntry(LPause: Boolean; Ldescription: Text[1024]; ActivityCode: Code[20])
    var
        TimeRegUtillities: Codeunit "BNO TimeReg Utillities";
    begin
        Rec.Init();
        Rec.Date := Today();
        Rec.Activity := ActivityCode;
        Rec.User := Format(UserId());
        Rec."From Time" := TimeRegUtillities.GetLastTime();
        Rec.Validate("To Time", Time());
        Rec.Description := Ldescription;
        Rec.Validate(Paused, LPause);
        Rec.Insert(true);
    end;

    local procedure CalcTimeRemaning()
    var
        PActivity: Record "BNO Activity";
    // TimeRegSetup: Record "BNO TimeReg Setup";
    // PTimeEntryLine: Record "BNO Time Entry Line";
    // PTime: Duration;
    // PTimeUnits: Decimal;
    begin
        if (Rec.Activity <> '') and PActivity.Get(Rec.User, Rec.Activity) then
            if PActivity."Calculate Consumption" then
                PActivity.CalcRemainingTime(PActivity, Rec."Registred Time Units", Rec."Registred Time");
    end;
}
