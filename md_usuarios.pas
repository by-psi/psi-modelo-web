unit md_usuarios;

interface

uses
  Classes, SysUtils, FireDAC.Stan.Param,
  IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, Vcl.Controls, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWHTMLControls, IWCompEdit, IWCompButton,
  Data.DB, IWCompListbox, IWCompGrids, IWDBGrids, IWCompExtCtrls, IWCompLabel;

type
  TF_usuarios = class(TIWAppForm)
    template_usuarios: TIWTemplateProcessorHTML;
    link_home: TIWLink;
    m_usuarios: TIWLink;
    bt_incluir: TIWButton;
    bt_editar: TIWButton;
    bt_excluir: TIWButton;
    bt_ok: TIWButton;
    bt_cancelar: TIWButton;
    ed_nome: TIWEdit;
    ed_id: TIWEdit;
    ed_senha: TIWEdit;
    ed_buscar: TIWEdit;
    bt_buscar: TIWButton;
    ed_funcao: TIWEdit;
    ed_usuario: TIWEdit;
    m_produtos: TIWLink;
    m_principal: TIWLink;
    m_sair: TIWLink;
    link_sair: TIWLink;
    link_usuario: TIWLink;
    ed_nivel: TIWComboBox;
    m_fornecedores: TIWLink;
    Label_1: TIWLabel;
    m_financeiro: TIWLink;
    m_vendas: TIWLink;
    bt_imprimir: TIWButton;

    procedure IWAppFormShow(Sender: TObject);
    procedure template_usuariosUnknownTag(const AName: string; var VValue: string);
    procedure link_homeClick(Sender: TObject);
    procedure link_sairClick(Sender: TObject);
    procedure m_usuariosClick(Sender: TObject);
    procedure m_fornecedoresClick(Sender: TObject);
    procedure m_produtosClick(Sender: TObject);
    procedure m_vendasClick(Sender: TObject);
    procedure m_financeiroClick(Sender: TObject);
    procedure m_sairClick(Sender: TObject);

    procedure ClearFields();
    procedure SyncFields();
    procedure UpdateAll();
    procedure Search();

    procedure bt_incluirAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure bt_editarAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure bt_excluirClick(Sender: TObject);
    procedure bt_buscarClick(Sender: TObject);
    procedure bt_okAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure bt_cancelarClick(Sender: TObject);

  private

  public

  end;

implementation

{$R *.dfm}

uses
  ServerController, UserSessionUnit,
  md_login, md_menu, md_fornecedores, md_produtos, md_vendas, md_lancamentos;

procedure TF_usuarios.IWAppFormShow(Sender: TObject);
begin
  Label_1.Caption := USRNAME;
  UpdateAll;
end;

procedure TF_usuarios.template_usuariosUnknownTag(const AName: string;
  var VValue: string);
begin
  if AName = 'GRID_USUARIOS' then
  begin
    with UserSession do
    begin
      query_usuarios.First;
      while not query_usuarios.eof do
      begin
        VValue := VValue + '<tr>'+
        '<td>'+query_usuarios.FieldByName('NOME').AsString+'</td>'+sLineBreak+
        '<td>'+query_usuarios.FieldByName('FUNCAO').AsString+'</td>'+sLineBreak+
        '<td>'+query_usuarios.FieldByName('USUARIO').AsString+'</td>'+sLineBreak+
        '<td>'+query_usuarios.FieldByName('NIVEL').AsString+'</td>'+sLineBreak+
        '<td>'+
        '<a href="#" class="buttom" onclick="return getItemId('+query_usuarios.FieldByName('ID').AsString+', ''editar'')"><img src="icons/931.bmp" width="32" alt="EDITAR" title="EDITAR"></a> '+
        '<a href="#" class="buttom" onclick="return getItemId('+query_usuarios.FieldByName('ID').AsString+', ''excluir'')"><img src="icons/938.bmp" width="32" alt="EXCLUIR" title="EXCLUIR"></a>'+
        '</td>'+sLineBreak+'</tr>';
        query_usuarios.Next;
      end;
    end;
  end;
end;

procedure TF_usuarios.link_homeClick(Sender: TObject);
begin
  TF_menu.Create(WebApplication).Show;
end;

procedure TF_usuarios.link_sairClick(Sender: TObject);
begin
  TF_login.Create(WebApplication).Show;
end;

procedure TF_usuarios.m_usuariosClick(Sender: TObject);
begin
  { usuarios }
end;

procedure TF_usuarios.m_fornecedoresClick(Sender: TObject);
begin
  TF_fornecedores.Create(WebApplication).Show;
end;

procedure TF_usuarios.m_produtosClick(Sender: TObject);
begin
  TF_produtos.Create(WebApplication).Show;
end;

procedure TF_usuarios.m_vendasClick(Sender: TObject);
begin
  TF_vendas.Create(WebApplication).Show;
end;

procedure TF_usuarios.m_financeiroClick(Sender: TObject);
begin
  TF_lancamentos.Create(WebApplication).Show;
end;

procedure TF_usuarios.m_sairClick(Sender: TObject);
begin
  TF_login.Create(WebApplication).Show;
end;

{ ... }

procedure TF_usuarios.ClearFields;
begin
  ed_nome.Text := '';
  ed_funcao.Text := '';
  ed_usuario.Text := '';
  ed_senha.Text := '';
  ed_nivel.ItemIndex := 0;
end;

procedure TF_usuarios.SyncFields;
begin
  with UserSession do
  begin
    query_usuarios.FieldByName('NOME').Value := ed_nome.Text;
    query_usuarios.FieldByName('FUNCAO').Value := ed_funcao.Text;
    query_usuarios.FieldByName('USUARIO').Value := ed_usuario.Text;
    query_usuarios.FieldByName('SENHA').Value  := ed_senha.Text;
    case ed_nivel.ItemIndex of
    0: query_usuarios.FieldByName('NIVEL').Value  := 0;
    1: query_usuarios.FieldByName('NIVEL').Value  := 1;
    2: query_usuarios.FieldByName('NIVEL').Value  := 7;
    3: query_usuarios.FieldByName('NIVEL').Value  := 9;
    end;
  end;
end;

procedure TF_usuarios.UpdateAll;
begin
  with UserSession do
  begin
    query_usuarios.Active := False;
    query_usuarios.Active := True;
    query_usuarios.SQL.Clear;
    query_usuarios.SQL.Add('SELECT * FROM t_usuarios ORDER BY NOME ASC ');
    query_usuarios.Open();
  end;
end;

procedure TF_usuarios.Search;
begin
  with UserSession do
  begin
    query_usuarios.Close;
    query_usuarios.Active := True;
    query_usuarios.SQL.Clear;
    query_usuarios.SQL.Add('SELECT * FROM t_usuarios WHERE NOME LIKE :CHV ORDER BY NOME ASC ');
    query_usuarios.ParamByName('CHV').Value := '%'+ed_buscar.Text+'%';
    query_usuarios.Open();
		if query_usuarios.IsEmpty then WebApplication.ShowMessage('Usuário não encontrado!');
  end;
end;

{ ... }

procedure TF_usuarios.bt_incluirAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  ClearFields;
  ed_nivel.ItemIndex := 0;
  UserSession.query_usuarios.Insert;
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#EDITAR_DADOS'').modal(''show'');');
end;

procedure TF_usuarios.bt_editarAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  with UserSession do
  begin
    query_usuarios.Locate('ID', ed_id.Text, []);
    query_usuarios.Edit;
    if query_usuarios.FieldByName('ID').IsNull <> true then ed_id.Text := query_usuarios.FieldByName('ID').Value;
    if query_usuarios.FieldByName('NOME').IsNull <> true then ed_nome.Text := query_usuarios.FieldByName('NOME').Value;
    if query_usuarios.FieldByName('FUNCAO').IsNull <> true then ed_funcao.Text := query_usuarios.FieldByName('FUNCAO').Value;
    if query_usuarios.FieldByName('USUARIO').IsNull <> true then ed_usuario.Text := query_usuarios.FieldByName('USUARIO').Value;
    if query_usuarios.FieldByName('SENHA').IsNull <> true then ed_senha.Text := query_usuarios.FieldByName('SENHA').Value;
    if query_usuarios.FieldByName('NIVEL').IsNull <> true then
    case query_usuarios.FieldByName('NIVEL').Value of
    0: ed_nivel.ItemIndex := 0;
    1: ed_nivel.ItemIndex := 1;
    7: ed_nivel.ItemIndex := 2;
    9: ed_nivel.ItemIndex := 3;
    end;
  end;
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#EDITAR_DADOS'').modal(''show'');');
end;

procedure TF_usuarios.bt_excluirClick(Sender: TObject);
begin
  with UserSession do
  begin
    query_usuarios.Locate('ID', ed_id.Text, []);
    query_usuarios.Delete;
  end;
  UpdateAll;
end;

procedure TF_usuarios.bt_buscarClick(Sender: TObject);
begin
  Search;
end;

procedure TF_usuarios.bt_okAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  if Trim(ed_nome.Text) = '' then
  begin
    WebApplication.ShowMessage('Favor preencher o campo NOME!');
    ed_nome.SetFocus;
    exit;
  end;
  if Trim(ed_funcao.Text) = '' then
  begin
    WebApplication.ShowMessage('Favor preencher o campo FUNÇÃO!');
    ed_funcao.SetFocus;
    exit;
  end;
  if Trim(ed_usuario.Text) = '' then
  begin
    WebApplication.ShowMessage('Favor preencher o campo USUÁRIO!');
    ed_usuario.SetFocus;
    exit;
  end;
  if Trim(ed_senha.Text) = '' then
  begin
    WebApplication.ShowMessage('Favor preencher o campo SENHA');
    ed_senha.SetFocus;
    exit;
  end;
  SyncFields;
  UserSession.query_usuarios.Post;
  {
  with F_session do
  begin
    chv := ed_id.Text;
    password := ed_senha.Text; if password = '' then password := 'NULL';
    query_usuarios.DisableControls;
    query_usuarios.SQL.Clear;
    query_usuarios.SQL.Add('UPDATE t_usuarios SET SENHA = PASSWORD(MD5('+password+')) WHERE ID = '+chv+' ');
    query_usuarios.ExecSQL;
    query_usuarios.EnableControls;
  end;
  }
  ClearFields;
  UpdateAll;
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#EDITAR_DADOS'').modal(''hide'');');
  WebApplication.CallBackResponse.AddJavaScriptToExecute('location.reload()');
end;

procedure TF_usuarios.bt_cancelarClick(Sender: TObject);
begin
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#EDITAR_DADOS'').modal(''hide'');');
end;

end.
