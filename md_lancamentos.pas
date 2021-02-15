unit md_lancamentos;

interface

uses
  Classes, SysUtils, DateUtils,
  IWAppForm, IWApplication, IWColor, IWTypes, IWCompExtCtrls,
  IWCompListbox, IWCompButton, IWCompEdit, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompLabel, Vcl.Controls, IWVCLBaseControl,
  IWBaseControl, IWBaseHTMLControl, IWControl, IWHTMLControls,
  IWHTMLTag, IWCompRadioButton, Data.DB, IWCompGrids, IWDBGrids,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  frxClass, frxDBSet, frxExportBaseDialog, frxExportHTML, frxExportPDF,
  frxExportHelpers, frxExportHTMLDiv, frxGradient;

type
  TF_lancamentos = class(TIWAppForm)
    link_home: TIWLink;
    m_usuarios: TIWLink;
    m_produtos: TIWLink;
    m_principal: TIWLink;
    m_sair: TIWLink;
    link_sair: TIWLink;
    link_usuario: TIWLink;
    m_fornecedores: TIWLink;
    Label_1: TIWLabel;
    template_lancamentos: TIWTemplateProcessorHTML;
    bt_buscar: TIWButton;
    bt_incluir: TIWButton;
    bt_editar: TIWButton;
    bt_excluir: TIWButton;
    bt_ok: TIWButton;
    bt_cancelar: TIWButton;
    ed_id: TIWEdit;
    ed_data: TIWEdit;
    ed_historico: TIWEdit;
    ed_valor: TIWEdit;
    dt_inicial: TIWEdit;
    dt_final: TIWEdit;
    ed_buscar: TIWEdit;
    ed_conta: TIWComboBox;
    RadioButton_D: TIWRadioButton;
    RadioButton_C: TIWRadioButton;
    Label_2: TIWLabel;
    Label_3: TIWLabel;
    bt_imprimir: TIWButton;
    frx_financeiro: TfrxReport;
    frx_PDF: TfrxPDFExport;
    frx_dbdataset: TfrxDBDataset;
    m_vendas: TIWLink;
    m_financeiro: TIWLink;
    frxGradientObject1: TfrxGradientObject;

    procedure IWAppFormShow(Sender: TObject);
    procedure template_lancamentosUnknownTag(const AName: string;  var VValue: string);
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
    procedure dt_inicialHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure dt_finalHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure Search();
    procedure SumAll();

    procedure LoadCombobox();
    procedure ed_contaAsyncEnter(Sender: TObject; EventParams: TStringList);

    procedure bt_incluirAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure bt_editarAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure bt_excluirClick(Sender: TObject);
    procedure bt_buscarClick(Sender: TObject);
    procedure bt_imprimirAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure bt_okAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure bt_cancelarClick(Sender: TObject);

  public

  end;

var
  v_saldo: double;
  v_dc: string;

implementation

{$R *.dfm}

uses
  ServerController, UserSessionUnit,
  md_login, md_menu, md_usuarios, md_fornecedores, md_produtos, md_vendas;

procedure TF_lancamentos.IWAppFormShow(Sender: TObject);
begin
  Label_1.Caption := USRNAME;
  UpdateAll;
end;

procedure TF_lancamentos.template_lancamentosUnknownTag(const AName: string;
  var VValue: string);
begin
  if AName = 'GRID_LANCAMENTOS' then
  begin
    with UserSession do
    begin
      query_lancamentos.First;
      while not query_lancamentos.eof do
      begin
        VValue := VValue + '<tr>'+
        '<td>'+query_lancamentos.FieldByName('DATA').AsString+'</td>'+sLineBreak+
        '<td>'+query_lancamentos.FieldByName('CONTA').AsString+'</td>'+sLineBreak+
        '<td>'+query_lancamentos.FieldByName('HISTORICO').AsString+'</td>'+sLineBreak+
        '<td>'+FloatToStrF(query_lancamentos.FieldByName('VALOR').Value,ffCurrency,10,2)+'</td>'+sLineBreak+
        '<td>'+query_lancamentos.FieldByName('TIPO').AsString+'</td>'+sLineBreak+
        '<td>'+
        '<a href="#" class="buttom" onclick="return getItemId('+query_lancamentos.FieldByName('ID').AsString+', ''editar'')"><img src="icons/931.bmp" width="32" alt="EDITAR" title="EDITAR"></a> '+
        '<a href="#" class="buttom" onclick="return getItemId('+query_lancamentos.FieldByName('ID').AsString+', ''excluir'')"><img src="icons/938.bmp" width="32" alt="EXCLUIR" title="EXCLUIR"></a>'+
        '</td>'+sLineBreak+'</tr>';
        query_lancamentos.Next;
      end;
    end;
  end;
end;

procedure TF_lancamentos.link_homeClick(Sender: TObject);
begin
  TF_menu.Create(WebApplication).Show;
end;

procedure TF_lancamentos.link_sairClick(Sender: TObject);
begin
  TF_login.Create(WebApplication).Show;
end;

procedure TF_lancamentos.m_usuariosClick(Sender: TObject);
begin
  TF_usuarios.Create(WebApplication).Show;
end;

procedure TF_lancamentos.m_fornecedoresClick(Sender: TObject);
begin
  TF_fornecedores.Create(WebApplication).Show;
end;

procedure TF_lancamentos.m_produtosClick(Sender: TObject);
begin
  TF_produtos.Create(WebApplication).Show;
end;

procedure TF_lancamentos.m_vendasClick(Sender: TObject);
begin
  TF_vendas.Create(WebApplication).Show;
end;

procedure TF_lancamentos.m_financeiroClick(Sender: TObject);
begin
  { financeiro }
end;

procedure TF_lancamentos.m_sairClick(Sender: TObject);
begin
  TF_login.Create(WebApplication).Show;
end;

{ ... }

procedure TF_lancamentos.ClearFields;
begin
  ed_data.Text := DateToStr(Date);
  ed_historico.Text := '';
  ed_valor.Text   := '0,00';
end;

procedure TF_lancamentos.SyncFields;
begin
  with UserSession do
  begin
    query_lancamentos.FieldByName('DATA').AsString := ed_data.Text;
    query_lancamentos.FieldByName('ID_CONTA').Value := Integer(ed_conta.Items.Objects[ed_conta.ItemIndex]); //*** verificar ID da conta
    query_lancamentos.FieldByName('HISTORICO').Value  := ed_historico.Text;
    query_lancamentos.FieldByName('VALOR').Value    := ed_valor.Text;
    if RadioButton_D.Checked then query_lancamentos.FieldByName('TIPO').Value := 'D';
    if RadioButton_C.Checked then query_lancamentos.FieldByName('TIPO').Value := 'C';
  end;
end;

procedure TF_lancamentos.UpdateAll;
begin
  with UserSession do
  begin
    query_lancamentos.Active := False;
    query_lancamentos.Active := True;
    query_lancamentos.SQL.Clear;
    query_lancamentos.SQL.Add(
    'SELECT L.ID, L.ID_CONTA, C.CONTA, L.DATA, L.HISTORICO, L.VALOR, L.TIPO, L.ID_USUARIO FROM t_lancamentos AS L '+
    'INNER JOIN t_contas AS C ON L.ID_CONTA = C.ID '+
    'ORDER BY L.DATA ');
    query_lancamentos.Open();
    SumAll;
  end;
end;

procedure TF_lancamentos.dt_inicialHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.AddStringParam('type','date');
end;

procedure TF_lancamentos.dt_finalHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.AddStringParam('type','date');
end;

procedure TF_lancamentos.Search;
begin
  with UserSession do
  begin
    query_lancamentos.Active := False;
    query_lancamentos.Active := True;
    query_lancamentos.SQL.Clear;
    query_lancamentos.SQL.Add(
    'SELECT L.ID, L.ID_CONTA, C.CONTA, L.DATA, L.HISTORICO, L.VALOR, L.TIPO, L.ID_USUARIO FROM t_lancamentos AS L '+
    'INNER JOIN t_contas AS C ON L.ID_CONTA = C.ID '+
    'WHERE L.DATA BETWEEN :DT1 AND :DT2 AND HISTORICO LIKE :CHV '+
    'ORDER BY L.DATA ');
    query_lancamentos.ParamByName('DT1').AsString := dt_inicial.Text;
    query_lancamentos.ParamByName('DT2').AsString := dt_final.Text;
    query_lancamentos.ParamByName('CHV').Value := '%'+ed_buscar.Text+'%';
    query_lancamentos.Open();
    SumAll;
		if query_lancamentos.IsEmpty then WebApplication.ShowMessage('Lançamentos não encontrados!');
  end;
end;

procedure TF_lancamentos.SumAll;
begin
  v_saldo:= 0; v_dc := 'D';
  with UserSession do
  begin
    query_lancamentos.First;
    while not query_lancamentos.eof do
    begin
      if query_lancamentos.FieldByName('TIPO').value  = 'D' then
      v_saldo := v_saldo + query_lancamentos.FieldByName('VALOR').Value else
      if query_lancamentos.FieldByName('TIPO').value  = 'C' then
      v_saldo := v_saldo - query_lancamentos.FieldByName('VALOR').Value;
      if v_saldo >= 0 then v_dc := 'D' else v_dc := 'C';
      query_lancamentos.Next;
    end;
    Label_2.Caption := FloatToStrF(v_saldo,ffCurrency,10,2);
    Label_3.Caption := v_dc;
    if v_saldo >= 0 then
    begin
      Label_2.Css := 'text-success';
      Label_3.Css := 'text-success';
    end else
    begin
      Label_2.Css := 'text-danger';
      Label_3.Css := 'text-danger';
    end;
  end;
end;

{ ... }

procedure TF_lancamentos.LoadCombobox;
begin
  with UserSession do
  begin
    query_contas.Close;
    query_contas.Active := True;
    ed_conta.Items.Clear;
    while not query_contas.Eof do
    begin
      ed_conta.Items.AddObject(query_contas.FieldByName('CONTA').AsString, TObject(query_contas.FieldByName('ID').AsInteger));
      query_contas.Next;
    end;
  end;
  ed_conta.ItemIndex := 0;
end;

procedure TF_lancamentos.ed_contaAsyncEnter(Sender: TObject;
  EventParams: TStringList);
begin
  LoadCombobox;
end;

{ ... }

procedure TF_lancamentos.bt_incluirAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  LoadCombobox;
  ClearFields;
{ LoadInfo_Conta } // saldo e tipo
  UserSession.query_lancamentos.Insert;
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#EDITAR_DADOS'').modal(''show'');');
  ed_conta.SetFocus;
end;

procedure TF_lancamentos.bt_editarAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  LoadCombobox;
  with UserSession do
  begin
    query_lancamentos.Locate('ID', ed_id.Text, []);
    query_lancamentos.Edit;
    ed_id.Text := query_lancamentos.FieldByName('ID').Value;
    ed_conta.Items[0] := query_lancamentos.FieldByName('CONTA').Value;
    ed_data.Text := query_lancamentos.FieldByName('DATA').AsString;
    ed_historico.Text := query_lancamentos.FieldByName('HISTORICO').Value;
    ed_valor.Text := FloatToStrF(query_lancamentos.FieldByName('VALOR').Value,ffCurrency,10,2);
    if query_lancamentos.FieldByName('TIPO').Value = 'D' then RadioButton_D.Checked := True;
    if query_lancamentos.FieldByName('TIPO').Value = 'C' then RadioButton_C.Checked := True;
  end;
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#EDITAR_DADOS'').modal(''show'');');
end;

procedure TF_lancamentos.bt_excluirClick(Sender: TObject);
begin
  with UserSession do
  begin
    query_lancamentos.Locate('ID', ed_id.Text, []);
    query_lancamentos.Delete;
  end;
  UpdateAll;
end;

procedure TF_lancamentos.bt_buscarClick(Sender: TObject);
begin
  Search;
end;

procedure TF_lancamentos.bt_imprimirAsyncClick(Sender: TObject;
  EventParams: TStringList);
var
	objExportfilter : TfrxCustomExportFilter;
begin
	objExportfilter := TfrxCustomExportFilter(frx_PDF);
	objExportfilter.ShowDialog := False;
	objExportfilter.FileName := GetCurrentDir + '\wwwroot\impressos\frx_financeiro.pdf';
  frx_financeiro.Variables['dt_inicial'] := copy(dt_inicial.Text,9,2)+'/'+copy(dt_inicial.Text,6,2)+'/'+copy(dt_inicial.Text,1,4);
  frx_financeiro.Variables['dt_final'] := copy(dt_final.Text,9,2)+'/'+copy(dt_final.Text,6,2)+'/'+copy(dt_final.Text,1,4);
  frx_financeiro.Variables['valor_total'] := FloatToStrF(v_saldo,ffCurrency,10,2);
  frx_financeiro.Variables['dc'] := v_dc;
  frx_financeiro.PrepareReport(True);
  frx_financeiro.Export(objExportfilter);
  WebApplication.CallBackResponse.AddJavaScriptToExecute('window.open("/impressos/frx_financeiro.pdf");');
end;

procedure TF_lancamentos.bt_okAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  if Trim(ed_historico.Text) = '' then
  begin
    WebApplication.ShowMessage('Favor preencher o campo HISTÓRICO!');
    ed_historico.SetFocus;
    exit;
  end;
  if Trim(ed_valor.Text) = '' then
  begin
    WebApplication.ShowMessage('Favor preencher o campo VALOR!');
    ed_valor.SetFocus;
    exit;
  end;
  SyncFields;
  UserSession.query_lancamentos.Post;
  ClearFields;
  UpdateAll;
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#EDITAR_DADOS'').modal(''hide'');');
  WebApplication.CallBackResponse.AddJavaScriptToExecute('location.reload()');
end;

procedure TF_lancamentos.bt_cancelarClick(Sender: TObject);
begin
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#EDITAR_DADOS'').modal(''hide'');');
end;

end.
