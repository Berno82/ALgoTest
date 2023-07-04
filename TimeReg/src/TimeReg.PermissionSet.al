permissionset 75000 "BNO TimeReg"
{
    Assignable = true;
    Caption = 'TimeReg', MaxLength = 30;
    Permissions =
        table "BNO Time Entry" = X,
        table "BNO Time Entry Line" = X,
        tabledata "BNO Time Entry" = RMID,
        tabledata "BNO Time Entry Line" = RMID;
}