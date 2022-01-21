unit Airas.EQuery.Client;

interface

uses
  CloudAPI.Request,
  CloudAPI.Response,
  CloudAPI.Client.Sync,
  Airas.EQuery.Types;

type
  TAirasQuery = class
  private
    FCli: TCloudApiClient;
    function GetServer: string;
    procedure SetServer(const Value: string);
  public
    constructor Create;
    function GetOperators: TArray<TeqOperator>;
    function UserCheck(const ALogin: string; const APassword: string = 'zerro_pass'): TeqOperatorAuth;
    function ShowParamEqueryOper(AAuthInfo: TeqOperatorAuth): TeqParamEQueryOper;
    function GetOperCallList(AAuthInfo: TeqOperatorAuth): TArray<TeqOperCall>;
  public
    property Server: string read GetServer write SetServer;
  end;

implementation

uses
  Xml.XMLDoc,
  Xml.xmldom,
  Xml.XMLIntf,
  Xml.omnixmldom,
  System.SysUtils,
  System.Generics.Collections;
{ TAirasQuery }

constructor TAirasQuery.Create;
begin
  FCli := TCloudApiClient.Create;
end;

function TAirasQuery.GetOperators: TArray<TeqOperator>;
var
  lReq: IcaRequest;
  lRes: IcaResponseBase;
  lContent: string;
var
  LDocument: IXMLDocument;
  lNode: IXMLNode;
  i: integer;
var
  lList: TList<TeqOperator>;
begin
  lReq := TcaRequest.Create;
  lReq.AddQueryParameter('request_type', 'get_oper');
  lReq.AddQueryParameter('userid', '0');
  lReq.AddQueryParameter('session', '');
  lRes := FCli.Execute(lReq);
  lContent := lRes.HttpResponse.ContentAsString();
  //
  LDocument := TXMLDocument.Create(nil);
  lList := TList<TeqOperator>.Create;
  try
    (LDocument as TXMLDocument).DOMVendor := DOMVendors.Find('Omni XML');
    LDocument.LoadFromXML(lContent);
    for i := 0 to LDocument.ChildNodes.FindNode('response').ChildNodes.Count - 1 do
    begin
      lNode := LDocument.ChildNodes.FindNode('response').ChildNodes[i];
      if lNode.HasAttribute('name') and lNode.HasAttribute('login') then
        lList.Add(TeqOperator.FromXmlNode(lNode));
    end;
    Result := lList.ToArray;
  finally
    LDocument := nil;
    lList.Free;
  end;
end;

function TAirasQuery.GetOperCallList(AAuthInfo: TeqOperatorAuth): TArray<TeqOperCall>;
var
  lReq: IcaRequest;
  lRes: IcaResponseBase;
  lContent: string;
var
  LDocument: IXMLDocument;
  lNode: IXMLNode;
  i: integer;
var
  lCall: TeqOperCall;
  lList: TList<TeqOperCall>;
begin
  lReq := TcaRequest.Create;
  lReq.AddQueryParameter('request_type', 'get_oper_call_list');
  lReq.AddQueryParameter('userid', AAuthInfo.userid);
  lReq.AddQueryParameter('session', AAuthInfo.sessionid);
  lRes := FCli.Execute(lReq);
  lContent := lRes.HttpResponse.ContentAsString();
  //
  LDocument := TXMLDocument.Create(nil);
  lList := TList<TeqOperCall>.Create;
  try
    (LDocument as TXMLDocument).DOMVendor := DOMVendors.Find('Omni XML');
    LDocument.LoadFromXML(lContent);
    for i := 0 to LDocument.ChildNodes.FindNode('response').ChildNodes.Count - 1 do
    begin
      lNode := LDocument.ChildNodes.FindNode('response').ChildNodes[i];
      if lNode.HasAttribute('equery_num') and lNode.HasAttribute('clientid') then
      begin
        lList.Add(TeqOperCall.FromXmlNode(lNode));
      end;
    end;
    Result := lList.ToArray;
  finally
    LDocument := nil;
    lList.Free;
  end;
end;

function TAirasQuery.GetServer: string;
begin
  Result := FCli.BaseUrl;
end;

procedure TAirasQuery.SetServer(const Value: string);
begin
  FCli.BaseUrl := Value;
end;

function TAirasQuery.ShowParamEqueryOper(AAuthInfo: TeqOperatorAuth): TeqParamEQueryOper;
var
  lReq: IcaRequest;
  lRes: IcaResponseBase;
  lContent: string;
var
  LDocument: IXMLDocument;
  lNode: IXMLNode;
  i: integer;
begin
  lReq := TcaRequest.Create;
  lReq.AddQueryParameter('request_type', 'show_param_equery_oper');
  lReq.AddQueryParameter('isold', '1');
  lReq.AddQueryParameter('operid', AAuthInfo.operid);
  lReq.AddQueryParameter('userid', AAuthInfo.userid);
  lReq.AddQueryParameter('session', AAuthInfo.sessionid);
  lRes := FCli.Execute(lReq);
  lContent := lRes.HttpResponse.ContentAsString();
  //
  LDocument := TXMLDocument.Create(nil);
  try
    (LDocument as TXMLDocument).DOMVendor := DOMVendors.Find('Omni XML');
    LDocument.LoadFromXML(lContent);
    for i := 0 to LDocument.ChildNodes.FindNode('response').ChildNodes.Count - 1 do
    begin
      lNode := LDocument.ChildNodes.FindNode('response').ChildNodes[i];
      if lNode.HasAttribute('allClients') then
        Result := TeqParamEQueryOper.FromXmlNode(lNode);
      if lNode.HasAttribute('equery_num') then
        Result.Users := Result.Users + [TeqUserInQueue.FromXmlNode(lNode)];
    end;
  finally
    LDocument := nil;
  end;
end;

function TAirasQuery.UserCheck(const ALogin, APassword: string): TeqOperatorAuth;
var
  lReq: IcaRequest;
  lRes: IcaResponseBase;
  lContent: string;
var
  LDocument: IXMLDocument;
  lNode: IXMLNode;
  i: integer;
begin
  lReq := TcaRequest.Create;
  lReq.AddQueryParameter('request_type', 'user_ckeck');
  lReq.AddQueryParameter('login', ALogin);
  lReq.AddQueryParameter('password', APassword);
  lRes := FCli.Execute(lReq);
  lContent := lRes.HttpResponse.ContentAsString();
  //
  LDocument := TXMLDocument.Create(nil);
  try
    (LDocument as TXMLDocument).DOMVendor := DOMVendors.Find('Omni XML');
    LDocument.LoadFromXML(lContent);
    for i := 0 to LDocument.ChildNodes.FindNode('response').ChildNodes.Count - 1 do
    begin
      lNode := LDocument.ChildNodes.FindNode('response').ChildNodes[i];
      if lNode.HasAttribute('sessionid') then
        Result := TeqOperatorAuth.FromXmlNode(lNode);
    end;
  finally
    LDocument := nil;
  end;
end;

end.
