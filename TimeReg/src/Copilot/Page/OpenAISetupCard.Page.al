page 75009 "BNO Open AI Setup Card"
{
    ApplicationArea = All;
    Caption = 'Open AI Setup Card';
    PageType = Card;
    // SourceTable = "BNO Open AI Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(Maxtokens; MaxTokens)
                {
                    ApplicationArea = All;
                    Caption = 'Max Tokens';
                    ToolTip = 'Specifies the maximum number of tokens to generate. Tokens are roughly equal to words. The default value is 64. The maximum value is 5000.';
                }
                field(MetaPrompt; MetaPrompt)
                {
                    ApplicationArea = All;
                    Caption = 'Meta Prompt';
                    MultiLine = true;

                    ToolTip = 'Specifies how the Open AI should behave, in generel terms, but a little specification is need to reduce unwanted results.';

                    trigger OnAssistEdit()
                    begin
                        ImportUserInput(MetaPrompt);
                    end;
                }
                field(Deployment; Deployment)
                {
                    Applicationarea = All;
                    Caption = 'Deployment';
                    ToolTip = 'Specifies the name of the deployment to use. This is the name of the deployment in the Azure Portal.';
                }
                field(Endpoint; Endpoint)
                {
                    Applicationarea = All;
                    Caption = 'Endpoint';
                    ToolTip = 'Specifies the name of the endpoint to use. This is the name of the endpoint in the Azure Portal.';
                }
                field(AzureOpenAIApiKey; AzureOpenAIApiKey)
                {
                    Applicationarea = All;
                    Caption = 'Azure Open AI Api Key';
                    ExtendedDatatype = Masked;
                    ToolTip = 'Specifies the Azure Open AI Api Key to use. This is the key in the Azure Portal.';
                }
                field(SystemMessage; SystemMessage)
                {
                    Applicationarea = All;
                    Caption = 'System Message';
                    ToolTip = 'Specifies the system message to show in the system message area.';

                    trigger OnAssistEdit()
                    begin
                        ImportUserInput(SystemMessage);
                    end;
                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(Save)
            {
                ApplicationArea = All;
                Caption = 'Save';
                Image = Save;
                ToolTip = 'Save the changes to the Open AI Setup';

                trigger OnAction()
                begin
                    if Evaluate(TestTokens, MaxTokens) then
                        IsolatedStorage.Set('MaxTokens', MaxTokens);
                    if MetaPrompt <> '' then
                        IsolatedStorage.Set('MetaPrompt', MetaPrompt);
                    if Deployment <> '' then
                        IsolatedStorage.Set('Deployment', Deployment);
                    if Endpoint <> '' then
                        IsolatedStorage.Set('Endpoint', Endpoint);
                    if AzureOpenAIApiKey <> '' then
                        IsolatedStorage.Set('AzureOpenAIApiKey', AzureOpenAIApiKey);
                    if SystemMessage <> '' then
                        if not IsolatedStorage.Get('SystemMessage1', SystemMessage1) or (SystemMessage1 = '') then
                            IsolatedStorage.Set('SystemMessage1', SystemMessage)
                        else
                            if not IsolatedStorage.Get('SystemMessage2', SystemMessage2) or (SystemMessage2 = '') then
                                IsolatedStorage.Set('SystemMessage2', SystemMessage)
                            else
                                if not IsolatedStorage.Get('SystemMessage3', SystemMessage3) or (SystemMessage3 = '') then
                                    IsolatedStorage.Set('SystemMessage3', SystemMessage);
                    // else
                    //     if not IsolatedStorage.Get('SystemMessage4', SystemMessage4) or (SystemMessage4 = '') then
                    //         IsolatedStorage.Set('SystemMessage4', SystemMessage);
                    ClearAll();
                end;
            }
            action(ShowSystemMessages)
            {
                ApplicationArea = All;
                Caption = 'Show System Messages';
                Image = Info;
                ToolTip = 'Show the system messages';

                trigger OnAction()
                begin
                    if IsolatedStorage.Get('SystemMessage1', SystemMessage1) then;
                    if IsolatedStorage.Get('SystemMessage2', SystemMessage2) then;
                    if IsolatedStorage.Get('SystemMessage3', SystemMessage3) then;
                    if IsolatedStorage.Get('SystemMessage4', SystemMessage4) then;
                    SystemMessage := SystemMessage1 + '\' + SystemMessage2 + '\' + SystemMessage3 + '\' + SystemMessage4;
                    Message(SystemMessage);
                    Clear(SystemMessage);
                end;
            }
            action(ShowValues)
            {
                ApplicationArea = All;
                Caption = 'Show Values';
                Image = Info;
                ToolTip = 'Show the Setup values';

                trigger OnAction()
                begin
                    GetValues();
                end;
            }
            action(ClearSystemMessage1)
            {
                ApplicationArea = All;
                Caption = 'Clear System Message 1';
                Image = Delete;
                ToolTip = 'Clear the system message 1';

                trigger OnAction()
                begin
                    IsolatedStorage.Set('SystemMessage1', '');
                end;
            }
            action(ClearSystemMessage2)
            {
                ApplicationArea = All;
                Caption = 'Clear System Message 2';
                Image = Delete;
                ToolTip = 'Clear the system message 2';

                trigger OnAction()
                begin
                    IsolatedStorage.Set('SystemMessage2', '');
                end;
            }
            action(ClearSystemMessage3)
            {
                ApplicationArea = All;
                Caption = 'Clear System Message 3';
                Image = Delete;
                ToolTip = 'Clear the system message 3';

                trigger OnAction()
                begin
                    IsolatedStorage.Set('SystemMessage3', '');
                end;
            }
            action(ClearSystemMessage4)
            {
                ApplicationArea = All;
                Caption = 'Clear System Message 4';
                Image = Delete;
                ToolTip = 'Clear the system message 4';

                trigger OnAction()
                begin
                    IsolatedStorage.Set('SystemMessage4', '');
                end;
            }
        }

        area(Promoted)
        {
            actionref(Save_ref; Save) { }
            actionref(ShowValues_ref; ShowValues) { }
            actionref(ShowSystemMessages_ref; ShowSystemMessages) { }
        }
    }
    var
        TestTokens: Integer;
        MaxTokens: Text;
        MetaPrompt: Text;
        Deployment: Text;
        Endpoint: Text;
        AzureOpenAIApiKey: Text;
        SystemMessage: Text;
        SystemMessage1: Text;
        SystemMessage2: Text;
        SystemMessage3: Text;
        SystemMessage4: Text;

    trigger OnOpenPage()
    begin
        if not IsolatedStorage.Get('MaxTokens', MaxTokens) then
            IsolatedStorage.Set('MaxTokens', '64');
    end;

    local procedure GetValues()
    begin
        if IsolatedStorage.Get('MetaPrompt', MetaPrompt) then;
        if IsolatedStorage.Get('Deployment', Deployment) then;
        if IsolatedStorage.Get('Endpoint', Endpoint) then;
        if IsolatedStorage.Get('MaxTokens', MaxTokens) then;
    end;

    local procedure ImportUserInput(var UserInput: Text)
    var
        InStr: InStream;
        Filename: Text;
        Buffer: Text;
    begin
        if UploadINtoStream('Select a file to upload', '', 'ALl files (*.*)|*.*', Filename, InStr) then
            if InStr.Length > 0 then
                while not InStr.EOS do begin
                    InStr.ReadText(Buffer);
                    UserInput := UserInput + ' ' + Buffer;
                end;
    end;
}
