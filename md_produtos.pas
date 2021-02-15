unit md_produtos;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, Vcl.Controls,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl, IWCompButton,
  IWVCLComponent, IWBaseLayoutComponent, IWBaseContainerLayout,
  IWContainerLayout, IWTemplateProcessorHTML, IWCompGrids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, IWDBGrids, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, IWCompEdit,
  IWCompListbox, IWHTMLControls, IWCompLabel, Vcl.Imaging.jpeg, IWCompExtCtrls,
  IWCompFileUploader, Vcl.Graphics, frxClass, frxDBSet, frxExportBaseDialog,
  frxExportPDF, frxGradient;

type
  TF_produtos = class(TIWAppForm)
    bt_incluir: TIWButton;
    bt_editar: TIWButton;
    bt_excluir: TIWButton;
    bt_ok: TIWButton;
    bt_cancelar: TIWButton;
    ed_produto: TIWEdit;
    ed_valor: TIWEdit;
    ed_id: TIWEdit;
    ed_unidade: TIWEdit;
    ed_buscar: TIWEdit;
    bt_buscar: TIWButton;
    ed_estoque: TIWEdit;
    ed_fornecedor: TIWComboBox;
    template_produtos: TIWTemplateProcessorHTML;
    link_home: TIWLink;
    m_usuarios: TIWLink;
    m_produtos: TIWLink;
    m_principal: TIWLink;
    m_sair: TIWLink;
    link_sair: TIWLink;
    link_usuario: TIWLink;
    m_fornecedores: TIWLink;
    Label_1: TIWLabel;
    img_uploader: TIWFileUploader;
    img_refresh: TIWButton;
    img_produto: TIWImage;
    m_financeiro: TIWLink;
    m_vendas: TIWLink;
    frx_produtos: TfrxReport;
    frx_PDF: TfrxPDFExport;
    frx_dbdataset: TfrxDBDataset;
    bt_imprimir: TIWButton;
    frxGradientObject1: TfrxGradientObject;

    procedure IWAppFormShow(Sender: TObject);
    procedure template_produtosUnknownTag(const AName: string;  var VValue: string);
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

    procedure LoadCombobox();
    procedure ed_fornecedorAsyncEnter(Sender: TObject; EventParams: TStringList);
    procedure ed_estoqueAsyncChange(Sender: TObject; EventParams: TStringList);
    procedure ed_valorAsyncChange(Sender: TObject; EventParams: TStringList);
    procedure img_uploaderAsyncUploadCompleted(Sender: TObject; var DestPath, FileName: string; var SaveFile, Overwrite: Boolean);
    procedure img_refreshAsyncClick(Sender: TObject; EventParams: TStringList);

    procedure bt_incluirAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure bt_editarAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure bt_excluirClick(Sender: TObject);
    procedure bt_buscarClick(Sender: TObject);
    procedure bt_imprimirAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure bt_okAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure bt_cancelarClick(Sender: TObject);

  public

  var
    arquivo: string;
  end;

implementation

{$R *.dfm}

uses
  ServerController, UserSessionUnit,
  md_login, md_menu, md_usuarios, md_fornecedores, md_vendas, md_lancamentos;

procedure TF_produtos.IWAppFormShow(Sender: TObject);
begin
  Label_1.Caption := USRNAME;
  UpdateAll;
end;

procedure TF_produtos.template_produtosUnknownTag(const AName: string;
  var VValue: string);
begin
  LoadCombobox;
  if AName = 'GRID_PRODUTOS' then
  begin
    with UserSession do
    begin
      query_produtos.First;
      while not query_produtos.Eof do
      begin
        VValue := VValue + '<tr>'+
        '<td><img src="produtos/'+query_produtos.FieldByName('IMAGEM').AsString+'" width="32"></td>'+sLineBreak+
        '<td>'+query_produtos.FieldByName('PRODUTO').AsString+'</td>'+sLineBreak+
        '<td>'+query_produtos.FieldByName('FORNECEDOR').AsString+'</td>'+sLineBreak+
        '<td>'+query_produtos.FieldByName('ESTQ_ATUAL').AsString+'</td>'+sLineBreak+
        '<td>'+query_produtos.FieldByName('UNIDADE').AsString+'</td>'+sLineBreak+
        '<td>'+FloatToStrF(query_produtos.FieldByName('VALOR').Value,ffCurrency,10,2)+'</td>'+sLineBreak+
        '<td>'+
        '<a href="#" class="buttom" onclick="return getItemId('+query_produtos.FieldByName('ID').AsString+', ''editar'')"><img src="icons/931.bmp" width="32" alt="EDITAR" title="EDITAR"></a> '+
        '<a href="#" class="buttom" onclick="return getItemId('+query_produtos.FieldByName('ID').AsString+', ''excluir'')"><img src="icons/938.bmp" width="32" alt="EXCLUIR" title="EXCLUIR"></a>'+
        '</td>'+sLineBreak+'</tr>';
        query_produtos.Next;
      end;
    end;
  end;
end;

procedure TF_produtos.link_homeClick(Sender: TObject);
begin
  TF_menu.Create(WebApplication).Show;
end;

procedure TF_produtos.link_sairClick(Sender: TObject);
begin
  TF_login.Create(WebApplication).Show;
end;

procedure TF_produtos.m_usuariosClick(Sender: TObject);
begin
  TF_usuarios.Create(WebApplication).Show;
end;

procedure TF_produtos.m_fornecedoresClick(Sender: TObject);
begin
  TF_fornecedores.Create(WebApplication).Show;
end;

procedure TF_produtos.m_produtosClick(Sender: TObject);
begin
  TF_produtos.Create(WebApplication).Show;
end;

procedure TF_produtos.m_vendasClick(Sender: TObject);
begin
  TF_vendas.Create(WebApplication).Show;
end;

procedure TF_produtos.m_financeiroClick(Sender: TObject);
begin
  TF_lancamentos.Create(WebApplication).Show;
end;

procedure TF_produtos.m_sairClick(Sender: TObject);
begin
  TF_login.Create(WebApplication).Show;
end;

{ ... }

procedure TF_produtos.ClearFields;
begin
  arquivo := 'sem-foto.jpg';
//arquivo := UserSession.query_produtos.FieldByName('ID').asString; Insert_L(arquivo,6,'0'); arquivo := arquivo+'.jpg';
  ed_fornecedor.Text := '';
  ed_produto.Text := '';
  ed_estoque.Text := '';
  ed_unidade.Text := '';
  ed_valor.Text := '';
end;

procedure TF_produtos.SyncFields;
begin
  with UserSession do
  begin
    query_produtos.FieldByName('PRODUTO').Value  := ed_produto.Text;
    query_produtos.FieldByName('ID_FORNECEDOR').Value := Integer(ed_fornecedor.Items.Objects[ed_fornecedor.ItemIndex]);
    query_produtos.FieldByName('ESTQ_ATUAL').Value  := ed_estoque.Text;
    query_produtos.FieldByName('UNIDADE').Value  := ed_unidade.Text;
    query_produtos.FieldByName('VALOR').Value    := ed_valor.Text;
    query_produtos.FieldByName('IMAGEM').Value  := arquivo;
  end;
end;

procedure TF_produtos.UpdateAll;
begin
  with UserSession do
  begin
    query_produtos.Active := False;
    query_produtos.Active := True;
    query_produtos.SQL.Clear;
    query_produtos.SQL.Add(
    'SELECT P.ID, P.PRODUTO, P.IMAGEM, P.UNIDADE, P.ESTQ_ATUAL, P.VALOR, P.ID_FORNECEDOR, F.FORNECEDOR FROM t_produtos AS P '+
    'INNER JOIN t_fornecedores AS F ON P.ID_FORNECEDOR = F.ID ORDER BY P.PRODUTO ASC ');
    query_produtos.Open();
  end;
end;

procedure TF_produtos.Search;
begin
  with UserSession do
  begin
    query_produtos.Close;
    query_produtos.Active := True;
    query_produtos.SQL.Clear;
    query_produtos.SQL.Add(
    'SELECT P.ID, P.PRODUTO, P.IMAGEM, P.UNIDADE, P.ESTQ_ATUAL, P.VALOR, P.ID_FORNECEDOR, F.FORNECEDOR FROM t_produtos AS P '+
    'INNER JOIN t_fornecedores AS F ON P.ID_FORNECEDOR = F.ID '+
    'WHERE P.PRODUTO LIKE :CHV OR F.FORNECEDOR LIKE :CHV '+
    'ORDER BY P.PRODUTO ASC ');
    query_produtos.ParamByName('CHV').Value := '%'+ed_buscar.Text+'%';
    query_produtos.Open();
		if query_produtos.IsEmpty then WebApplication.ShowMessage('Produto não encontrado!');
  end;
end;

{ ... }

procedure TF_produtos.LoadCombobox;
begin
  with UserSession do
  begin
    query_fornecedores.Close;
    query_fornecedores.Active := True;
    ed_fornecedor.Items.Clear;
    while not query_fornecedores.Eof do
    begin
      ed_fornecedor.Items.AddObject(query_fornecedores.FieldByName('FORNECEDOR').AsString, TObject(query_fornecedores.FieldByName('ID').AsInteger));
      query_fornecedores.Next;
    end;
  end;
  ed_fornecedor.ItemIndex := 0;
end;

procedure TF_produtos.ed_fornecedorAsyncEnter(Sender: TObject;
  EventParams: TStringList);
begin
  LoadCombobox;
end;

procedure TF_produtos.ed_estoqueAsyncChange(Sender: TObject;
  EventParams: TStringList);
var
  i: integer;
begin
  if TryStrToInt(ed_estoque.Text, i) <> True then
  begin
    WebApplication.ShowMessage('Entrada inválida! Digite a QTD novamente.');
    ed_estoque.Text := '';
    ed_estoque.SetFocus;
  end;
end;

procedure TF_produtos.ed_valorAsyncChange(Sender: TObject;
  EventParams: TStringList);
var
  d: double;
begin
  if TryStrToFloat(ed_valor.Text, d) <> True then
  begin
    WebApplication.ShowMessage('Entrada inválida! Digite o VALOR novamente.');
    ed_valor.Text := '';
    ed_valor.SetFocus;
  end;
end;

procedure TF_produtos.img_uploaderAsyncUploadCompleted(Sender: TObject;
  var DestPath, FileName: string; var SaveFile, Overwrite: Boolean);
begin
  with UserSession do
  begin
    arquivo := query_produtos.FieldByName('ID').asString; Insert_L(arquivo,6,'0'); arquivo := arquivo+'.jpg';
    img_uploader.SaveToFile(FileName, 'wwwroot\produtos\'+arquivo, True);
    SaveFile := True;
//  img_uploader.SaveAll('wwwroot\produtos\', True);
//  arquivo := FileName;
  end;
end;

procedure TF_produtos.img_refreshAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  img_produto.Picture.LoadFromFile('wwwroot\produtos\'+arquivo);
end;

{ ... }

procedure TF_produtos.bt_incluirAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  ClearFields;
  LoadCombobox;
  UserSession.query_produtos.Insert;
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#EDITAR_DADOS'').modal(''show'');');
  arquivo := 'sem-foto.jpg';
end;

procedure TF_produtos.bt_editarAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  LoadCombobox;
  with UserSession do
  begin
    query_produtos.Locate('ID', ed_id.Text, []);
    query_produtos.Edit;
    ed_id.Text := query_produtos.FieldByName('ID').Value;
    ed_produto.Text := query_produtos.FieldByName('PRODUTO').Value;
    ed_fornecedor.Items[0] := query_produtos.FieldByName('FORNECEDOR').Value;
    ed_estoque.Text := query_produtos.FieldByName('ESTQ_ATUAL').Value;
    ed_unidade.Text := query_produtos.FieldByName('UNIDADE').Value;
    ed_valor.Text := FloatToStrF(query_produtos.FieldByName('VALOR').Value,ffCurrency,10,2);
    arquivo := query_produtos.FieldByName('IMAGEM').Value;
    img_produto.Picture.LoadFromFile('wwwroot\produtos\'+arquivo);
  end;
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#EDITAR_DADOS'').modal(''show'');');
end;

procedure TF_produtos.bt_excluirClick(Sender: TObject);
begin
  with UserSession do
  begin
    query_produtos.Locate('ID', ed_id.Text, []);
    query_produtos.Delete;
  end;
  UpdateAll;
end;

procedure TF_produtos.bt_buscarClick(Sender: TObject);
begin
  Search;
end;

procedure TF_produtos.bt_imprimirAsyncClick(Sender: TObject;
  EventParams: TStringList);
var
	objExportfilter : TfrxCustomExportFilter;
begin
	objExportfilter := TfrxCustomExportFilter(frx_PDF);
	objExportfilter.ShowDialog := False;
  objExportfilter.FileName := GetCurrentDir + '\wwwroot\impressos\frx_produtos.pdf'; // standalone application
  frx_produtos.Variables['img_path'] := frx_produtos.GetApplicationFolder+'wwwroot\produtos\';
  frx_produtos.PrepareReport(True);
  frx_produtos.Export(objExportfilter);
  WebApplication.CallBackResponse.AddJavaScriptToExecute('window.open("impressos/frx_produtos.pdf");');
end;

procedure TF_produtos.bt_okAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  if Trim(ed_produto.Text) = '' then
  begin
    WebApplication.ShowMessage('Favor preencher o campo PRODUTO!');
    ed_produto.SetFocus;
    exit;
  end;
  if Trim(ed_estoque.Text) = '' then
  begin
    WebApplication.ShowMessage('Favor preencher o campo QTD!');
    ed_estoque.SetFocus;
    exit;
  end;
  if Trim(ed_valor.Text) = '' then
  begin
    WebApplication.ShowMessage('Favor preencher o campo VALOR!');
    ed_valor.SetFocus;
    exit;
  end;
  SyncFields;
  UserSession.query_produtos.Post;
  ClearFields;
  UpdateAll;
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#EDITAR_DADOS'').modal(''hide'');');
  WebApplication.CallBackResponse.AddJavaScriptToExecute('location.reload()');
end;

procedure TF_produtos.bt_cancelarClick(Sender: TObject);
begin
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#EDITAR_DADOS'').modal(''hide'');');
end;

end.
