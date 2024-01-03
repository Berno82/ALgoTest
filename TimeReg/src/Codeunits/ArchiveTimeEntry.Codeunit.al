codeunit 75001 "BNO Archive Time Entry"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        JobQueueLogEntry: Record "Job Queue Log Entry";
        TimeRegUtillities: Codeunit "BNO TimeReg Utillities";
    begin
        Rec.InsertLogEntry(JobQueueLogEntry);
        TimeRegUtillities.ArchiveEntries();
        Rec.FinalizeLogEntry(JobQueueLogEntry);
    end;

}
