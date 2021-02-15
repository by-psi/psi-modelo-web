unit md_login;

interface

uses
  Classes, SysUtils, Data.DB, FireDAC.Stan.Param,
  IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, Vcl.Controls, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompButton, IWCompEdit, IWHTMLTag {, UserSessionUnit};

type
  TF_login = class(TIWAppForm)
    template_login: TIWTemplateProcessorHTML;
    bt_login: TIWButton;
    ed_usuario: TIWEdit;
    ed_senha: TIWEdit;

    procedure bt_loginAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormShow(Sender: TObject);
    procedure ed_usuarioHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure ed_senhaHTMLTag(ASender: TObject; ATag: TIWHTMLTag);

  public

  end;

implementation

{$R *.dfm}

uses md_menu, ServerController, UserSessionUnit;

procedure TF_login.bt_loginAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  if Trim(ed_usuario.Text) = '' then
  begin
    WebApplication.ShowMessage('Favor preencher o campo USUÁRIO!');
    ed_usuario.SetFocus;
    exit;
  end;
  if Trim(ed_senha.Text) = '' then
  begin
    WebApplication.ShowMessage('Favor preencher o campo SENHA!');
    ed_senha.SetFocus;
    exit;
  end;

  with UserSession do
  begin
    if ed_senha.Text = '' then ed_senha.Text := 'NULL';
//  SELECT * FROM T_USUARIOS WHERE USUARIO = :USUARIO AND SENHA = PASSWORD(md5(:SENHA))
    query_login.Active := True;
    query_login.Close;
    query_login.ParamByName('USUARIO').AsString := ed_usuario.Text;
    query_login.ParamByName('SENHA').AsString := ed_senha.Text;
    query_login.Open;

		if query_login.IsEmpty then
    begin
      WebApplication.ShowMessage('Acesso negado! Usuário e/ou Senha não conferem.');
		end else
		begin
      USR_ID := query_login.FieldByName('ID').AsString;
      USRNAME  := UpperCase(query_login.FieldByName('NOME').AsString);
      USRFUNCTION  := UpperCase(query_login.FieldByName('FUNCAO').AsString);
      USRLEVEL  := UpperCase(query_login.FieldByName('NIVEL').AsString);
//    WebApplication.ShowMessage('USR: '+USRNAME+'<br> USR.FUNÇÃO: '+USRFUNCTION+'<br> USR.NÍVEL: '+USRLEVEL);
      TF_menu.Create(WebApplication).Show;
    end;
  end;

end;

procedure TF_login.ed_usuarioHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.AddStringParam('placeholder','Nome do Usuário');
end;

procedure TF_login.ed_senhaHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.AddStringParam('placeholder','Senha');
end;

procedure TF_login.IWAppFormShow(Sender: TObject);
begin
  ed_usuario.SetFocus;
end;

initialization
  TF_login.SetAsMainForm;

end.
