unit Airas.EQuery.Client;

interface

uses
  CloudAPI.Request,
  CloudAPI.Response,
  CloudAPI.Client.Sync;

type
  TeqOperator = record
    Login, Name: string;
    class function Create(const ALogin, AName: string): TeqOperator; static;
  end;

  TeqOperatorAuth = record
    orgid: string;
    userid: string;
    operid: string;
    firstname: string;
    lastname: string;
    patronymic: string;
    usertype: string;
    sessionid: string;
  end;

  TeqParamEQueryOper = record
    allAllClients: string;
    allClients: string;
    near: string;
    next: string;
    server_time: string;
  end;

  TeqOperCall = record
    equery_num: string;
    clientid: string;
    fio: string;
    platname: string;
    phone: string;
    time_start: string;
    time_end: string;
  end;

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
        lList.Add(TeqOperator.Create(lNode.Attributes['login'], lNode.Attributes['name']));
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
        lCall.equery_num := lNode.Attributes['equery_num'];
        lCall.clientid := lNode.Attributes['clientid'];
        lCall.fio := lNode.Attributes['fio'];
        lCall.platname := lNode.Attributes['platname'];
        lCall.phone := lNode.Attributes['phone'];
        lCall.time_start := lNode.Attributes['time_start'];
        lCall.time_end := lNode.Attributes['time_end'];
        lList.Add(lCall);
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
      begin
        Result.allAllClients := lNode.Attributes['allAllClients'];
        Result.allClients := lNode.Attributes['allClients'];
        Result.near := lNode.Attributes['near'];
        Result.next := lNode.Attributes['next'];
        Result.server_time := lNode.Attributes['server_time'];
      end;
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
      begin
        Result.orgid := lNode.Attributes['orgid'];
        Result.userid := lNode.Attributes['userid'];
        Result.operid := lNode.Attributes['operid'];
        Result.firstname := lNode.Attributes['firstname'];
        Result.lastname := lNode.Attributes['lastname'];
        Result.patronymic := lNode.Attributes['patronymic'];
        Result.usertype := lNode.Attributes['usertype'];
        Result.sessionid := lNode.Attributes['sessionid'];
      end;
    end;
  finally
    LDocument := nil;
  end;
end;

{ TeqOperator }

class function TeqOperator.Create(const ALogin, AName: string): TeqOperator;
begin
  Result.Login := ALogin;
  Result.Name := AName;
end;

end.
