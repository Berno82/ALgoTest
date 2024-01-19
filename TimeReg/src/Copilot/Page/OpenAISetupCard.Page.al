page 75009 "BNO Open AI Setup Card"
{
    ApplicationArea = All;
    Caption = 'BNO Open AI Setup Card';
    PageType = Card;
    SourceTable = "BNO Open AI Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(MetaPrompt; MetaPrompt)
                {
                    ApplicationArea = All;
                    Caption = 'Meta Prompt';
                    ToolTip = 'Specifies the value of the MetaPrompt field.';

                    trigger OnValidate()
                    begin
                        Clear(Rec.MetaPrompt);
                        Rec.SetMetaPrompt(MetaPrompt);
                    end;
                }
            }
        }
    }
    var
        MetaPrompt: Text;

    trigger OnAfterGetRecord()
    begin
        MetaPrompt := Rec.GetMetaPrompt();
    end;
}
