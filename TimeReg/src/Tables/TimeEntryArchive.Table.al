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
        field(3; "Accumulated Time"; Duration)
        {
            Caption = 'Accumulated Time';
            FieldClass = FlowField;
            CalcFormula = sum("BNO Time Entry Line"."Registred Time" where(Date = field(Date)));

        }
        field(4; Sorted; Boolean)
        {
            Caption = 'Sorted';
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
