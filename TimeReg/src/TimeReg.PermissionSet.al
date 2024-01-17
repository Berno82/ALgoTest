///<summary>Permission set for using TimeReg</summary>
permissionset 75000 "BNO TimeReg"
{
    Assignable = true;
    Caption = 'TimeReg', MaxLength = 30;
    Permissions =
        table "BNO Time Entry" = X,
        table "BNO Time Entry Line" = X,
        tabledata "BNO Time Entry" = RMID,
        tabledata "BNO Time Entry Line" = RMID,
        tabledata "BNO TimeReg Setup" = RMID,
        tabledata "BNO Time Entry Archive" = RMID,
        tabledata "BNO Time Entry Line Archive" = RMID,
        tabledata "BNO Activity" = RMID,
        tabledata "BNO Time Entry Line Sorted" = RMID;
}