// namespace TimeReg.AI;
// using System.AI;

// page 75007 "BNO Generate Time Entry Line"
// {
//     ApplicationArea = All;
//     Caption = 'BNO Generate Time Entry Line';
//     DataCaptionExpression = UserInput;
//     PageType = PromptDialog;
//     IsPreveiw = true;
//     UsageCategory = Lists;
//     Extensible = false;
//     SourceTable = "BNO Time Entry Line";
//     SourceTableTemporary = true;

//     layout
//     {
//         area(Prompt)
//         {
//             field(TimeEntryDescription; UserInput)
//             {
//                 ShowCaption = false;
//                 MultiLine = true;
//             }
//         }

//         area(Content)
//         {
//             field("Date"; Date)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Date';
//                 Editable = false;
//                 ToolTip = 'Date';
//             }
//             field(FromTime; FromTime)
//             {
//                 ApplicationArea = All;
//                 Caption = 'From Time';
//                 ToolTip = 'From Time';
//             }
//             field(ToTime; ToTime)
//             {
//                 ApplicationArea = All;
//                 Caption = 'To Time';
//                 ToolTip = 'To Time';
//             }
//             field(Description; Description)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Description';
//                 ToolTip = 'Description';
//             }
//             field(Activity; Activity)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Activity';
//                 ToolTip = 'Activity';
//             }
//         }

//         // area(PromptOptions)
//         // {
//         //     field(Tone; Tone) { }
//         //     field(TextFormat; TextFormat) { }
//         //     field(Empasis; Empasis) { }
//         // }
//     }
//     actions
//     {
//         area(SystemActions)
//         {
//             systemaction(Generate)
//             {
//                 Caption = 'Generate';
//                 ToolTip = 'Generate Time Entry Line Copilot suggestion';
//                 trigger OnAction()
//                 begin
//                 end;
//             }
//             systemaction(Regenerate)
//             {
//                 Caption = 'Regenerate';
//                 ToolTip = 'Regenerate Time Entry Line Copilot suggestion';
//                 trigger OnAction()
//                 begin
//                 end;
//             }

//             systemaction(Attach)
//             {
//                 Caption = 'Attach';
//                 ToolTip = 'Attach Time Entry line suggestion';
//                 trigger OnAction()
//                 var
//                     InStr: InStream;
//                     Filename: Text;
//                     PUserInput: Text;
//                 begin
//                     UploadINtoStream('Select a file to upload', '', 'ALl files (*.*)|*.*', Filename, InStr);
//                     if InStr.Length > 0 then begin
//                         InStr.ReadText(PUserInput);
//                         UserInput := CopyStr(PUserInput, 1, MaxStrLen(UserInput));

//                     end;
//                 end;
//             }

//             systemaction(Ok)
//             {
//                 Caption = 'Save Suggestion';
//                 ToolTip = 'Save Time Entry line suggestion';
//             }
//             systemaction(Cancel)
//             {
//                 Caption = 'Discard Suggestion';
//                 ToolTip = 'Discard Time Entry line suggestion';
//             }
//         }
//     }

//     var
//         UserInput: Text[1024];
//         Date: Date;
//         FromTime: Time;
//         ToTime: Time;
//         Description: Text[1024];
//         Activity: Code[20];

//     trigger OnOpenPage()
//     begin
//         Date := WorkDate();
//     end;

//     trigger OnQueryClosePage(CloseAction: Action): Boolean
//     var
//         InsertTimeEntry: Codeunit "BNO Insert Time Entry";
//     begin
//         if CloseAction = CloseAction::Ok then
//             InsertTimeEntry.InsertTimeEntry(UserId, Date, FromTime, ToTime, Description, Activity);
//     end;
// }
