unit Airas.EQuery.Types;

interface

uses
  Xml.XMLIntf;

type
  TeqOperator = record
  public
    Login, Name: string;
    class function Create(const ALogin, AName: string): TeqOperator; static;
    class function FromXmlNode(ANode: IXMLNode): TeqOperator; static;
  end;

  TeqOperatorAuth = record
  public
    orgid: string;
    userid: string;
    operid: string;
    firstname: string;
    lastname: string;
    patronymic: string;
    usertype: string;
    sessionid: string;
    class function FromXmlNode(ANode: IXMLNode): TeqOperatorAuth; static;
  end;

  TeqParamEQueryOper = record
  public
    allAllClients: string;
    allClients: string;
    near: string;
    next: string;
    server_time: string;
    class function FromXmlNode(ANode: IXMLNode): TeqParamEQueryOper; static;
  end;

  TeqUserInQueue = record
  public
    status: string;
    operid: string;
    opername: string;
    clientid: string;
    time_start: string;
    time_end: string;
    time_want: string;
    equery_num: string;
    room: string;
    docstateid: string;
    docstate: string;
    fio: string;
    phone: string;
    platname: string;
    server_time: string;
    class function FromXmlNode(ANode: IXMLNode): TeqUserInQueue; static;
  end;

  TeqOperCall = record
  public
    equery_num: string;
    clientid: string;
    fio: string;
    platname: string;
    phone: string;
    time_start: string;
    time_end: string;
    Users: TArray<TeqUserInQueue>;
    class function FromXmlNode(ANode: IXMLNode): TeqOperCall; static;
  end;

implementation

{ TeqOperator }

class function TeqOperator.Create(const ALogin, AName: string): TeqOperator;
begin
  Result.Login := ALogin;
  Result.Name := AName;
end;

class function TeqOperator.FromXmlNode(ANode: IXMLNode): TeqOperator;
begin
  Result := TeqOperator.Create(ANode.Attributes['login'], ANode.Attributes['name']);
end;

{ TeqOperCall }

class function TeqOperCall.FromXmlNode(ANode: IXMLNode): TeqOperCall;
begin
  Result.equery_num := ANode.Attributes['equery_num'];
  Result.clientid := ANode.Attributes['clientid'];
  Result.fio := ANode.Attributes['fio'];
  Result.platname := ANode.Attributes['platname'];
  Result.phone := ANode.Attributes['phone'];
  Result.time_start := ANode.Attributes['time_start'];
  Result.time_end := ANode.Attributes['time_end'];
end;

{ TeqParamEQueryOper }

class function TeqParamEQueryOper.FromXmlNode(ANode: IXMLNode): TeqParamEQueryOper;
begin
  Result.allAllClients := ANode.Attributes['allAllClients'];
  Result.allClients := ANode.Attributes['allClients'];
  Result.near := ANode.Attributes['near'];
  Result.next := ANode.Attributes['next'];
  Result.server_time := ANode.Attributes['server_time'];
end;

{ TeqOperatorAuth }

class function TeqOperatorAuth.FromXmlNode(ANode: IXMLNode): TeqOperatorAuth;
begin
  Result.orgid := ANode.Attributes['orgid'];
  Result.userid := ANode.Attributes['userid'];
  Result.operid := ANode.Attributes['operid'];
  Result.firstname := ANode.Attributes['firstname'];
  Result.lastname := ANode.Attributes['lastname'];
  Result.patronymic := ANode.Attributes['patronymic'];
  Result.usertype := ANode.Attributes['usertype'];
  Result.sessionid := ANode.Attributes['sessionid'];
end;

end.
