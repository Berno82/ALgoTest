///<summary>Time registion page</summary>
page 75000 "BNO Time Sheet"
{
    ApplicationArea = All;
    Caption = 'Time Sheet';
    Editable = true;
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
                        if Activity.Get(Rec.User, Rec.Activity) then
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
                // Visible = false;

                trigger OnAction()
                var
                    TimeEntryLine: Record "BNO Time Entry Line";
                    TimeRegSetup: Record "BNO TimeReg Setup";
                    TimeRegUtillities: Codeunit "BNO TimeReg Utillities";
                begin
                    TimeEntryLine.Init();
                    TimeEntryLine.Date := Today();
                    TimeEntryLine."To Time" := Time();
                    TimeEntryLine.User := Format(UserId());
                    TimeEntryLine."From Time" := TimeRegUtillities.GetLastTime(Rec.User);
                    TimeEntryLine.Description := Rec.Description;
                    TimeEntryLine.Activity := Rec.Activity;
                    TimeEntryLine.Insert(true);

                    TimeRegSetup.Get(UserId());
                    if TimeRegSetup.Pause then begin
                        TimeRegSetup.Pause := false;
                        TimeRegSetup.Modify();
                    end;


                end;
            }
            action(Pause)
            {
                Caption = 'Pause';
                Image = Pause;
                ToolTip = 'Pause Time registration';

                trigger OnAction()
                var
                    TimeRegSetup: Record "BNO TimeReg Setup";
                begin
                    TimeRegSetup.Get(UserId());
                    TimeRegSetup.Pause := true;
                    TimeRegSetup."Last Time" := Time();
                    TimeRegSetup.Modify();

                    CurrPage.Close();
                end;
            }

        }
        area(Promoted)
        {
            actionref("TimeCreateRef"; "Create Time Entry") { }
            actionref("Pause Ref"; Pause) { }
        }
    }
    var

        ActivityTxt: Text[2048];

    procedure SetRecord(var TempTimeEntryLine: Record "BNO Time Entry Line" temporary)
    begin
        Rec := TempTimeEntryLine;
        Rec.Insert();
    end;
}