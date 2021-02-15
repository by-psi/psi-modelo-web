unit UserSessionUnit;

{
  This is a DataModule where you can add components or declare fields that are specific to
  ONE user. Instead of creating global variables, it is better to use this datamodule. You can then
  access the it using UserSession.
}
interface

uses
  IWUserSessionBase, SysUtils, Classes, IniFiles,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TF_session = class(TIWUserSessionBase)
    query_vendas: TFDQuery;
    query_itensdevenda: TFDQuery;
    query_login: TFDQuery;
    query_loginID: TFDAutoIncField;
    query_loginNOME: TStringField;
    query_loginFUNCAO: TStringField;
    query_loginUSUARIO: TStringField;
    query_loginSENHA: TStringField;
    query_loginNIVEL: TIntegerField;
    query_usuarios: TFDQuery;
    FDAutoIncField1: TFDAutoIncField;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    IntegerField1: TIntegerField;
    query_produtos: TFDQuery;
    query_produtosID: TIntegerField;
    query_produtosPRODUTO: TStringField;
    query_produtosIMAGEM: TStringField;
    query_produtosUNIDADE: TStringField;
    query_produtosESTQ_ATUAL: TIntegerField;
    query_produtosVALOR: TFloatField;
    query_produtosID_FORNECEDOR: TIntegerField;
    query_fornecedores: TFDQuery;
    query_fornecedoresID: TFDAutoIncField;
    query_fornecedoresFORNECEDOR: TStringField;
    query_fornecedoresEMAIL: TStringField;
    query_fornecedoresTELEFONE: TStringField;
    query_lancamentos: TFDQuery;
    query_lancamentosID: TFDAutoIncField;
    query_lancamentosID_CONTA: TIntegerField;
    query_lancamentosDATA: TDateField;
    query_lancamentosHISTORICO: TStringField;
    query_lancamentosVALOR: TFloatField;
    query_contas: TFDQuery;
    query_contasID: TFDAutoIncField;
    query_contasCONTA: TStringField;
    query_contasSALDO: TFloatField;
    query_contasDC: TStringField;
    query_vendasID: TFDAutoIncField;
    query_vendasID_USUARIO: TIntegerField;
    query_vendasDATA: TDateField;
    query_vendasCHV: TStringField;
    query_itensdevendaID: TFDAutoIncField;
    query_itensdevendaID_VENDA: TIntegerField;
    query_itensdevendaID_PRODUTO: TIntegerField;
    query_itensdevendaQTD: TIntegerField;
    query_itensdevendaVALOR_UN: TFloatField;
    query_itensdevendaVALOR_TOTAL: TFloatField;
    query_itensdevendaID_USUARIO: TIntegerField;
    query_produtosFORNECEDOR: TStringField;
    query_vendasUSUARIO: TStringField;
    query_itensdevendaPRODUTO: TStringField;
    query_itensdevendaUSUARIO: TStringField;
    query_lancamentosCONTA: TStringField;
    query_vendasVALOR_TOTAL: TFloatField;
    query_lancamentosTIPO: TStringField;
    query_lancamentosID_USUARIO: TIntegerField;
    DriverLink_1: TFDPhysMySQLDriverLink;
    Query_1: TFDQuery;
    Query_1ID: TFDAutoIncField;
    Query_1PRODUTO: TStringField;
    Query_1IMAGEM: TStringField;
    Query_1ESTQ_ATUAL: TIntegerField;
    Query_1UNIDADE: TStringField;
    Query_1VALOR: TFloatField;
    Query_1ID_FORNECEDOR: TIntegerField;
    Query_1FORNECEDOR: TStringField;
    Connection_1: TFDConnection;

    procedure IWUserSessionBaseCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  FDriverID,
  FDatabase, FServer, FPort,
  FUser, FPassword,
  FileName,
  chv: string;
  ArqIni: TIniFile;

  USR_ID: string;
  USRNAME: string;
  USRFUNCTION: string;
  USRLEVEL: string;

implementation

{$R *.dfm}

{ TF_session }

procedure TF_session.IWUserSessionBaseCreate(Sender: TObject);
begin
  try
    FileName := ChangeFileExt(ParamStr(0), '.ini');
    ArqINI := TIniFile.Create(FileName);

    if not FileExists(FileName) then
    begin
      ArqINI.WriteString('DB', 'driver', 'MySQL');
      ArqINI.WriteString('DB', 'server', 'localhost');
      ArqINI.WriteString('DB', 'database', 'modelo_web');
      ArqINI.WriteString('DB', 'user', 'root');
      ArqINI.UpdateFile;
    end;

    FDriverID := ArqINI.ReadString('DB', 'driver', chv);
    FServer := ArqINI.ReadString('DB', 'server', chv);
    FPort := '3306';
    FDatabase := ArqINI.ReadString('DB' , 'database', chv);
    FUser := ArqINI.ReadString('DB', 'user', chv);
    FPassword := '';

    ArqINI.Free;

    Connection_1.Params.Values['DriverID'] := FDriverID;
    Connection_1.Params.Values['Server'  ] := FServer;
    Connection_1.Params.Values['Port'    ] := FPort;
    Connection_1.Params.Values['Database'] := FDatabase;
    Connection_1.Params.Values['User_Name']:= FUser;
    Connection_1.Params.Values['Password'] := FPassword;

    query_login.Active := True;
    query_usuarios.Active := True;
    query_fornecedores.Active := True;
    query_produtos.Active := True;
    query_vendas.Active := True;
    query_itensdevenda.Active := True;
    query_contas.Active := True;
    query_lancamentos.Active := True;
    Query_1.Active := True;
  except
    WebApplication.ShowMessage('Erro ao conectar o banco de dados!');
  end;

end;

end.
