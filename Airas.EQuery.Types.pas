unit Airas.EQuery.Types;

interface

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

implementation

{ TeqOperator }

class function TeqOperator.Create(const ALogin, AName: string): TeqOperator;
begin
  Result.Login := ALogin;
  Result.Name := AName;
end;

end.
