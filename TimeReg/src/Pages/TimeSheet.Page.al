///<summary>Time registion page</summary>
page 75000 "BNO Time Sheet"
{
    ApplicationArea = All;
    Caption = 'Time Sheet';
    PageType = Card;
    SourceTable = "BNO Time Entry Line";
    SourceTableTemporary = true;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Activity; Rec.Activity)
                {
                    ToolTip = 'Specifies the value of the Activity field.';

                    trigger OnValidate()
                    var
                        Activity: Record "BNO Activity";
                    begin
                        if Activity.Get(Rec.Activity) then
                            ActivityTxt := Activity.Description;
                    end;
                }
                field(ActivityDescription; ActivityTxt)
                {
                    Caption = 'Activity Description';
                    ToolTip = 'Specifies the value of the Activity Description field.';
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Create Time Entry")
            {
                ApplicationArea = All;
                Caption = 'Create Time Entry';
                Image = Action;
                ShortcutKey = 'Ctrl+Enter';
                ToolTip = 'Executes the Create Time Entry action.';
                Visible = false;

                trigger OnAction()
                var
                    TimeEntryLine: Record "BNO Time Entry Line";
                    TimeRegUtillities: Codeunit "BNO TimeReg Utillities";
                begin
                    TimeEntryLine.Init();
                    TimeEntryLine.Date := Today();
                    TimeEntryLine."To Time" := Time();
                    TimeEntryLine.User := Format(UserId());
                    TimeEntryLine."From Time" := TimeRegUtillities.GetLastTime(UserId());
                    TimeEntryLine.Description := Rec.Description;
                    TimeEntryLine.Activity := Rec.Activity;
                    TimeEntryLine.Insert(true);
                end;
            }
        }
        area(Promoted)
        {
            actionref("TimeCreateRef"; "Create Time Entry") { }
        }
    }
    var
        ActivityTxt: Text[2048];
}