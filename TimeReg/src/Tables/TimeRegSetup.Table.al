table 75002 "BNO TimeReg Setup"
{
    Caption = 'TimeReg Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; User; Text[1024])
        {
            Caption = 'No.', Locked = true;
        }
        field(2; "Last Time"; Time)
        {
            Caption = 'Last Time', Locked = true;
        }
        field(3; Pause; Boolean)
        {
            Caption = 'Pause', Locked = true;
        }
        field(4; Interval; Integer)
        {
            Caption = 'Interval (Minutes)';
            trigger OnValidate()
            begin
                Rec."Wait Time" := Rec.Interval * 1000 * 60;
            end;
        }
        field(5; "Wait Time"; Duration)
        {
            Caption = 'Wait Time', Locked = true;
        }
        field(6; "Unit of Measure"; Option)
        {
            Caption = 'Unit of Measure';
            OptionMembers = "Units","Hours";
        }
    }
    keys
    {
        key(PK; User)
        {
            Clustered = true;
        }
    }
}
