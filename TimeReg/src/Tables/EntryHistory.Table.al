table 75008 "BNO Entry History"
{
    Caption = 'BNO Entry History';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "User ID"; Text[100])
        {
            Caption = 'User';
        }
        field(2; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
        }
        field(3; Activity; Code[20])
        {
            Caption = 'Activity';
        }
        field(4; Description; Text[1024])
        {
            Caption = 'Description';
        }
        field(5; "Date"; Date)
        {
            Caption = 'Date';
        }
    }
    keys
    {
        key(PK; "User ID", ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Activity, Description) { }
    }
}
