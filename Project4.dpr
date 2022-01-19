program Project4;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Airas.EQuery.Client in 'Airas.EQuery.Client.pas',
  Airas.EQuery.Types;

procedure test;
var
  lCli: TAirasQuery;
  lOper: TeqOperator;
  lAuth: TeqOperatorAuth;
  lOperCallList: TArray<TeqOperCall>;
begin
  lCli := TAirasQuery.Create;
  lCli.Server := 'http://192.168.77.33:3219/';
  try
    for lOper in lCli.GetOperators do
      Writeln(lOper.Name + ' - ' + lOper.Login);
    lAuth := lCli.UserCheck(lOper.Login);
    Writeln('Клиентов в очереди: ', lCli.ShowParamEqueryOper(lAuth).allAllClients);
    lOperCallList := lCli.GetOperCallList(lAuth);
    for var lCall in lOperCallList do
      Writeln(lCall.equery_num + ' ' + lCall.fio + ' ' + lCall.time_start + ' ' + lCall.time_end);

  finally
    lCli.Free;
  end;
end;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    test;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;

end.
