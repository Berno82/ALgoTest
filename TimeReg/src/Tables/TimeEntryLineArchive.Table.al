table 75004 "BNO Time Entry Line Archive"
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
        field(7; Description; Text[1024])
        {
            Caption = 'Description';
        }
        field(8; Activity; Code[20])
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

    trigger OnInsert()
    begin
        Rec."Registred Time" := UpdateTime();
        CleanUpSorted();

    end;

    trigger OnModify()
    begin
        Rec."Registred Time" := UpdateTime();
        CleanUpSorted();

    end;

    procedure UpdateTime() Hours: Decimal
    var
        TimeRegSetup: Record "BNO TimeReg Setup";
    begin
        TimeRegSetup.Get(Rec.User);
        Hours := (Rec."To Time" - Rec."From Time") / 6000000;
        if TimeRegSetup."Unit of Measure" = TimeRegSetup."Unit of Measure"::Units then
            Hours := Hours * (100 / 60);
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
