codeunit 75000 "BNO TimeReg Utillities"
{
    ///<summary>Get the last time registered for user</summary>
    procedure GetLastTime(UserName: Text) LastTime: Time
    var
        TimeEntryLine: Record "BNO Time Entry Line";
        TimeRegSetup: Record "BNO TimeReg Setup";
    begin
        TimeRegSetup.Get(UserName);
        if not TimeRegSetup.Pause then begin
            TimeEntryLine.SetRange(User, UserName);
            TimeEntryLine.SetRange(Date, Today());
            if TimeEntryLine.FindLast() then
                LastTime := TimeEntryLine."To Time"
            else
                LastTime := TimeRegSetup."Last Time";
        end else
            LastTime := TimeRegSetup."Last Time";

    end;

    ///<summary>Archive entries</summary>
    procedure ArchiveEntries()
    var
        TimeEntry: Record "BNO Time Entry";
        TimeEntryArchive: Record "BNO Time Entry Archive";
        TimeEntryLine: Record "BNO Time Entry Line";
        TimeEntryLineArchive: Record "BNO Time Entry Line Archive";
    begin
        if TimeEntry.FindSet() then
            repeat
                TimeEntryArchive.Init();
                TimeEntryArchive.TransferFields(TimeEntry);
                TimeEntryArchive.Insert(true);
            until TimeEntry.Next() = 0;

        if TimeEntryLine.FindSet() then
            repeat
                TimeEntryLineArchive.Init();
                TimeEntryLineArchive.TransferFields(TimeEntryLine);
                TimeEntryLineArchive.Insert(true)
            until TimeEntryLine.Next() = 0;
    end;
}
