table 75001 "BNO Time Entry Line"
{
    Caption = 'BNO Time Entry Line';
    DataClassification = CustomerContent;

    fields
    {
        field(2; User; Text[100])
        {
            Caption = 'User';

        }
        field(3; "Date"; Date)
        {
            Caption = 'Date';

        }
        field(4; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(5; From; Time)
        {
            Caption = 'From';
        }
        field(6; "To"; Time)
        {
            Caption = 'To';
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
        }
    }
    keys
    {
        key(PK; User, Date, "Entry No.")
        {
            Clustered = true;
        }
    }
}
