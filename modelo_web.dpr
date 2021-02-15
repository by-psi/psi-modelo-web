program modelo_web;

uses
  IWRtlFix,
  IWJclStackTrace,
  IWJclDebug,
  Forms,
  IWStart,
  ServerController in 'ServerController.pas' {F_server: TIWServerControllerBase},
  UserSessionUnit in 'UserSessionUnit.pas' {F_session: TIWUserSessionBase},
  md_login in 'md_login.pas' {F_login: TIWAppForm},
  md_menu in 'md_menu.pas' {F_menu: TIWAppForm},
  md_usuarios in 'md_usuarios.pas' {F_usuarios: TIWAppForm},
  md_fornecedores in 'md_fornecedores.pas' {F_fornecedores: TIWAppForm},
  md_produtos in 'md_produtos.pas' {F_produtos: TIWAppForm},
  md_vendas in 'md_vendas.pas' {F_vendas: TIWAppForm},
  md_lancamentos in 'md_lancamentos.pas' {F_lancamentos: TIWAppForm};

{$R *.res}

begin
  TIWStart.Execute(True);
end.
