codeunit 75000 "BNO TimeReg Utillities"
{
    ///<summary>Get the last time registered for user</summary>
    procedure GetLastTime() LastTime: Time
    var
        TimeEntryLine: Record "BNO Time Entry Line";
        TimeRegSetup: Record "BNO TimeReg Setup";
    begin
        TimeRegSetup.Get(UserId());
        if not TimeRegSetup.Pause then begin
            TimeEntryLine.SetRange(User, UserId());
            TimeEntryLine.SetRange(Date, Today());
            if TimeEntryLine.FindLast() then
                LastTime := TimeEntryLine."To Time"
            else
                LastTime := TimeRegSetup."Last Time";
        end else
            LastTime := TimeRegSetup."Last Time";

    end;

    procedure SetLastTime(LastTime: Time; Pause: Boolean)
    var
        TimeRegSetup: Record "BNO TimeReg Setup";
    begin
        TimeRegSetup.Get(UserId());
        TimeRegSetup.Pause := Pause;
        TimeRegSetup."Last Time" := Time();
        TimeRegSetup.Modify();
    end;

    ///<summary>Archive entries</summary>
    procedure ArchiveEntries()
    var
        TimeEntry: Record "BNO Time Entry";
        TimeEntryArchive: Record "BNO Time Entry Archive";
        TimeEntryLine: Record "BNO Time Entry Line";
        TimeEntryLineArchive: Record "BNO Time Entry Line Archive";
    begin
        TimeEntry.SetFilter(Date, '..%1', Today() - 1);
        TimeEntryLine.SetFilter(Date, '..%1', Today() - 1);
        if TimeEntry.FindSet() then begin
            if not TimeEntry.IsEmpty() then
                repeat
                    TimeEntryArchive.SetRange(User, TimeEntry.User);
                    TimeEntryArchive.SetRange(Date, TimeEntry.Date);
                    if TimeEntryArchive.IsEmpty() then begin
                        TimeEntryArchive.Init();
                        TimeEntryArchive.TransferFields(TimeEntry);
                        TimeEntryArchive.Insert(true);
                    end;
                    TimeEntryLine.SetRange(User, TimeEntry.User);
                    TimeEntryLine.SetRange(Date, TimeEntry.Date);
                    if not TimeEntryLine.IsEmpty() then
                        if TimeEntryLine.FindSet() then
                            repeat
                                TimeEntryLineArchive.Init();
                                TimeEntryLineArchive.TransferFields(TimeEntryLine);
                                if not TimeEntryLineArchive.Insert(true) then
                                    TimeEntryLineArchive.Modify();
                            until TimeEntryLine.Next() = 0;
                until TimeEntry.Next() = 0;
            TimeEntry.DeleteAll(true);
        end;
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
            UpdateConsumedTime(UserName, Date);

        end;
        TimeEntryLineArchive.SetRange(Paused, true);
        if TimeEntryLineArchive.FindSet() then begin
            TimeEntryLineSorted.SetRange(Paused, true);
            repeat
                if TimeEntryLineSorted.IsEmpty() then begin
                    TimeEntryLineSorted.Init();
                    TimeEntryLineSorted.TransferFields(TimeEntryLineArchive);
                    TimeEntryLineSorted.Description := 'Pause';
                    TimeEntryLineSorted.Insert();
                end else begin
                    TimeEntryLineSorted.FindFirst();
                    TimeEntryLineSorted."Registred Time" += TimeEntryLineArchive."Registred Time";
                    TimeEntryLineSorted."Registred Time Units" += TimeEntryLineArchive."Registred Time Units";
                    TimeEntryLineSorted.Modify();
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
        // PActivity: Record "BNO Activity";
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

            TimeEntryLine.SetRange(Paused, false);
            TimeEntryLine.FindSet();
            repeat
                TempTimeEntryLineArchive.SetRange(Activity, TimeEntryLine.Activity);
                TempTimeEntryLineArchive.SetRange(Description, TimeEntryLine.Description);
                TempTimeEntryLineArchive.SetRange(Paused, false);
                if not TempTimeEntryLineArchive.IsEmpty then begin
                    TempTimeEntryLineArchive.FindSet();
                    TempTimeEntryLineSorted.Init();
                    TempTimeEntryLineSorted.TransferFields(TempTimeEntryLineArchive);
                    // if PActivity.Get(UserName, TempTimeEntryLineSorted.Activity) then
                    //     if PActivity."Calculate Consumption" then begin
                    //         PActivity.CalcRemainingTime(PActivity);
                    //         // PActivity.CalcFields("Time Consumption", "Time Units Consumption");
                    //         // TempTimeEntryLineSorted."Remaining Time" := PActivity."Allowed Time Consumption" - PActivity."Time Consumption";
                    //         // TempTimeEntryLineSorted."Remaining Time Units" := PActivity."Allowed Time Units Consumption" - PActivity."Time Units Consumption";
                    //     end;
                    TempTimeEntryLineSorted.Insert();
                    if TempTimeEntryLineArchive.Count > 1 then begin
                        TempTimeEntryLineArchive.FindSet();
                        TempTimeEntryLineArchive.Next();
                        repeat
                            TempTimeEntryLineSorted."Registred Time" += TempTimeEntryLineArchive."Registred Time";
                            TempTimeEntryLineSorted."Registred Time Units" += TempTimeEntryLineArchive."Registred Time Units";
                            // if PActivity."Calculate Consumption" then begin
                            //     TempTimeEntryLineSorted."Remaining Time" -= TempTimeEntryLineArchive."Registred Time";
                            //     TempTimeEntryLineSorted."Remaining Time Units" -= TempTimeEntryLineArchive."Registred Time Units";
                            // end;
                            TempTimeEntryLineSorted.Modify();
                        until TempTimeEntryLineArchive.Next() = 0;
                    end;
                    TempTimeEntryLineArchive.DeleteAll();
                end;
            until TimeEntryLine.Next() = 0;

            TempTimeEntryLineArchive.SetRange(Activity);
            TempTimeEntryLineArchive.SetRange(Description);
            TempTimeEntryLineArchive.SetRange(Paused, true);
            if TempTimeEntryLineArchive.FindSet() then begin
                TempTimeEntryLineSorted.FindLast();
                TempTimeEntryLineSorted.SetRange(Paused, true);
                repeat
                    if TempTimeEntryLineSorted.IsEmpty() then begin
                        TempTimeEntryLineSorted.Init();
                        TempTimeEntryLineSorted.TransferFields(TempTimeEntryLineArchive);
                        TempTimeEntryLineSorted.Description := 'Pause';
                        TempTimeEntryLineSorted.Insert();
                    end else begin
                        TempTimeEntryLineSorted."Registred Time" += TempTimeEntryLineArchive."Registred Time";
                        TempTimeEntryLineSorted."Registred Time Units" += TempTimeEntryLineArchive."Registred Time Units";
                        TempTimeEntryLineSorted.Modify();
                    end;
                until TempTimeEntryLineArchive.Next() = 0;
                TempTimeEntryLineSorted.SetRange(Paused);
            end;
            Page.Run(Page::"BNO Sorted Lines", TempTimeEntryLineSorted);
        end;
    end;

    local procedure UpdateConsumedTime(UserName: Text[100]; Date: Date)
    var
        TimeEntryLineSorted: Record "BNO Time Entry Line Sorted";
        Pactivity: Record "BNO Activity";
    begin
        TimeEntryLineSorted.SetRange(User, UserName);
        TimeEntryLineSorted.SetRange(Date, Date);
        if TimeEntryLineSorted.FindSet() then
            repeat
                Pactivity.Get(TimeEntryLineSorted.User, TimeEntryLineSorted.Activity);
                if TimeEntryLineSorted.Activity <> '' then
                    if Pactivity."Calculate Consumption" then begin
                        TimeEntryLineSorted."Remaining Time" := Pactivity."Allowed Time Consumption" - Pactivity."Time Consumption";
                        TimeEntryLineSorted."Remaining Time Units" := Pactivity."Allowed Time Units Consumption" - Pactivity."Time Units Consumption";
                        TimeEntryLineSorted.Modify();
                    end;


            until TimeEntryLineSorted.Next() = 0;
    end;
}