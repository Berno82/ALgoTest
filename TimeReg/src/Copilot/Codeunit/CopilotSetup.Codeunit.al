codeunit 75003 "BNO Copilot Setup"
{
    Subtype = Install;
    InherentEntitlements = X;
    InherentPermissions = X;
    Access = Internal;

    trigger OnInstallAppPerDatabase()
    begin
        RegisterCapability()
    end;

    local procedure RegisterCapability()
    var
        CopilotCapability: Codeunit "Copilot Capability";
        EnvironmentInformation: Codeunit "Environment Information";
        LearnMoreUrlTxt: Label 'Test Copilot for TIme registration', Locked = true;
    begin
        if EnvironmentInformation.IsSaaS() then
            if not CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"Create Time Entry Line") then
                CopilotCapability.RegisterCapability(Enum::"Copilot Capability"::"Create Time Entry Line", Enum::"Copilot Availability"::"Generally Available", LearnMoreUrlTxt);
    end;


}
