codeunit 75000 "BNO TimeReg Utillities"
{
    ///<summary>Get the last time registered for user</summary>
    procedure GetLastTime(UserName: Text[100]) LastTime: Time
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

    procedure SumLines(UserName: Text[100]; Date: Date)
    var
        TempTimeEntryLineArchive: Record "BNO Time Entry Line Archive" temporary;
        TimeEntryLineArchive: Record "BNO Time Entry Line Archive";
        TimeEntryLineSorted: Record "BNO Time Entry Line Sorted";
        TimeEntryArchive: Record "BNO Time Entry Archive";
        NoLinesErr: Label 'No Time entry lines found';
    begin
        TimeEntryLineArchive.SetRange(User, UserName);
        TimeEntryLineArchive.SetRange(Date, Date);
        if TimeEntryLineArchive.IsEmpty then
            Error(NoLinesErr)
        else begin
            TimeEntryLineArchive.FindSet();
            repeat
                TempTimeEntryLineArchive.Init();
                TempTimeEntryLineArchive.TransferFields(TimeEntryLineArchive);
                TempTimeEntryLineArchive.Insert();
            until TimeEntryLineArchive.Next() = 0;

            TimeEntryLineArchive.FindSet();
            repeat
                TempTimeEntryLineArchive.SetRange(Activity, TimeEntryLineArchive.Activity);
                TempTimeEntryLineArchive.SetRange(Description, TimeEntryLineArchive.Description);
                if not TempTimeEntryLineArchive.IsEmpty() then begin
                    TempTimeEntryLineArchive.FindSet();
                    TimeEntryLineSorted.Init();
                    TimeEntryLineSorted.TransferFields(TempTimeEntryLineArchive);
                    TimeEntryLineSorted.Insert();
                    if TempTimeEntryLineArchive.Count > 1 then begin
                        TempTimeEntryLineArchive.FindSet();
                        repeat
                            TimeEntryLineSorted."Registred Time" += TempTimeEntryLineArchive."Registred Time";
                            TimeEntryLineSorted."Registred Time Units" += TempTimeEntryLineArchive."Registred Time Units";
                            TimeEntryLineSorted.Modify();
                        until TempTimeEntryLineArchive.Next() = 0;
                    end;
                    TempTimeEntryLineArchive.DeleteAll();
                end;
            until TimeEntryLineArchive.Next() = 0;

        end;
        TimeEntryArchive.Get(UserName, Date);
        TimeEntryArchive.Sorted := true;
        TimeEntryArchive.Modify();
    end;

    ///<summary>Sort Current time entries and display</summary>
    procedure SumCurrentLines(UserName: Text[100]; Date: Date)
    var
        TempTimeEntryLineArchive: Record "BNO Time Entry Line Archive" temporary;
        TempTimeEntryLineSorted: Record "BNO Time Entry Line Sorted" temporary;
        TimeEntryLine: Record "BNO Time Entry Line";
        NoLinesErr: Label 'No Time entry lines found';
    begin

        TimeEntryLine.SetRange(User, UserName);
        TimeEntryLine.SetRange(Date, Date);
        if TimeEntryLine.IsEmpty then
            Error(NoLinesErr)
        else begin

            TimeEntryLine.FindSet();
            repeat
                TempTimeEntryLineArchive.Init();
                TempTimeEntryLineArchive.TransferFields(TimeEntryLine);
                TempTimeEntryLineArchive.Insert();
            until TimeEntryLine.Next() = 0;

            TimeEntryLine.FindSet();
            repeat
                TempTimeEntryLineArchive.SetRange(Activity, TimeEntryLine.Activity);
                TempTimeEntryLineArchive.SetRange(Description, TimeEntryLine.Description);
                if not TempTimeEntryLineArchive.IsEmpty then begin
                    TempTimeEntryLineArchive.FindSet();
                    TempTimeEntryLineSorted.Init();
                    TempTimeEntryLineSorted.TransferFields(TempTimeEntryLineArchive);
                    TempTimeEntryLineSorted.Insert();
                    if TempTimeEntryLineArchive.Count > 1 then begin
                        TempTimeEntryLineArchive.FindSet();
                        TempTimeEntryLineArchive.Next();
                        repeat
                            TempTimeEntryLineSorted."Registred Time" += TempTimeEntryLineArchive."Registred Time";
                            TempTimeEntryLineSorted."Registred Time Units" += TempTimeEntryLineArchive."Registred Time Units";
                            TempTimeEntryLineSorted.Modify();
                        until TempTimeEntryLineArchive.Next() = 0;
                    end;
                    TempTimeEntryLineArchive.DeleteAll();
                end;
            until TimeEntryLine.Next() = 0;

            Page.Run(Page::"BNO Sorted Lines", TempTimeEntryLineSorted);

        end;

    end;
}
