object F_session: TF_session
  OldCreateOrder = False
  OnCreate = IWUserSessionBaseCreate
  Height = 268
  Width = 433
  object query_vendas: TFDQuery
    Connection = Connection_1
    SQL.Strings = (
      'SELECT * FROM t_vendas')
    Left = 232
    Top = 64
    object query_vendasID: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object query_vendasID_USUARIO: TIntegerField
      FieldName = 'ID_USUARIO'
      Origin = 'ID_USUARIO'
      Required = True
    end
    object query_vendasDATA: TDateField
      FieldName = 'DATA'
      Origin = 'DATA'
      Required = True
    end
    object query_vendasVALOR_TOTAL: TFloatField
      FieldName = 'VALOR_TOTAL'
      Origin = 'VALOR_TOTAL'
      Required = True
    end
    object query_vendasCHV: TStringField
      FieldName = 'CHV'
      Origin = 'CHV'
      Required = True
      Size = 1
    end
    object query_vendasUSUARIO: TStringField
      FieldKind = fkLookup
      FieldName = 'USUARIO'
      LookupDataSet = query_usuarios
      LookupKeyFields = 'ID'
      LookupResultField = 'USUARIO'
      KeyFields = 'ID_USUARIO'
      Size = 35
      Lookup = True
    end
  end
  object query_itensdevenda: TFDQuery
    Connection = Connection_1
    SQL.Strings = (
      'SELECT * FROM t_itensdevenda')
    Left = 336
    Top = 64
    object query_itensdevendaID: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object query_itensdevendaID_VENDA: TIntegerField
      FieldName = 'ID_VENDA'
      Origin = 'ID_VENDA'
      Required = True
    end
    object query_itensdevendaID_PRODUTO: TIntegerField
      FieldName = 'ID_PRODUTO'
      Origin = 'ID_PRODUTO'
      Required = True
    end
    object query_itensdevendaQTD: TIntegerField
      FieldName = 'QTD'
      Origin = 'QTD'
      Required = True
    end
    object query_itensdevendaVALOR_UN: TFloatField
      FieldName = 'VALOR_UN'
      Origin = 'VALOR_UN'
      Required = True
    end
    object query_itensdevendaVALOR_TOTAL: TFloatField
      FieldName = 'VALOR_TOTAL'
      Origin = 'VALOR_TOTAL'
      Required = True
    end
    object query_itensdevendaID_USUARIO: TIntegerField
      FieldName = 'ID_USUARIO'
      Origin = 'ID_USUARIO'
      Required = True
    end
    object query_itensdevendaPRODUTO: TStringField
      FieldKind = fkLookup
      FieldName = 'PRODUTO'
      LookupDataSet = query_produtos
      LookupKeyFields = 'ID'
      LookupResultField = 'PRODUTO'
      KeyFields = 'ID_PRODUTO'
      Size = 35
      Lookup = True
    end
    object query_itensdevendaUSUARIO: TStringField
      FieldKind = fkLookup
      FieldName = 'USUARIO'
      LookupDataSet = query_usuarios
      LookupKeyFields = 'ID'
      LookupResultField = 'USUARIO'
      KeyFields = 'ID_USUARIO'
      Size = 35
      Lookup = True
    end
  end
  object query_login: TFDQuery
    Connection = Connection_1
    SQL.Strings = (
      
        'select * from t_usuarios where USUARIO = :USUARIO and SENHA = PA' +
        'SSWORD(md5(:SENHA))')
    Left = 40
    Top = 16
    ParamData = <
      item
        Name = 'USUARIO'
        DataType = ftString
        ParamType = ptInput
        Value = 'SUPORTE'
      end
      item
        Name = 'SENHA'
        DataType = ftString
        ParamType = ptInput
        Value = '121247'
      end>
    object query_loginID: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object query_loginNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Required = True
      Size = 35
    end
    object query_loginFUNCAO: TStringField
      FieldName = 'FUNCAO'
      Origin = 'FUNCAO'
      Required = True
      Size = 18
    end
    object query_loginUSUARIO: TStringField
      FieldName = 'USUARIO'
      Origin = 'USUARIO'
      Required = True
    end
    object query_loginSENHA: TStringField
      FieldName = 'SENHA'
      Origin = 'SENHA'
      Required = True
      Size = 100
    end
    object query_loginNIVEL: TIntegerField
      FieldName = 'NIVEL'
      Origin = 'NIVEL'
      Required = True
    end
  end
  object query_usuarios: TFDQuery
    Connection = Connection_1
    SQL.Strings = (
      'select * from t_usuarios where NOME like :NOME order by NOME asc')
    Left = 136
    Top = 16
    ParamData = <
      item
        Name = 'NOME'
        DataType = ftString
        ParamType = ptInput
        Value = '%%'
      end>
    object FDAutoIncField1: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object StringField1: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Required = True
      Size = 35
    end
    object StringField2: TStringField
      FieldName = 'FUNCAO'
      Origin = 'FUNCAO'
      Required = True
      Size = 18
    end
    object StringField3: TStringField
      FieldName = 'USUARIO'
      Origin = 'USUARIO'
      Required = True
    end
    object StringField4: TStringField
      FieldName = 'SENHA'
      Origin = 'SENHA'
      Required = True
      Size = 100
    end
    object IntegerField1: TIntegerField
      FieldName = 'NIVEL'
      Origin = 'NIVEL'
      Required = True
    end
  end
  object query_produtos: TFDQuery
    AutoCalcFields = False
    Connection = Connection_1
    SQL.Strings = (
      
        'SELECT P.ID, P.PRODUTO, P.IMAGEM, P.UNIDADE, P.ESTQ_ATUAL, P.VAL' +
        'OR, P.ID_FORNECEDOR, F.FORNECEDOR FROM t_produtos AS P INNER JOI' +
        'N t_fornecedores AS F ON P.ID_FORNECEDOR = F.ID ORDER BY P.PRODU' +
        'TO ASC ')
    Left = 136
    Top = 64
    object query_produtosID: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object query_produtosPRODUTO: TStringField
      FieldName = 'PRODUTO'
      Origin = 'PRODUTO'
      Required = True
      Size = 35
    end
    object query_produtosIMAGEM: TStringField
      FieldName = 'IMAGEM'
      Origin = 'IMAGEM'
      Required = True
      Size = 100
    end
    object query_produtosUNIDADE: TStringField
      FieldName = 'UNIDADE'
      Origin = 'UNIDADE'
      Required = True
      Size = 2
    end
    object query_produtosESTQ_ATUAL: TIntegerField
      FieldName = 'ESTQ_ATUAL'
      Origin = 'ESTQ_ATUAL'
      Required = True
    end
    object query_produtosVALOR: TFloatField
      FieldName = 'VALOR'
      Origin = 'VALOR'
      Required = True
    end
    object query_produtosID_FORNECEDOR: TIntegerField
      FieldName = 'ID_FORNECEDOR'
      Origin = 'ID_FORNECEDOR'
      Required = True
    end
    object query_produtosFORNECEDOR: TStringField
      FieldKind = fkLookup
      FieldName = 'FORNECEDOR'
      LookupDataSet = query_fornecedores
      LookupKeyFields = 'ID'
      LookupResultField = 'FORNECEDOR'
      KeyFields = 'ID_FORNECEDOR'
      Size = 35
      Lookup = True
    end
  end
  object query_fornecedores: TFDQuery
    Connection = Connection_1
    SQL.Strings = (
      'SELECT * FROM t_fornecedores ORDER BY FORNECEDOR ASC')
    Left = 40
    Top = 64
    object query_fornecedoresID: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object query_fornecedoresFORNECEDOR: TStringField
      FieldName = 'FORNECEDOR'
      Origin = 'FORNECEDOR'
      Required = True
      Size = 35
    end
    object query_fornecedoresEMAIL: TStringField
      FieldName = 'EMAIL'
      Origin = 'EMAIL'
      Required = True
      Size = 60
    end
    object query_fornecedoresTELEFONE: TStringField
      FieldName = 'TELEFONE'
      Origin = 'TELEFONE'
      Required = True
      Size = 18
    end
  end
  object query_lancamentos: TFDQuery
    Connection = Connection_1
    SQL.Strings = (
      
        'SELECT L.ID, L.DATA, L.ID_CONTA, C.CONTA, L.HISTORICO, L.VALOR, ' +
        'L.TIPO, L.ID_USUARIO FROM t_lancamentos AS L '
      'INNER JOIN t_contas AS C ON L.ID_CONTA = C.ID '
      'ORDER BY L.DATA ')
    Left = 136
    Top = 112
    object query_lancamentosID: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object query_lancamentosID_CONTA: TIntegerField
      FieldName = 'ID_CONTA'
      Origin = 'ID_CONTA'
      Required = True
    end
    object query_lancamentosDATA: TDateField
      FieldName = 'DATA'
      Origin = 'DATA'
      Required = True
    end
    object query_lancamentosHISTORICO: TStringField
      FieldName = 'HISTORICO'
      Origin = 'HISTORICO'
      Required = True
      Size = 100
    end
    object query_lancamentosVALOR: TFloatField
      FieldName = 'VALOR'
      Origin = 'VALOR'
      Required = True
    end
    object query_lancamentosTIPO: TStringField
      FieldName = 'TIPO'
      Origin = 'TIPO'
      Required = True
      Size = 1
    end
    object query_lancamentosID_USUARIO: TIntegerField
      FieldName = 'ID_USUARIO'
      Origin = 'ID_USUARIO'
      Required = True
    end
    object query_lancamentosCONTA: TStringField
      DisplayWidth = 30
      FieldKind = fkLookup
      FieldName = 'CONTA'
      LookupDataSet = query_contas
      LookupKeyFields = 'ID'
      LookupResultField = 'CONTA'
      KeyFields = 'ID_CONTA'
      Size = 30
      Lookup = True
    end
  end
  object query_contas: TFDQuery
    Connection = Connection_1
    SQL.Strings = (
      'SELECT * FROM t_contas ORDER BY DC DESC,ID ASC')
    Left = 40
    Top = 112
    object query_contasID: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object query_contasCONTA: TStringField
      FieldName = 'CONTA'
      Origin = 'CONTA'
      Required = True
      Size = 30
    end
    object query_contasSALDO: TFloatField
      FieldName = 'SALDO'
      Origin = 'SALDO'
      Required = True
    end
    object query_contasDC: TStringField
      FieldName = 'DC'
      Origin = 'DC'
      Required = True
      Size = 1
    end
  end
  object DriverLink_1: TFDPhysMySQLDriverLink
    VendorLib = 'wwwroot\libmysql.dll'
    Left = 136
    Top = 184
  end
  object Query_1: TFDQuery
    Connection = Connection_1
    SQL.Strings = (
      'SELECT * FROM t_produtos ORDER BY PRODUTO ASC')
    Left = 232
    Top = 120
    object Query_1ID: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object Query_1PRODUTO: TStringField
      FieldName = 'PRODUTO'
      Origin = 'PRODUTO'
      Required = True
      Size = 35
    end
    object Query_1IMAGEM: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'IMAGEM'
      Origin = 'IMAGEM'
      Size = 100
    end
    object Query_1ESTQ_ATUAL: TIntegerField
      FieldName = 'ESTQ_ATUAL'
      Origin = 'ESTQ_ATUAL'
      Required = True
    end
    object Query_1UNIDADE: TStringField
      FieldName = 'UNIDADE'
      Origin = 'UNIDADE'
      Required = True
      Size = 2
    end
    object Query_1VALOR: TFloatField
      FieldName = 'VALOR'
      Origin = 'VALOR'
      Required = True
    end
    object Query_1ID_FORNECEDOR: TIntegerField
      FieldName = 'ID_FORNECEDOR'
      Origin = 'ID_FORNECEDOR'
      Required = True
    end
    object Query_1FORNECEDOR: TStringField
      FieldKind = fkLookup
      FieldName = 'FORNECEDOR'
      LookupDataSet = query_fornecedores
      LookupKeyFields = 'ID'
      LookupResultField = 'FORNECEDOR'
      KeyFields = 'ID_FORNECEDOR'
      Size = 35
      Lookup = True
    end
  end
  object Connection_1: TFDConnection
    Params.Strings = (
      'Database=modelo_web'
      'User_Name=root'
      'Server=localhost'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 40
    Top = 184
  end
end
