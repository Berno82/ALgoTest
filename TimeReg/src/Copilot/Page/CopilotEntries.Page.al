page 75013 "BNO Copilot Entries"
{
    ApplicationArea = All;
    Caption = 'Copilot Entries';
    PageType = ListPart;
    SourceTable = "BNO Time Entry Line";
    SourceTableTemporary = true;

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
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("From Time"; Rec."From Time")
                {
                    ToolTip = 'Specifies the value of the From field.';
                }
                field("To Time"; Rec."To Time")
                {
                    ToolTip = 'Specifies the value of the To field.';
                }
                field(Activity; Rec.Activity)
                {
                    ToolTip = 'Specifies the value of the Activity field.';
                }
            }
        }
    }

    internal procedure LoadData(TempTimeLineEntry: Record "BNO Time Entry Line" temporary)
    begin
        if TempTimeLineEntry.FindSet() then
            repeat
                Rec := TempTimeLineEntry;
                Rec.Insert(false);
            until TempTimeLineEntry.Next() = 0;
        CurrPage.Update();
    end;
}
