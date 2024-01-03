table 75004 "BNO Time Entry Line Archive"
{
    Caption = 'Time Entry Line Archive';
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
        field(6; "Registred Time Units"; Decimal)
        {
            Caption = 'Registred Time';
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
        field(10; Paused; Boolean)
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
        Rec."Registred Time Units" := UpdateTime();
        CleanUpSorted();

    end;

    trigger OnModify()
    begin
        Rec."Registred Time Units" := UpdateTime();
        CleanUpSorted();

    end;

    procedure UpdateTime() Hours: Decimal
    begin
        Hours := (Rec."To Time" - Rec."From Time") / 6000000 * (100 / 60);

        Rec."Registred Time" := Rec."To Time" - Rec."From Time";
    end;

    local procedure CleanUpSorted()
    var
        TimeEntryArchive: Record "BNO Time Entry Archive";
        TimeEntryLineSorted: Record "BNO Time Entry Line Sorted";
    begin
        TimeEntryArchive.Get(Rec.User, Rec.Date);
        TimeEntryArchive.Sorted := false;
        TimeEntryArchive.Modify();

        TimeEntryLineSorted.SetRange(User, Rec.User);
        TimeEntryLineSorted.SetRange(Date, Rec.Date);
        TimeEntryLineSorted.DeleteAll();
    end;
}
