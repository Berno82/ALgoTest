table 75000 "BNO Time Entry"
{
    Caption = 'Time Entry';
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
        field(3; "Accumulated Time Units"; Decimal)
        {
            Caption = 'Accumulated Time';
            FieldClass = FlowField;
            CalcFormula = sum("BNO Time Entry Line"."Registred Time Units" where(Date = field(Date), Paused = const(false)));

        }
        field(4; "Accumulated Time"; Duration)
        {
            Caption = 'Accumulated Time';
            FieldClass = FlowField;
            CalcFormula = sum("BNO Time Entry Line"."Registred Time" where(Date = field(Date), Paused = const(false)));

        }
    }
    keys
    {
        key(PK; User, "Date")
        {
            Clustered = true;
        }
    }
}
