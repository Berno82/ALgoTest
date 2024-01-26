page 75010 "BNO Time Entries Archive List"
{
    ApplicationArea = All;
    Caption = 'Time Entries Archive';
    PageType = List;
    CardPageId = "BNO Time Entry Archive";
    SourceTable = "BNO Time Entry Archive";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Accumulated Time Units"; Rec."Accumulated Time Units")
                {
                    Visible = Units;
                    ToolTip = 'Specifies the value of the Accumulated Time Units field.';
                }
                field("Pause Units"; Rec."Pause Units")
                {
                    Visible = Units;
                    ToolTip = 'Specifies the value of the Pause Units field.';
                }
                field("Accumulated Time"; Rec."Accumulated Time")
                {
                    Visible = not Units;
                    ToolTip = 'Specifies the value of the Accumulated Time field.';
                }
                field(Pause; Rec.Pause)
                {
                    Visible = not Units;
                    ToolTip = 'Specifies the value of the Pause field.';
                }
                field(Sorted; Rec.Sorted)
                {
                    ToolTip = 'Specifies the value of the Sorted field.';
                }
            }
        }
    }

    var
        Units: Boolean;

    trigger OnOpenPage();
    var
        TimeRegSetup: Record "BNO TimeReg Setup";
    begin
        TimeRegSetup.Get(UserId());
        if TimeRegSetup."Unit of Measure" = TimeRegSetup."Unit of Measure"::Units then
            Units := true
        else
            Units := false;

        Rec.FilterGroup(2);
        Rec.SetRange(User, UserId());
        Rec.FilterGroup(0);
    end;
}
