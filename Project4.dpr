program Project4;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Airas.EQuery.Client in 'Airas.EQuery.Client.pas';

procedure test;
var
  lCli: TAirasQuery;
begin
  lCli := TAirasQuery.Create;
  lCli.Server := 'http://192.168.77.33:3219/';
  try
    lCli.GetOperators;
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
