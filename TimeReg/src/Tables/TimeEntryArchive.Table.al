table 75003 "BNO Time Entry Archive"
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
            CalcFormula = sum("BNO Time Entry Line Archive"."Registred Time Units" where(Date = field(Date), User = field(User), Paused = const(false)));

        }
        field(4; Sorted; Boolean)
        {
            Caption = 'Sorted';
        }
        field(5; "Accumulated Time"; Duration)
        {
            Caption = 'Accumulated Time';
            FieldClass = FlowField;
            CalcFormula = sum("BNO Time Entry Line Archive"."Registred Time" where(Date = field(Date), User = field(User), Paused = const(false)));

        }
        field(6; "Pause Units"; Decimal)
        {
            Caption = 'Pause Units';
            FieldClass = FlowField;
            CalcFormula = sum("BNO Time Entry Line Archive"."Registred Time Units" where(Date = field(Date), User = field(User), Paused = const(true)));
        }
        field(7; Pause; Duration)
        {
            Caption = 'Pause';
            FieldClass = FlowField;
            CalcFormula = sum("BNO Time Entry Line Archive"."Registred Time" where(Date = field(Date), User = field(User), Paused = const(true)));
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
