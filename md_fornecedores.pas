unit md_fornecedores;

interface

uses
  Classes, SysUtils, FireDAC.Stan.Param,
  IWAppForm, IWApplication, IWColor, IWTypes, IWCompEdit,
  IWCompButton, IWCompGrids, IWDBGrids, Vcl.Controls, IWVCLBaseControl,
  IWBaseControl, IWBaseHTMLControl, IWControl, IWHTMLControls, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, Data.DB, IWCompLabel;

type
  TF_fornecedores = class(TIWAppForm)
    template_fornecedores: TIWTemplateProcessorHTML;
    link_home: TIWLink;
    m_usuarios: TIWLink;
    bt_incluir: TIWButton;
    bt_editar: TIWButton;
    bt_excluir: TIWButton;
    bt_ok: TIWButton;
    bt_cancelar: TIWButton;
    ed_fornecedor: TIWEdit;
    ed_id: TIWEdit;
    ed_buscar: TIWEdit;
    bt_buscar: TIWButton;
    ed_email: TIWEdit;
    ed_telefone: TIWEdit;
    m_produtos: TIWLink;
    m_principal: TIWLink;
    m_sair: TIWLink;
    link_sair: TIWLink;
    link_usuario: TIWLink;
    m_fornecedores: TIWLink;
    Label_1: TIWLabel;
    m_financeiro: TIWLink;
    m_vendas: TIWLink;
    bt_imprimir: TIWButton;

    procedure IWAppFormShow(Sender: TObject);
    procedure template_fornecedoresUnknownTag(const AName: string;  var VValue: string);
    procedure link_homeClick(Sender: TObject);
    procedure link_sairClick(Sender: TObject);
    procedure m_usuariosClick(Sender: TObject);
    procedure m_fornecedoresClick(Sender: TObject);
    procedure m_produtosClick(Sender: TObject);
    procedure m_financeiroClick(Sender: TObject);
    procedure m_sairClick(Sender: TObject);
    procedure m_vendasClick(Sender: TObject);

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

  public

  end;

implementation

{$R *.dfm}

uses
  ServerController, UserSessionUnit,
  md_login, md_menu, md_usuarios, md_produtos, md_vendas, md_lancamentos;

procedure TF_fornecedores.IWAppFormShow(Sender: TObject);
begin
  Label_1.Caption := USRNAME;
  UpdateAll;
end;

procedure TF_fornecedores.template_fornecedoresUnknownTag(const AName: string;
  var VValue: string);
begin
  if AName = 'GRID_FORNECEDORES' then
  begin
    with UserSession do
    begin
      query_fornecedores.First;
      while not query_fornecedores.eof do
      begin
        VValue := VValue + '<tr>'+
        '<td>'+query_fornecedores.FieldByName('FORNECEDOR').AsString+'</td>'+sLineBreak+
        '<td>'+query_fornecedores.FieldByName('EMAIL').AsString+'</td>'+sLineBreak+
        '<td>'+query_fornecedores.FieldByName('TELEFONE').AsString+'</td>'+sLineBreak+
        '<td>'+
        '<a href="#" class="buttom" onclick="return getItemId('+query_fornecedores.FieldByName('ID').AsString+', ''editar'')"><img src="icons/931.bmp" width="32" alt="EDITAR" title="EDITAR"></a> '+
        '<a href="#" class="buttom" onclick="return getItemId('+query_fornecedores.FieldByName('ID').AsString+', ''excluir'')"><img src="icons/938.bmp" width="32" alt="EXCLUIR" title="EXCLUIR"></a>'+
        '</td>'+sLineBreak+'</tr>';
        query_fornecedores.Next;
      end;
    end;
  end;
end;

procedure TF_fornecedores.link_homeClick(Sender: TObject);
begin
  TF_menu.Create(WebApplication).Show;
end;

procedure TF_fornecedores.link_sairClick(Sender: TObject);
begin
  TF_login.Create(WebApplication).Show;
end;

procedure TF_fornecedores.m_usuariosClick(Sender: TObject);
begin
  TF_usuarios.Create(WebApplication).Show;
end;

procedure TF_fornecedores.m_fornecedoresClick(Sender: TObject);
begin
  TF_fornecedores.Create(WebApplication).Show;
end;

procedure TF_fornecedores.m_produtosClick(Sender: TObject);
begin
  TF_produtos.Create(WebApplication).Show;
end;

procedure TF_fornecedores.m_vendasClick(Sender: TObject);
begin
  TF_vendas.Create(WebApplication).Show;
end;

procedure TF_fornecedores.m_financeiroClick(Sender: TObject);
begin
  TF_lancamentos.Create(WebApplication).Show;
end;

procedure TF_fornecedores.m_sairClick(Sender: TObject);
begin
  TF_login.Create(WebApplication).Show;
end;

{ ... }

procedure TF_fornecedores.ClearFields;
begin
  ed_fornecedor.Text := '';
  ed_email.Text := '';
  ed_telefone.Text := '';
end;

procedure TF_fornecedores.SyncFields;
begin
  with UserSession do
  begin
    query_fornecedores.FieldByName('FORNECEDOR').Value := ed_fornecedor.Text;
    query_fornecedores.FieldByName('EMAIL').Value := ed_email.Text;
    query_fornecedores.FieldByName('TELEFONE').Value := ed_telefone.Text;
  end;
end;

procedure TF_fornecedores.UpdateAll;
begin
  with UserSession do
  begin
    query_fornecedores.Active := False;
    query_fornecedores.Active := True;
    query_fornecedores.SQL.Clear;
    query_fornecedores.SQL.Add('SELECT * FROM t_fornecedores ORDER BY FORNECEDOR ASC ');
    query_fornecedores.Open();
  end;
end;

procedure TF_fornecedores.Search;
begin
  with UserSession do
  begin
    query_fornecedores.Close;
    query_fornecedores.Active := True;
    query_fornecedores.SQL.Clear;
    query_fornecedores.SQL.Add('SELECT * FROM t_fornecedores WHERE FORNECEDOR LIKE :CHV ORDER BY FORNECEDOR ASC ');
    query_fornecedores.ParamByName('CHV').Value := '%'+ed_buscar.Text+'%';
    query_fornecedores.Open();
		if query_fornecedores.IsEmpty then WebApplication.ShowMessage('Fornecedor não encontrado!');
  end;
end;

{ ... }

procedure TF_fornecedores.bt_incluirAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  ClearFields;
  UserSession.query_fornecedores.Insert;
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#EDITAR_DADOS'').modal(''show'');');
end;

procedure TF_fornecedores.bt_editarAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  with UserSession do
  begin
    query_fornecedores.Locate('ID', ed_id.Text, []);
    query_fornecedores.Edit;
    if query_fornecedores.FieldByName('ID').IsNull <> true then ed_id.Text := query_fornecedores.FieldByName('ID').Value;
    if query_fornecedores.FieldByName('FORNECEDOR').IsNull <> true then ed_fornecedor.Text := query_fornecedores.FieldByName('FORNECEDOR').Value;
    if query_fornecedores.FieldByName('EMAIL').IsNull <> true then ed_email.Text := query_fornecedores.FieldByName('EMAIL').Value;
    if query_fornecedores.FieldByName('TELEFONE').IsNull <> true then ed_telefone.Text := query_fornecedores.FieldByName('TELEFONE').Value;
  end;
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#EDITAR_DADOS'').modal(''show'');');
end;

procedure TF_fornecedores.bt_excluirClick(Sender: TObject);
begin
  with UserSession do
  begin
    query_fornecedores.Locate('ID', ed_id.Text, []);
    query_fornecedores.Delete;
  end;
  UpdateAll;
end;

procedure TF_fornecedores.bt_buscarClick(Sender: TObject);
begin
  Search;
end;

procedure TF_fornecedores.bt_okAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  if Trim(ed_fornecedor.Text) = '' then
  begin
    WebApplication.ShowMessage('Favor preencher o campo FORNECEDOR!');
    ed_fornecedor.SetFocus;
    exit;
  end;
  if Trim(ed_email.Text) = '' then
  begin
    WebApplication.ShowMessage('Favor preencher o campo E-MAIL!');
    ed_email.SetFocus;
    exit;
  end;
  if Trim(ed_telefone.Text) = '' then
  begin
    WebApplication.ShowMessage('Favor preencher o campo TELEFONE!');
    ed_telefone.SetFocus;
    exit;
  end;
  SyncFields;
  UserSession.query_fornecedores.Post;
  ClearFields;
  UpdateAll;
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#EDITAR_DADOS'').modal(''hide'');');
  WebApplication.CallBackResponse.AddJavaScriptToExecute('location.reload()');
end;

procedure TF_fornecedores.bt_cancelarClick(Sender: TObject);
begin
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#EDITAR_DADOS'').modal(''hide'');');
end;

end.
