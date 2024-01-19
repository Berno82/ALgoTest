namespace TimeReg.AI;
using System.AI;

page 75007 "BNO Generate Time Entry Line"
{
    ApplicationArea = All;
    Caption = 'BNO Generate Time Entry Line';
    DataCaptionExpression = UserInput;
    PageType = PromptDialog;
    PromptMode = Prompt;
    IsPreview = true;
    UsageCategory = Lists;
    Extensible = false;
    SourceTable = "BNO Time Entry Line";
    SourceTableTemporary = true;

    layout
    {
        area(Prompt)
        {
            field(TimeEntryDescription; UserInput)
            {
                ApplicationArea = All;
                ShowCaption = false;
                MultiLine = true;

                trigger OnValidate()
                begin

                end;
            }
        }

        area(Content)
        {
            field("Date"; Rec.Date)
            {
                ApplicationArea = All;
                Caption = 'Date';
                Editable = false;
                ToolTip = 'Date';
            }
            field(FromTime; Rec."From Time")
            {
                ApplicationArea = All;
                Caption = 'From Time';
                ToolTip = 'From Time';
            }
            field(ToTime; Rec."To Time")
            {
                ApplicationArea = All;
                Caption = 'To Time';
                ToolTip = 'To Time';
            }
            field(Description; Rec.Description)
            {
                ApplicationArea = All;
                Caption = 'Description';
                ToolTip = 'Description';
            }
            field(Activity; Rec.Activity)
            {
                ApplicationArea = All;
                Caption = 'Activity';
                ToolTip = 'Activity';
            }
        }

        // area(PromptOptions)
        // {
        //     field(Tone; Tone) { }
        //     field(TextFormat; TextFormat) { }
        //     field(Empasis; Empasis) { }
        // }
    }
    actions
    {
        area(SystemActions)
        {
            systemaction(Generate)
            {
                Caption = 'Generate';
                ToolTip = 'Generate Time Entry Line Copilot suggestion';
                trigger OnAction()
                var
                    // GenerateTimeEntryLine: Codeunit "BNO Insert Time Entry";
                    ResultToken: Text;
                    JsonObject: JsonObject;
                    JsonToken: JsonToken;
                begin
                    // ResultToken := GenerateTimeEntryLine.GenerateTimeEntries(UserInput);
                    ResultToken := UserInput;
                    JsonObject.ReadFrom(UserInput);
                    Rec.Init();
                    JsonObject.Get('date', JsonToken);
                    Rec.Date := JsonToken.AsValue().AsDate();
                    JsonObject.Get('fromTime', JsonToken);
                    Rec."From Time" := JsonToken.AsValue().AsTime();
                    JsonObject.Get('toTime', JsonToken);
                    Rec."To Time" := JsonToken.AsValue().AsTime();
                    JsonObject.Get('description', JsonToken);
                    Rec.Description := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(Rec.Description));
                    if JsonObject.Get('activity', JsonToken) then
                        Rec.Activity := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(Rec.Activity));
                    Rec.User := UserId();
                    Rec.Insert();

                end;
            }
            systemaction(Regenerate)
            {
                Caption = 'Regenerate';
                ToolTip = 'Regenerate Time Entry Line Copilot suggestion';
                trigger OnAction()
                begin
                end;
            }

            systemaction(Attach)
            {
                Caption = 'Attach';
                ToolTip = 'Attach Time Entry line suggestion';
                trigger OnAction()
                begin
                    ImportUserInput(UserInput);
                end;
            }

            systemaction(Ok)
            {
                Caption = 'Save Suggestion';
                ToolTip = 'Save Time Entry line suggestion';
            }
            systemaction(Cancel)
            {
                Caption = 'Discard Suggestion';
                ToolTip = 'Discard Time Entry line suggestion';
            }
        }
    }

    var
        UserInput: Text[1024];
    // Date: Date;
    // FromTime: Time;
    // ToTime: Time;
    // Description: Text[1024];
    // Activity: Code[20];

    // trigger OnOpenPage()
    // begin
    //     Date := WorkDate();
    // end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        InsertTimeEntry: Codeunit "BNO Insert Time Entry";
    begin
        if CloseAction = CloseAction::Ok then
            InsertTimeEntry.InsertTimeEntry(Rec);
    end;

    local procedure ImportUserInput(var IUserInput: Text[1024])
    var
        InStr: InStream;
        Filename: Text;
        PUserInput: Text;
    begin
        if UploadINtoStream('Select a file to upload', '', 'ALl files (*.*)|*.*', Filename, InStr) then
            if InStr.Length > 0 then begin
                InStr.ReadText(PUserInput);
                IUserInput := CopyStr(PUserInput, 1, MaxStrLen(IUserInput));

            end;
    end;
}
