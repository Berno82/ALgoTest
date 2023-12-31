table 75001 "BNO Time Entry Line"
{
    Caption = 'BNO Time Entry Line';
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
        }
        field(6; "Registred Time"; Decimal)
        {
            Caption = 'Registred Time';
        }
        field(7; Description; Text[2048])
        {
            Caption = 'Description';
        }
        field(8; Activity; Code[20])
        {
            Caption = 'Activity';
            TableRelation = "BNO Activity";
            ValidateTableRelation = false;
        }
        field(9; Paused; Boolean)
        {
            Caption = 'Paused';
        }

    }
    keys
    {
        key(PK; User, Date, "Entry No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Rec."Registred Time" := UpdateTime();
    end;

    trigger OnModify()
    begin
        Rec."Registred Time" := UpdateTime();
    end;

    local procedure UpdateTime() Hours: Decimal
    begin
        Hours := (Rec."To Time" - Rec."From Time") / 60000;

    end;
}
