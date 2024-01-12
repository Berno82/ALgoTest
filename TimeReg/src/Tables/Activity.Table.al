table 75005 "BNO Activity"
{
    Caption = 'Activity';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "User Name"; Text[100])
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
        field(5; "Allowed Time Consumption"; Decimal)
        {
            Caption = 'Allowed Time Consumption';

            trigger OnValidate()
            begin
                if "Allowed Time Consumption" <> 0 then
                "Calculate Consumption" := true;
            end;
        }
        field(6; "Allowed Time Units Consumption"; Decimal)
        {
            Caption = 'Allowed Time Consumption';
            trigger OnValidate()
            begin
                if "Allowed Time Units Consumption" <> 0 then
                "Calculate Consumption" := true;
            end;
        }

        field(7; "Time Units Consumption"; Decimal)
        {
            Caption = 'Time Consumption';
            FieldClass = FlowField;
            CalcFormula = sum("BNO Time Entry Line Archive"."Registred Time Units" where(Activity = field("No.")));
        }
        field(8; "Time Consumption"; Decimal)
        {
            Caption = 'Time Consumption';
            FieldClass = FlowField;
            CalcFormula = sum("BNO Time Entry Line Archive"."Registred Time" where(Activity = field("No.")));
        }
    }
    keys
    {
        key(PK; "User Name", "No.")
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
        Rec."User Name" := Format(UserId());
    end;
}
