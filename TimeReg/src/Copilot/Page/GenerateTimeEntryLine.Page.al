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
                ToolTip = 'Date that you register Time to';
            }
            field(FromTime; Rec."From Time")
            {
                ApplicationArea = All;
                Caption = 'From Time';
                ToolTip = 'Start Time of the Time Entry Line';
            }
            field(ToTime; Rec."To Time")
            {
                ApplicationArea = All;
                Caption = 'To Time';
                ToolTip = 'End Time of the Time Entry Line';
            }
            field(Description; Rec.Description)
            {
                ApplicationArea = All;
                Caption = 'Description';
                ToolTip = 'Description of the job done';
            }
            field(Activity; Rec.Activity)
            {
                ApplicationArea = All;
                Caption = 'Activity';
                ToolTip = 'Activity to register Time to';
            }
            field(Accepted; Rec.Accepted)
            {
                ApplicationArea = All;
                Caption = 'Accepted';
                ToolTip = 'Time Entry Line is accepted';
            }

            // area(PromptOptions)
            // {
            //     field(Tone; Tone) { }
            //     field(TextFormat; TextFormat) { }
            //     field(Empasis; Empasis) { }
            // }
        }
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
                    TimeEntryLine: Record "BNO Time Entry Line";
                    GenerateTimeEntryLine: Codeunit "BNO Copilot Generation";
                    Counter: Integer;
                    ResultToken: Text;
                    JsonObject: JsonObject;
                    JsonToken: JsonToken;
                    JsonArray: JsonArray;
                begin
                    ResultToken := GenerateTimeEntryLine.GenerateTimeEntries(UserInput);
                    if JsonArray.ReadFrom(ResultToken) then
                        for Counter := 1 to JsonArray.Count do begin
                            JsonArray.Get(Counter - 1, JsonToken);
                            JsonObject := JsonToken.AsObject();
                            // Rec.Init();
                            JsonObject.Get('date', JsonToken);
                            Rec.Date := JsonToken.AsValue().AsDate();
                            JsonObject.Get('fromTime', JsonToken);
                            Rec."From Time" := JsonToken.AsValue().AsTime();
                            JsonObject.Get('toTime', JsonToken);
                            Rec."To Time" := JsonToken.AsValue().AsTime();
                            if JsonObject.Get('description', JsonToken) then
                                Rec.Description := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(Rec.Description))
                            else
                                Rec.Description := '';
                            if JsonObject.Get('activity', JsonToken) then
                                Rec.Activity := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(Rec.Activity))
                            else
                                Rec.Activity := '';
                            Rec.User := CopyStr(UserId(), 1, MaxStrLen(Rec.User));
                            TimeEntryLine.SetRange(User, Rec.User);
                            TimeEntryLine.SetRange(Date, Rec.Date);
                            if TimeEntryLine.FindLast() then
                                Rec."Entry No." := TimeEntryLine."Entry No." + 1000 + Rec."Entry No."
                            else
                                Rec."Entry No." += 1000;

                            Rec.Insert();
                        end
                    else begin
                        Rec.Init();
                        Rec.Description := CopyStr(ResultToken, 1, MaxStrLen(Rec.Description));
                        Rec.Insert();
                    end;


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

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        InsertTimeEntry: Codeunit "BNO Copilot Generation";
    begin
        if CloseAction = CloseAction::Ok then begin
            Rec.SetRange(Accepted, true);
            Rec.FindSet();
            repeat
                if Rec.Date = Today() then
                    InsertTimeEntry.InsertTimeEntry(Rec)
                else
                    InsertTimeEntry.InsertTimeEntryArchive(Rec);
            until Rec.Next() = 0;
        end;
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