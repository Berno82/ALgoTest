codeunit 75002 "BNO Copilot Generation"
{
    var
        MaxTokensSet: Integer;
    ///<summary>Inserts Time ENtry line from Copilot example</summary>
    procedure InsertTimeEntry(TempTimeEntryLine: Record "BNO Time Entry Line" temporary)
    var
        TimeEntryLine: Record "BNO Time Entry Line";
    begin
        TimeEntryLine.User := TempTimeEntryLine.User;
        TimeEntryLine."Date" := TempTimeEntryLine.Date;
        TimeEntryLine."From Time" := TempTimeEntryLine."From Time";
        TimeEntryLine."To Time" := TempTimeEntryLine."To Time";
        TimeEntryLine.Description := TempTimeEntryLine.Description;
        TimeEntryLine.Activity := TempTimeEntryLine.Activity;
        TimeEntryLine.Insert(true);
    end;

    procedure InsertTimeEntryArchive(TempTimeEntryLineArchive: Record "BNO Time Entry Line" temporary)
    var
        TimeEntryLineArchive: Record "BNO Time Entry Line Archive";
        TimeEntryArchive: Record "BNO Time Entry Archive";
    begin
        if not TimeEntryArchive.Get(TempTimeEntryLineArchive.User, TempTimeEntryLineArchive.Date) then begin
            TimeEntryArchive.User := TempTimeEntryLineArchive.User;
            TimeEntryArchive."Date" := TempTimeEntryLineArchive.Date;
            TimeEntryArchive.Insert(true);
        end;
        TimeEntryLineArchive.User := TempTimeEntryLineArchive.User;
        TimeEntryLineArchive."Date" := TempTimeEntryLineArchive.Date;
        TimeEntryLineArchive."From Time" := TempTimeEntryLineArchive."From Time";
        TimeEntryLineArchive."To Time" := TempTimeEntryLineArchive."To Time";
        TimeEntryLineArchive.Description := TempTimeEntryLineArchive.Description;
        TimeEntryLineArchive.Activity := TempTimeEntryLineArchive.Activity;
        TimeEntryLineArchive.Insert(true);
    end;

    procedure GenerateTimeEntries(Prompt: Text): Text
    var
        AzureOpenAI: Codeunit "Azure OpenAI";
        AOAIOperationResponse: Codeunit "AOAI Operation Response";
        AOAIChatCompletionParameters: Codeunit "AOAI Chat Completion Params";
        AOAIChatMessages: Codeunit "AOAI Chat Messages";
        CompletePromtTokenCount: Integer;
        MetaPrompt: Text;
        Result: Text;
    begin
        SetAuthorization(AzureOpenAI);
        SetParameters(AOAIChatCompletionParameters);

        AzureOpenAI.SetCopilotCapability(Enum::"Copilot Capability"::"Create Time Entry Line");
        IsolatedStorage.Get('MetaPrompt', MetaPrompt);
        AOAIChatMessages.SetPrimarySystemMessage(MetaPrompt);
        AddSystemMessages(AOAIChatMessages);
        AOAIChatMessages.AddUserMessage(Prompt);

        CompletePromtTokenCount := PreciseTokenCount(MetaPrompt + Prompt);
        if CompletePromtTokenCount <= MaxTokensSet then
            AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParameters, AOAIOperationResponse);

        if AOAIOperationResponse.IsSuccess() then
            Result := AOAIChatMessages.GetLastMessage()
        else
            Result := AOAIOperationResponse.GetError();
        exit(Result);

    end;

    local procedure SetAuthorization(var AzureOpenAI: Codeunit "Azure OpenAI")
    var
        Endpoint: Text;
        Deployment: Text;
        [NonDebuggable]
        ApiKey: Text;
    begin
        IsolatedStorage.Get('Endpoint', Endpoint);
        IsolatedStorage.Get('Deployment', Deployment);
        IsolatedStorage.Get('AzureOpenAIApiKey', ApiKey);
        AzureOpenAI.SetAuthorization(Enum::"AOAI Model Type"::"Chat Completions", Endpoint, Deployment, ApiKey);
    end;

    local procedure SetParameters(var AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params")
    begin
        MaxTokens();
        AOAIChatCompletionParams.SetMaxTokens(MaxTokensSet);
        AOAIChatCompletionParams.SetTemperature(0);
    end;

    local procedure PreciseTokenCount(Input: Text): Integer
    var
        RestClient: Codeunit "Rest Client";
        Content: Codeunit "Http Content";
        JContent: JsonObject;
        JTokenCount: JsonToken;
        UriTxt: Label 'https://azure-openai-tokenizer.azurewebsites.net/api/tokensCount', Locked = true;
    begin
        JContent.Add('text', Input);
        Content.Create(JContent);
        RestClient.Send("Http Method"::GET, UriTxt, Content).GetContent().AsJson().AsObject().Get('tokensCount', JTokenCount);
        exit(JTokenCount.AsValue().AsInteger());
    end;

    local procedure AddSystemMessages(var AOAIChatMessages: Codeunit System.AI."AOAI Chat Messages")
    var
        Example: Text;
    begin
        if IsolatedStorage.Get('SystemMessage1', Example) then
            AOAIChatMessages.AddSystemMessage(Example);
        if IsolatedStorage.Get('SystemMessage2', Example) then
            AOAIChatMessages.AddSystemMessage(Example);
        if IsolatedStorage.Get('SystemMessage3', Example) then
            AOAIChatMessages.AddSystemMessage(Example);
        Example := 'todays date in format "yyyy-mm-dd" is ' + Format(Today(), 9);
        AOAIChatMessages.AddSystemMessage(Example);
    end;

    local procedure MaxTokens()
    var
        ResultTxt: Text;
    begin
        if IsolatedStorage.Get('MaxTokens', ResultTxt) then
            Evaluate(MaxTokensSet, ResultTxt)
        else
            MaxTokensSet := 1000;
    end;
}