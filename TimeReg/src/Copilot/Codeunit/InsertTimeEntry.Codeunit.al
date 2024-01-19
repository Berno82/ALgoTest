codeunit 75002 "BNO Insert Time Entry"
{
    ///<summary>Inserts Time ENtry line from Copilot example</summary>
    procedure InsertTimeEntry(TempTimeEntryLine: Record "BNO Time Entry Line" temporary): Boolean;
    var
        TimeEntryLine: Record "BNO Time Entry Line";
    begin
        TimeEntryLine.User := TempTimeEntryLine.User;
        TimeEntryLine."Date" := TempTimeEntryLine.Date;
        TimeEntryLine."From Time" := TempTimeEntryLine."From Time";
        TimeEntryLine."To Time" := TempTimeEntryLine."To Time";
        TimeEntryLine.Description := TempTimeEntryLine.Description;
        TimeEntryLine.Activity := TempTimeEntryLine.Activity;
        exit(TimeEntryLine.Insert(true));
    end;

    procedure GenerateTimeEntries(Prompt: Text): Text
    var
        AzureOpenAI: Codeunit "Azure OpenAI";
        AOAIOperationResponse: Codeunit "AOAI Operation Response";
        AOAIChatCompletionParameters: Codeunit "AOAI Chat Completion Params";
        AOAIChatMessages: Codeunit "AOAI Chat Messages";
        // MetaPrompt: Text;
        Result: Text;
    begin
        SetAuthorization(AzureOpenAI);
        SetParameters(AOAIChatCompletionParameters);

        AzureOpenAI.SetCopilotCapability(Enum::"Copilot Capability"::"Create Time Entry Line");
        // IsolatedStorage.Get('MetaPrompt', MetaPrompt);
        // AOAIChatMessages.SetPrimarySystemMessage(MetaPrompt);
        AOAIChatMessages.AddUserMessage(Prompt);

        AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParameters, AOAIOperationResponse);

        if AOAIOperationResponse.IsSuccess() then
            Result := AOAIChatMessages.GetLastMessage();
    end;

    [NonDebuggable]
    local procedure SetAuthorization(var AzureOpenAI: Codeunit "Azure OpenAI")
    var
        Endpoint: Text;
        Deployment: Text;
        ApiKey: Text;
    begin
        ApiKey := 'a6f44b2500094cb89431b2924c22d738';
        IsolatedStorage.Get('https://time.openai.azure.com/', Endpoint);
        IsolatedStorage.Get('TimeReg', Deployment);
        IsolatedStorage.Get('AzureOpenAIApiKey', ApiKey);
        AzureOpenAI.SetAuthorization(Enum::"AOAI Model Type"::"Chat Completions", Endpoint, Deployment, ApiKey);
    end;

    local procedure SetParameters(var AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params")
    begin
        AOAIChatCompletionParams.SetMaxTokens(50);
        AOAIChatCompletionParams.SetTemperature(0);
    end;

}