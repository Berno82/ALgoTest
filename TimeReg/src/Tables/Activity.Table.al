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
    }
    keys
    {
        key(PK; "User Name", "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Rec."User Name" := Format(UserId());
    end;
}
