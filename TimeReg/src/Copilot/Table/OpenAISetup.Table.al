table 75007 "BNO Open AI Setup"
{
    Caption = 'BNO Open AI Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; MetaPrompt; Blob)
        {
            Caption = 'MetaPrompt';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    procedure SetMetaPrompt(NewMetaPrompt: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Rec.MetaPrompt);
        Rec.MetaPrompt.CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewMetaPrompt);
        Rec.Modify();
    end;

    procedure GetMetaPrompt() MetaPrompt: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields(Rec.MetaPrompt);
        Rec.MetaPrompt.CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName(Rec.MetaPrompt)));
    end;
}
