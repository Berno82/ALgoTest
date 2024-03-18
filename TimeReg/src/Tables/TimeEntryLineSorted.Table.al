table 75006 "BNO Time Entry Line Sorted"
{
    Caption = 'Time Entry Line Sorted';
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
            TableRelation = "BNO Activity"."No." where("User ID" = FIELD(User));
        }
        field(10; Paused; Boolean)
        {
            Caption = 'Paused';
        }
        field(11; "Remaining Time"; Duration)
        {
            Caption = 'Remaining Time';
            FieldClass = FlowField;
            CalcFormula = lookup("BNO Activity"."Remaining Time" where("User ID" = field(User), "No." = field(Activity)));
        }
        field(12; "Remaining Time Units"; Decimal)
        {
            Caption = 'Remaining Time';
            FieldClass = FlowField;
            CalcFormula = lookup("BNO Activity"."Remaining Time Units" where("User ID" = field(User), "No." = field(Activity)));
        }
    }
    keys
    {
        key(PK; User, Date, "Entry No.")
        {
            Clustered = true;
        }
        key(Key1; User, Activity)
        {
            SumIndexFields = "Registred Time", "Registred Time Units";
            MaintainSiftIndex = false;
        }
    }

    trigger OnInsert()
    begin
        SetSorted(true);
    end;

    trigger OnDelete()
    var
        TimeEntryLineSorted: Record "BNO Time Entry Line Sorted";
    begin
        TimeEntryLineSorted.SetRange(User, Rec.User);
        TimeEntryLineSorted.SetRange(Date, Rec.Date);
        TimeEntryLineSorted.Delete();
        SetSorted(false);
    end;

    local procedure SetSorted(Sorted: Boolean)
    var
        TimeEntryArchive: Record "BNO Time Entry Archive";
    begin
        TimeEntryArchive.Get(Rec.User, Rec.Date);
        TimeEntryArchive.Sorted := Sorted;
        TimeEntryArchive.Modify();
    end;
}
