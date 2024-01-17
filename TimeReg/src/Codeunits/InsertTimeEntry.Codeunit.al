codeunit 75002 "BNO Insert Time Entry"
{
    ///<summary>Inserts Time ENtry line from Copilot example</summary>
    procedure InsertTimeEntry(UserID: Text; Date: Date; FromTime: Time; ToTime: Time; Description: Text[1024]; Activity: Code[20]): Boolean;
    var
        TimeEntryLine: Record "BNO Time Entry Line";
    begin
        TimeEntryLine.User := CopyStr(UserID, 1, MaxStrLen(TimeEntryLine.User));
        TimeEntryLine."Date" := Date;
        TimeEntryLine."From Time" := FromTime;
        TimeEntryLine."To Time" := ToTime;
        TimeEntryLine.Description := Description;
        TimeEntryLine.Activity := Activity;
        exit(TimeEntryLine.Insert(true));
    end;
}