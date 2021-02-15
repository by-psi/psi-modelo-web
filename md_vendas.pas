unit md_vendas;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompButton, IWCompRadioButton, IWCompListbox,
  IWCompEdit, Vcl.Controls, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWControl, IWHTMLControls, IWHTMLTag, IWCompLabel, IWDBStdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, frxClass, frxDBSet,
  frxExportBaseDialog, frxExportPDF, frxGradient;

type
  TF_vendas = class(TIWAppForm)
    template_vendas: TIWTemplateProcessorHTML;
    m_principal: TIWLink;
    m_usuarios: TIWLink;
    m_produtos: TIWLink;
    m_fornecedores: TIWLink;
    m_sair: TIWLink;
    link_home: TIWLink;
    link_usuario: TIWLink;
    link_sair: TIWLink;
    ed_id: TIWEdit;
    ed_produto: TIWComboBox;
    bt_buscar: TIWButton;
    bt_incluir: TIWButton;
    bt_editar: TIWButton;
    bt_excluir: TIWButton;
    bt_ok: TIWButton;
    bt_cancelar: TIWButton;
    dt_final: TIWEdit;
    bt_imprimir: TIWButton;
    ed_qtd: TIWEdit;
    ed_valorunitario: TIWEdit;
    ed_valortotal: TIWEdit;
    m_financeiro: TIWLink;
    m_vendas: TIWLink;
    ed_buscar: TIWEdit;
    Label_1: TIWLabel;
    ed_data: TIWEdit;
    ed_estoque: TIWEdit;
    Label_2: TIWLabel;
    dt_inicial: TIWEdit;
    frx_vendas: TfrxReport;
    frx_PDF: TfrxPDFExport;
    frx_dbdataset: TfrxDBDataset;
    frxGradientObject1: TfrxGradientObject;
    bt_fecharvenda: TIWButton;

    procedure IWAppFormShow(Sender: TObject);
    procedure template_vendasUnknownTag(const AName: string; var VValue: string);
    procedure link_homeClick(Sender: TObject);
    procedure link_sairClick(Sender: TObject);
    procedure m_usuariosClick(Sender: TObject);
    procedure m_fornecedoresClick(Sender: TObject);
    procedure m_produtosClick(Sender: TObject);
    procedure m_vendasClick(Sender: TObject);
    procedure m_financeiroClick(Sender: TObject);
    procedure m_sairClick(Sender: TObject);

    procedure ClearFields();
    procedure SyncFields_Vendas();
    procedure SyncFields_Itens();
    procedure UpdateAll();
    procedure SumAll();
    procedure dt_inicialHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure dt_finalHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure Search();
    procedure Empty_Itens();

    procedure LoadCombobox();
    procedure ed_produtoAsyncEnter(Sender: TObject; EventParams: TStringList);
    procedure ed_produtoAsyncChange(Sender: TObject; EventParams: TStringList);
    procedure LoadInfo_Produto();
    procedure ed_qtdAsyncChange(Sender: TObject; EventParams: TStringList);
    procedure ed_qtdAsyncExit(Sender: TObject; EventParams: TStringList);
    procedure SumItem();

    procedure bt_incluirAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure bt_excluirClick(Sender: TObject);
    procedure bt_buscarClick(Sender: TObject);
    procedure bt_imprimirAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure bt_okClick(Sender: TObject);
    procedure bt_cancelarClick(Sender: TObject);
    procedure bt_fecharvendaClick(Sender: TObject);

  public

  end;

var
  id_produto, id_venda: string;
  valor_un, valor_total, total_vendas: double;
  estq_atual,qtd: integer;

implementation

{$R *.dfm}

uses
  ServerController, UserSessionUnit,
  md_login, md_menu, md_usuarios, md_fornecedores, md_produtos, md_lancamentos;

procedure TF_vendas.IWAppFormShow(Sender: TObject);
begin
  Label_1.Caption := USRNAME;
  UpdateAll;
end;

procedure TF_vendas.template_vendasUnknownTag(const AName: string; var VValue: string);
begin
  if AName = 'GRID_VENDAS' then
  begin
    with UserSession do
    begin
      query_itensdevenda.First;
      while not query_itensdevenda.eof do
      begin
        VValue := VValue + '<tr>'+
        '<td>'+query_itensdevenda.FieldByName('PRODUTO').AsString+'</td>'+sLineBreak+
        '<td>'+query_itensdevenda.FieldByName('QTD').AsString+'</td>'+sLineBreak+
        '<td>'+FloatToStrF(query_itensdevenda.FieldByName('VALOR_UN').Value,ffCurrency,10,2)+'</td>'+sLineBreak+
        '<td>'+FloatToStrF(query_itensdevenda.FieldByName('VALOR_TOTAL').Value,ffCurrency,10,2)+'</td>'+sLineBreak+
        '<td>'+
        '<a href="#" class="buttom" onclick="return getItemId('+query_itensdevenda.FieldByName('ID').AsString+', ''excluir'')"><img src="icons/938.bmp" width="32" alt="EXCLUIR" title="EXCLUIR"></a>'+
        '</td>'+sLineBreak+'</tr>';
        query_itensdevenda.Next;
      end;
    end;
  end;
end;

procedure TF_vendas.link_homeClick(Sender: TObject);
begin
  if total_vendas = 0 then
  begin
    TF_menu.Create(WebApplication).Show;
  end else
  begin
    WebApplication.ShowMessage('Atenção! Finalize ou remova os itens desta Venda.');
  end;
end;

procedure TF_vendas.link_sairClick(Sender: TObject);
begin
  TF_login.Create(WebApplication).Show;
end;

procedure TF_vendas.m_usuariosClick(Sender: TObject);
begin
  TF_usuarios.Create(WebApplication).Show;
end;

procedure TF_vendas.m_fornecedoresClick(Sender: TObject);
begin
  TF_fornecedores.Create(WebApplication).Show;
end;

procedure TF_vendas.m_produtosClick(Sender: TObject);
begin
  TF_produtos.Create(WebApplication).Show;
end;

procedure TF_vendas.m_vendasClick(Sender: TObject);
begin
  { vendas }
end;

procedure TF_vendas.m_financeiroClick(Sender: TObject);
begin
  TF_lancamentos.Create(WebApplication).Show;
end;

procedure TF_vendas.m_sairClick(Sender: TObject);
begin
  TF_login.Create(WebApplication).Show;
end;

{ ... }

procedure TF_vendas.ClearFields;
begin
  qtd := 1; estq_atual := 0; valor_un := 0; valor_total := 0;
  ed_data.Text := DateToStr(Date);
  ed_produto.ItemIndex := 0;
  ed_qtd.Text := '1';
  ed_valortotal.Text   := '0,00';
end;

procedure TF_vendas.SyncFields_Vendas;
begin
  with UserSession do
  begin
    query_vendas.FieldByName('ID_USUARIO').Value := USR_ID;
    query_vendas.FieldByName('DATA').Value := date;
    query_vendas.FieldByName('VALOR_TOTAL').Value := total_vendas;
    query_vendas.FieldByName('CHV').Value := 'F';
  end;
end;

procedure TF_vendas.SyncFields_Itens;
begin
  with UserSession do
  begin
    query_itensdevenda.FieldByName('ID_VENDA').Value := 0;
    query_itensdevenda.FieldByName('ID_PRODUTO').Value := Integer(ed_produto.Items.Objects[ed_produto.ItemIndex]);
    query_itensdevenda.FieldByName('PRODUTO').Value := ed_produto.Items[0];
    query_itensdevenda.FieldByName('QTD').Value := ed_qtd.Text;
    query_itensdevenda.FieldByName('VALOR_UN').Value := ed_valorunitario.Text;
    query_itensdevenda.FieldByName('VALOR_TOTAL').Value := ed_valortotal.Text;
    query_itensdevenda.FieldByName('ID_USUARIO').Value := USR_ID;
  end;
end;

procedure TF_vendas.UpdateAll;
begin
  with UserSession do
  begin
    query_itensdevenda.Close;
    query_itensdevenda.SQL.Clear;
    query_itensdevenda.SQL.Add('SELECT * FROM t_itensdevenda WHERE ID_VENDA = 0 AND ID_USUARIO = :CHV ');
    query_itensdevenda.ParamByName('CHV').Value := USR_ID;
    query_itensdevenda.Open();
    SumAll;
  end;
end;

procedure TF_vendas.SumAll;
begin
  total_vendas := 0;
  with UserSession do
  begin
    query_itensdevenda.First;
    while not query_itensdevenda.eof do
    begin
      total_vendas := total_vendas + query_itensdevenda.FieldByName('VALOR_TOTAL').Value;
      query_itensdevenda.Next;
    end;
    Label_2.Caption := FloatToStrF(total_vendas,ffCurrency,10,2);
  end;
end;

procedure TF_vendas.dt_inicialHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.AddStringParam('type','date');
end;

procedure TF_vendas.dt_finalHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.AddStringParam('type','date');
end;

procedure TF_vendas.Search;
begin
  with UserSession do
  begin
    query_itensdevenda.Close;
    query_itensdevenda.SQL.Clear;
    query_itensdevenda.SQL.Add('SELECT * FROM t_itensdevenda WHERE ID_VENDA = 0 AND ID_USUARIO = :CHV ');
//  'WHERE DATA BETWEEN :DT1 AND :DT2 AND HISTORICO LIKE :CHV ORDER BY L.DATA ');
//  query_itensdevenda.ParamByName('DT1').AsString := dt_inicial.Text;
//  query_itensdevenda.ParamByName('DT2').AsString := dt_final.Text;
    query_itensdevenda.ParamByName('CHV').Value := '%'+ed_buscar.Text+'%';
    query_itensdevenda.Open();
    SumAll;
		if query_itensdevenda.IsEmpty then WebApplication.ShowMessage('Lançamentos não encontrados!');
  end;
end;

{ ... }

procedure TF_vendas.LoadCombobox;
begin
  with UserSession do
  begin
    query_produtos.Close;
    query_produtos.Active := True;
    ed_produto.Items.Clear;
    while not query_produtos.Eof do
    begin
      ed_produto.Items.AddObject(query_produtos.FieldByName('PRODUTO').AsString, TObject(query_produtos.FieldByName('ID').AsInteger));
      query_produtos.Next;
    end;
  end;
  ed_produto.ItemIndex := 0;
end;

procedure TF_vendas.ed_produtoAsyncEnter(Sender: TObject;
  EventParams: TStringList);
begin
  LoadCombobox;
end;

procedure TF_vendas.ed_produtoAsyncChange(Sender: TObject;
  EventParams: TStringList);
begin
  LoadInfo_Produto;
end;

procedure TF_vendas.LoadInfo_Produto;
begin
  with UserSession do
  begin
    Query_1.Close;
    Query_1.SQL.Clear;
    Query_1.SQL.Add('SELECT * FROM t_produtos WHERE PRODUTO = :CHV ');
    Query_1.ParamByName('CHV').Value := ed_produto.Text;
    Query_1.Open();
    if not Query_1.IsEmpty then
    begin
      id_produto := Query_1.FieldByName('ID').AsString;
      estq_atual := Query_1.FieldByName('ESTQ_ATUAL').AsInteger; ed_estoque.Text := IntToStr(estq_atual);
      valor_un   := Query_1.FieldByName('VALOR').Value; ed_valorunitario.Text := FloatToStr(valor_un);
    end;
  end;
end;

procedure TF_vendas.ed_qtdAsyncChange(Sender: TObject;
  EventParams: TStringList);
var
  i: integer;
begin
  if TryStrToInt(ed_qtd.Text, i) <> True then
  begin
    WebApplication.ShowMessage('Entrada inválida! Digite apenas números.');
    ed_qtd.Text := '1';
    ed_qtd.SetFocus;
  end;

  if estq_atual = 0 then
  begin
    WebApplication.ShowMessage('Produto indisponível no momento. Estoque zerado! (abastecer produto)'); //alerta de estoque zerado
    ed_qtd.Text := '0';
    ed_qtd.SetFocus;
  end;
{
  if estq_atual <= estq_minimo then
  begin
    WebApplication.ShowMessage('Atenção! Estoque mínimo atingido! (abastecer produto)'); //alerta de estoque mínimo atingido
    ed_qtd.Text := '0';
    ed_qtd.SetFocus;
  end;
}
  if StrToInt(ed_qtd.Text) > estq_atual then
  begin
    WebApplication.ShowMessage('Estoque insuficiente!'+#10#13+'Verifique a quantidade ou cancele o pedido.'); // sugerir alterar quantidade ou cancelar.
    ed_qtd.Text := '1';
    ed_qtd.SetFocus;
  end;
end;

procedure TF_vendas.ed_qtdAsyncExit(Sender: TObject; EventParams: TStringList);
begin
  SumItem;
end;

procedure TF_vendas.SumItem;
begin
  qtd := StrToInt(ed_qtd.Text);
  valor_total := qtd * valor_un;
  ed_valortotal.Text := FloatToStr(valor_total);
end;

procedure TF_vendas.Empty_Itens;
begin
  with UserSession do
  begin
    query_itensdevenda.Close;
    query_itensdevenda.SQL.Clear;
    query_itensdevenda.SQL.Add('SELECT * FROM t_itensdevenda WHERE ID_VENDA = 0 AND ID_USUARIO = :ID_USUARIO');
    query_itensdevenda.ParamByName('ID_USUARIO').Value := USR_ID;
    query_itensdevenda.Open();
    if not query_itensdevenda.IsEmpty then
    begin
      query_itensdevenda.Close;
      query_itensdevenda.SQL.Clear;
      query_itensdevenda.SQL.Add('DELETE FROM t_itensdevenda WHERE ID_VENDA = 0 AND ID_USUARIO = :ID_USUARIO');
      query_itensdevenda.ParamByName('ID_USUARIO').Value := USR_ID;
      query_itensdevenda.ExecSQL;
    end;
  end;
end;

{ ... }

procedure TF_vendas.bt_incluirAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  LoadCombobox;
  ClearFields;
  LoadInfo_Produto;
  UserSession.query_itensdevenda.Insert;
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#EDITAR_DADOS'').modal(''show'');');
  ed_produto.SetFocus;
end;

procedure TF_vendas.bt_excluirClick(Sender: TObject);
begin
  with UserSession do
  begin
    query_itensdevenda.Locate('ID', ed_id.Text, []);
    id_produto := query_itensdevenda.FieldByName('ID_PRODUTO').Value;
    qtd := query_itensdevenda.FieldByName('QTD').Value;

    Query_1.Close;
    Query_1.SQL.Clear;
    Query_1.SQL.Add('SELECT * FROM t_produtos WHERE ID = :ID_PRODUTO ');
    Query_1.ParamByName('ID_PRODUTO').Value := id_produto;
    Query_1.Open();

    if not Query_1.IsEmpty then
    begin
      estq_atual := Query_1.FieldByName('ESTQ_ATUAL').AsInteger;
    end;

    Query_1.Close;
    Query_1.SQL.Clear;
    Query_1.SQL.Add('UPDATE t_produtos SET ESTQ_ATUAL = :ESTQ_ATUAL WHERE ID = :ID_PRODUTO ');
    Query_1.ParamByName('ESTQ_ATUAL').Value := estq_atual + qtd;
    Query_1.ParamByName('ID_PRODUTO').Value := id_produto;
    Query_1.ExecSQL;

    query_itensdevenda.Delete;
  end;

  UpdateAll;
end;

procedure TF_vendas.bt_fecharvendaClick(Sender: TObject);
var
  s_venda: string;
begin
  if total_vendas > 0 then
  with UserSession do
  begin
    query_vendas.Insert;
    SyncFields_Vendas;
    query_vendas.Post;

    query_vendas.Close;
    query_vendas.SQL.Clear;
    query_vendas.SQL.Add('SELECT * FROM t_vendas ORDER BY ID DESC ');
    query_vendas.Open();

    if not query_vendas.IsEmpty then
    begin
      id_venda := query_vendas.FieldByName('ID').Value;
    end;

    // relaciona itens com ID da venda correspondente

    query_itensdevenda.Close;
    query_itensdevenda.SQL.Clear;
    query_itensdevenda.SQL.Add('UPDATE t_itensdevenda SET ID_VENDA = :ID_VENDA WHERE ID_VENDA = 0 AND ID_USUARIO = :ID_USUARIO');
    query_itensdevenda.ParamByName('ID_VENDA').Value := id_venda;
    query_itensdevenda.ParamByName('ID_USUARIO').Value := USR_ID;
    query_itensdevenda.ExecSQL;

    s_venda := id_venda; while length(s_venda) < 6 do s_venda := '0'+s_venda;

    // lançar venda para a tabela T_lançamentos (receitas)

    Query_1.Close;
    Query_1.SQL.Clear;
    Query_1.SQL.Add('INSERT INTO t_lancamentos (DATA, HISTORICO, VALOR, TIPO, ID_USUARIO, ID_CONTA) VALUES (:DATA, :HISTORICO, :VALOR, :TIPO, :ID_USUARIO, :ID_CONTA) ');
    Query_1.ParamByName('DATA').Value := Date;
    Query_1.ParamByName('HISTORICO').Value := 'VENDA Nº '+s_venda+' - '+USRNAME;
    Query_1.ParamByName('VALOR').Value := total_vendas;
    Query_1.ParamByName('TIPO').Value := 'D';
    Query_1.ParamByName('ID_USUARIO').Value := USR_ID;
    Query_1.ParamByName('ID_CONTA').Value := 1;
    Query_1.ExecSQL;

    total_vendas := 0;
    Label_2.Caption := FloatToStrF(total_vendas,ffCurrency,10,2);

    // libera tabela de itens relacionados com a venda fechada

    Empty_Itens;
    UpdateAll;
    WebApplication.ShowMessage('Venda concluída com sucesso!');
  end else
  begin
    WebApplication.ShowMessage('Adicione itens à Venda.');
  end;
end;

procedure TF_vendas.bt_buscarClick(Sender: TObject);
begin
  Search;
end;

procedure TF_vendas.bt_imprimirAsyncClick(Sender: TObject;
  EventParams: TStringList);
var
	objExportfilter : TfrxCustomExportFilter;
begin
	objExportfilter := TfrxCustomExportFilter(frx_PDF);
	objExportfilter.ShowDialog := False;
	objExportfilter.FileName := GetCurrentDir + '\wwwroot\impressos\frx_vendas.pdf';
  frx_vendas.PrepareReport(True);
  frx_vendas.Export(objExportfilter);
  WebApplication.CallBackResponse.AddJavaScriptToExecute('window.open("/impressos/frx_vendas.pdf");');
end;

procedure TF_vendas.bt_okClick(Sender: TObject);
begin
  SumItem;
  SyncFields_Itens;
  UserSession.query_itensdevenda.Post;
  Label_2.Caption := FloatToStrF(total_vendas,ffCurrency,10,2);

  with UserSession do
  begin
    Query_1.Close;
    Query_1.SQL.Clear;
    Query_1.SQL.Add('UPDATE t_produtos SET ESTQ_ATUAL = :ESTQ_ATUAL WHERE ID = :ID_PRODUTO ');
    Query_1.ParamByName('ESTQ_ATUAL').Value := estq_atual - StrToInt(ed_qtd.Text);
    Query_1.ParamByName('ID_PRODUTO').Value := id_produto;
    Query_1.ExecSQL;
  end;

  ClearFields;
  UpdateAll;
end;

procedure TF_vendas.bt_cancelarClick(Sender: TObject);
begin
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#EDITAR_DADOS'').modal(''hide'');');
end;

end.
