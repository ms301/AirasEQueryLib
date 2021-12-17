unit Airas.EQuery.Client;

interface

uses
  CloudAPI.Request,
  CloudAPI.Response,
  CloudAPI.Client.Sync;

type
  TeqOperator = record
    Login, Name: string;
  end;

  TAirasQuery = class
  private
    FCli: TCloudApiClient;
    FServer: string;
    FPort: Word;
    function GetServer: string;
    procedure SetServer(const Value: string);
  public
    constructor Create;
    function GetOperators: TArray<TeqOperator>;
  public
    property Server: string read GetServer write SetServer;
  end;

implementation

uses
  Xml.XMLDoc, Xml.xmldom, Xml.XMLIntf, Xml.omnixmldom;
{ TAirasQuery }

constructor TAirasQuery.Create;
begin
  FCli := TCloudApiClient.Create;
end;

function TAirasQuery.GetOperators: TArray<TeqOperator>;
var
  lReq: IcaRequest;
  lRes: IcaResponseBase;
  lXml: TXMLDocument;
  RootNode: IXMLNode;
  lContent: string;
  i: integer;
begin
  lReq := TcaRequest.Create;
  lReq.AddQueryParameter('request_type', 'get_oper');
  lReq.AddQueryParameter('userid', '0');
  lReq.AddQueryParameter('session', '');
  lRes := FCli.Execute(lReq);
  lContent := lRes.HttpResponse.ContentAsString();
  Writeln(lContent);
  lXml := TXMLDocument.Create(nil);
  lXml.DOMImplementation := OmniXML4Factory.DOMImplementation;
  lXml.LoadFromXML(lContent);
  lXml.Active := True;

  RootNode := lXml.ChildNodes.FindNode('response');
  Writeln(lXml.ChildNodes.Count);
  // for i := 0 to RootNode.ChildNodes['response'].ChildNodes.Count - 1 do
  // Writeln(RootNode.ChildNodes['response'].ChildNodes[i].Text);
  Readln;
end;

function TAirasQuery.GetServer: string;
begin
  Result := FCli.BaseUrl;
end;

procedure TAirasQuery.SetServer(const Value: string);
begin
  FCli.BaseUrl := Value;
end;

end.
