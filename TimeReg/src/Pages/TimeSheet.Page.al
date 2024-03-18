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
                    begin
                        // SetActivityText();
                        if Rec.Activity <> '' then
                            if StrLen(Rec.Activity) = 8 then begin
                                if not (CopyStr(Rec.Activity, 1, 1) = 'A') then
                                    Error(ActivityErr);
                            end
                            else
                                Error(ActivityErr);
                    end;
                }
                field(ActivityDescription; ActivityTxt)
                {
                    Caption = 'Activity Description';
                    ToolTip = 'Specifies the value of the Activity Description field.';
                    Editable = false;
                }
            }
            group(History)
            {
                Caption = 'History';

                field("Historic Entry"; Rec."Historic Entry")
                {
                    ToolTip = 'Specifies the value of the Historic Entry field.';
                    trigger OnValidate()
                    var
                        EntryHistory: Record "BNO Entry History";
                    begin
                        EntryHistory.Get(Rec.User, Rec."Historic Entry");
                        Rec.Activity := EntryHistory.Activity;
                        Rec.Description := EntryHistory.Description;
                        Rec."Historic Entry" := '';
                    end;
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

                trigger OnAction()
                var
                    EntryHistory: Record "BNO Entry History";
                begin
                    CreateTimeEntry(false, Rec.Description, Rec.Activity);
                    EntryHistory.SetRange("User ID", Rec.User);
                    EntryHistory.SetRange("Activity", Rec.Activity);
                    EntryHistory.SetRange("Description", Rec.Description);
                    if EntryHistory.FindFirst() then begin
                        EntryHistory.Date := Today();
                        EntryHistory.Modify();
                    end else begin
                        EntryHistory.Init();
                        EntryHistory."User ID" := Rec.User;
                        EntryHistory.Description := Rec.Description;
                        EntryHistory.Activity := Rec.Activity;
                        EntryHistory.Date := Today();
                        EntryHistory.Insert();
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
                    TimeEntryLine: Record "BNO Time Entry Line";
                begin
                    TimeEntryLine.SetRange(User, Rec.User);
                    TimeEntryLine.SetRange(Date, Today());
                    if TimeEntryLine.FindLast() then
                        TimeRegUtillities.SetLastTime(TimeEntryLine."To Time", true);

                    CanClose := true;
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
        TimeRegUtillities: Codeunit "BNO TimeReg Utillities";
        ActivityTxt: Text[2048];
        CanClose: Boolean;
        ActivityErr: Label 'Activity format is not valid';

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        CloseErr: Label 'Can only be closed by using actions';

    begin
        if CanClose then
            exit(true);
        Message(CloseErr);
        exit(false);
    end;

    procedure SetRecord(var TempTimeEntryLine: Record "BNO Time Entry Line" temporary)
    begin
        Rec := TempTimeEntryLine;
        Rec.Insert();
        SetActivityText();
    end;

    local procedure CreateTimeEntry(LPause: Boolean; Ldescription: Text[1024]; ActivityCode: Code[20])
    var
        TimeEntryLine: Record "BNO Time Entry Line";

    begin
        TimeEntryLine.InsertTimeEntry(LPause, Ldescription, ActivityCode);

        if LPause then
            PauseTime(TimeEntryLine."To Time");
        CanClose := true;
        CurrPage.Close();
    end;

    local procedure PauseTime(ToTime: Time)
    var
        TimeRegSetup: Record "BNO TimeReg Setup";
    begin
        TimeRegSetup.Get(UserId());
        if TimeRegSetup.Pause then
            TimeRegUtillities.SetLastTime(ToTime, false);
    end;

    local procedure SetActivityText()
    var
        ActivityRecord: Record "BNO Activity";
    begin
        if ActivityRecord.Get(Rec.User, Rec.Activity) then
            ActivityTxt := ActivityRecord.Description;
    end;
}