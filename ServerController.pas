unit ServerController;

interface

uses
  SysUtils, Classes, IWServerControllerBase, IWBaseForm, HTTPApp,
  // For OnNewSession Event
  UserSessionUnit, IWApplication, IWAppForm, IW.Browser.Browser, 
  IW.HTTP.Request, IW.HTTP.Reply, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  TF_server = class(TIWServerControllerBase)
    procedure IWServerControllerBaseNewSession(ASession: TIWApplication);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function UserSession: TF_session;
  function F_server: TF_server;
  function Extract_N(var S: String): String;
  function Insert_R(var s: string; T: integer; chr: Char): string;
  function Insert_L(var s: string; T: integer; chr: Char): string;

implementation

{$R *.dfm}

uses
  IWInit, IWGlobal;

function UserSession: TF_session;
begin
  Result := TF_session(WebApplication.Data);
end;

function F_server: TF_server;
begin
  Result := TF_server(GServerController);
end;

function Extract_N(var S: String): String;
var
  i: Integer;
begin
  for i := 1 to Length(S) do
  if (ANSIChar(S[1]) in ['0'..'9']) then
  Result := Result + S[i];
end;

function Insert_R(var s: string; T: integer; chr: Char): string;
begin
  while Length(s)<T do s := s + chr;
  Result := s;
end;

function Insert_L(var s: string; T: integer; chr: Char): string;
begin
  while Length(s)<T do s := chr + s;
  Result := s;
end;

{ TIWServerController }

procedure TF_server.IWServerControllerBaseNewSession(
  ASession: TIWApplication);
begin
  ASession.Data := TF_session.Create(nil, ASession);
end;

initialization
  TF_server.SetServerControllerClass;

end.

