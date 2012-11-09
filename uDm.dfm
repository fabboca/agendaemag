object dm: Tdm
  OldCreateOrder = False
  Left = 230
  Top = 128
  Height = 565
  Width = 1205
  object SQLConnection1: TSQLConnection
    ConnectionName = 'Agenda'
    DriverName = 'Interbase'
    GetDriverFunc = 'getSQLDriverINTERBASE'
    LibraryName = 'dbexpint.dll'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=Interbase'
      'Database=localhost:c:\AGENDAEMAG'
      'RoleName=RoleName'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'ServerCharSet='
      'SQLDialect=3'
      'BlobSize=-1'
      'CommitRetain=False'
      'WaitOnLocks=True'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Interbase TransIsolation=ReadCommited'
      'Trim Char=False')
    VendorLib = 'gds32.dll'
    Connected = True
    Left = 56
    Top = 24
  end
  object SQLSessao: TSQLDataSet
    CommandText = 'SELECT * FROM SESSAO ORDER BY DESCRICAOSESSAO'
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnection1
    Left = 144
    Top = 24
  end
  object dspSessao: TDataSetProvider
    DataSet = SQLSessao
    Left = 144
    Top = 88
  end
  object cdsSessao: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspSessao'
    Left = 144
    Top = 144
    object cdsSessaoIDSESSAO: TIntegerField
      FieldName = 'IDSESSAO'
      Required = True
    end
    object cdsSessaoDESCRICAOSESSAO: TStringField
      FieldName = 'DESCRICAOSESSAO'
      Size = 40
    end
    object cdsSessaoEXIGEEXCLUSIVIDADE: TIntegerField
      FieldName = 'EXIGEEXCLUSIVIDADE'
    end
  end
  object dsSessao: TDataSource
    DataSet = cdsSessao
    Left = 144
    Top = 208
  end
  object SQLProfissional: TSQLDataSet
    CommandText = 'SELECT * FROM PROFISSIONAL ORDER BY NOMEPROFISSIONAL'
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnection1
    Left = 224
    Top = 32
  end
  object dspProfissional: TDataSetProvider
    DataSet = SQLProfissional
    Left = 224
    Top = 96
  end
  object cdsProfissional: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspProfissional'
    Left = 224
    Top = 152
    object cdsProfissionalIDPROFISSIONAL: TIntegerField
      FieldName = 'IDPROFISSIONAL'
      Required = True
    end
    object cdsProfissionalNOMEPROFISSIONAL: TStringField
      FieldName = 'NOMEPROFISSIONAL'
      Size = 50
    end
  end
  object dsProfissional: TDataSource
    DataSet = cdsProfissional
    Left = 224
    Top = 216
  end
  object SQLTempoSessao: TSQLDataSet
    CommandText = 
      'SELECT SUM(PROCEDIMENTOSESSAO.DURACAO)'#13#10'   FROM PROCEDIMENTOSESS' +
      'AO'#13#10'   INNER JOIN  SESSAO ON SESSAO.IDSESSAO = PROCEDIMENTOSESSA' +
      'O.IDSESSAO '#13#10'   WHERE SESSAO.IDSESSAO = :idSessao'#13#10
    MaxBlobSize = -1
    Params = <
      item
        DataType = ftInteger
        Name = 'idSessao'
        ParamType = ptInput
      end>
    SQLConnection = SQLConnection1
    Left = 328
    Top = 32
  end
  object dspTempoSessao: TDataSetProvider
    DataSet = SQLTempoSessao
    Left = 328
    Top = 96
  end
  object cdsTempoSessao: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspTempoSessao'
    Left = 328
    Top = 152
  end
  object SQLDiaDaSemana: TSQLDataSet
    CommandText = 'SELECT * FROM DIADASEMANA'#13#10#13#10
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnection1
    Left = 408
    Top = 32
  end
  object dspDiaDaSemana: TDataSetProvider
    DataSet = SQLDiaDaSemana
    Left = 408
    Top = 96
  end
  object cdsDiaDaSemana: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspDiaDaSemana'
    Left = 408
    Top = 152
    object cdsDiaDaSemanaIDDIADASEMANA: TIntegerField
      FieldName = 'IDDIADASEMANA'
      Required = True
    end
    object cdsDiaDaSemanaDESCRICAODIASEMANA: TStringField
      FieldName = 'DESCRICAODIASEMANA'
    end
  end
  object SQLRecurso: TSQLDataSet
    CommandText = 'SELECT * FROM RECURSO'#13#10#13#10#13#10
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnection1
    Left = 504
    Top = 32
  end
  object dspRecurso: TDataSetProvider
    DataSet = SQLRecurso
    Left = 504
    Top = 96
  end
  object cdsRecurso: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspRecurso'
    Left = 504
    Top = 152
    object cdsRecursoIDRECURSO: TIntegerField
      FieldName = 'IDRECURSO'
      Required = True
    end
    object cdsRecursoDESCRICAORECURSO: TStringField
      FieldName = 'DESCRICAORECURSO'
      Size = 40
    end
    object cdsRecursoIDTIPORECURSO: TIntegerField
      FieldName = 'IDTIPORECURSO'
    end
  end
  object SQLAgendamento: TSQLDataSet
    CommandText = 'SELECT * FROM AGENDAMENTO'#13#10'      '#13#10#13#10#13#10
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnection1
    Left = 592
    Top = 32
  end
  object dspAgendamento: TDataSetProvider
    DataSet = SQLAgendamento
    Left = 592
    Top = 96
  end
  object cdsAgendamento: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspAgendamento'
    Left = 592
    Top = 152
    object cdsAgendamentoIDAGENDAMENTO: TIntegerField
      FieldName = 'IDAGENDAMENTO'
      Required = True
    end
    object cdsAgendamentoDATA: TDateField
      FieldName = 'DATA'
    end
    object cdsAgendamentoHORAINICIO: TIntegerField
      FieldName = 'HORAINICIO'
    end
    object cdsAgendamentoHORAFINAL: TIntegerField
      FieldName = 'HORAFINAL'
    end
    object cdsAgendamentoIDPROFISSIONAL: TIntegerField
      FieldName = 'IDPROFISSIONAL'
    end
    object cdsAgendamentoIDSESSAO: TIntegerField
      FieldName = 'IDSESSAO'
    end
    object cdsAgendamentoIDCLIENTE: TIntegerField
      FieldName = 'IDCLIENTE'
    end
    object cdsAgendamentoEXIGEEXCLUSIVIDADE: TIntegerField
      FieldName = 'EXIGEEXCLUSIVIDADE'
    end
  end
  object SQLRecursoPorAgendamento: TSQLDataSet
    CommandText = 
      'SELECT * FROM RECURSOPORAGENDAMENTO'#13#10'      WHERE IDRECURSOPORAGE' +
      'NDAMENTO = 1'#13#10#13#10#13#10
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnection1
    Left = 720
    Top = 32
    object SQLRecursoPorAgendamentoIDRECURSOPORAGENDAMENTO: TIntegerField
      FieldName = 'IDRECURSOPORAGENDAMENTO'
      ProviderFlags = []
    end
    object SQLRecursoPorAgendamentoIDRECURSO: TIntegerField
      FieldName = 'IDRECURSO'
    end
    object SQLRecursoPorAgendamentoIDAGENDAMENTO: TIntegerField
      FieldName = 'IDAGENDAMENTO'
    end
  end
  object dspRecursoPorAgendamento: TDataSetProvider
    DataSet = SQLRecursoPorAgendamento
    Left = 720
    Top = 96
  end
  object cdsRecursoPorAgendamento: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspRecursoPorAgendamento'
    Left = 720
    Top = 152
    object cdsRecursoPorAgendamentoIDRECURSOPORAGENDAMENTO: TIntegerField
      FieldName = 'IDRECURSOPORAGENDAMENTO'
      ProviderFlags = []
    end
    object cdsRecursoPorAgendamentoIDRECURSO: TIntegerField
      FieldName = 'IDRECURSO'
    end
    object cdsRecursoPorAgendamentoIDAGENDAMENTO: TIntegerField
      FieldName = 'IDAGENDAMENTO'
    end
  end
  object SQLTipoRecursoPorSessao: TSQLDataSet
    CommandText = 'SELECT * FROM TIPORECURSOPORSESSAO'#13#10'      '#13#10#13#10#13#10
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnection1
    Left = 872
    Top = 32
  end
  object dspTipoRecursoPorSessao: TDataSetProvider
    DataSet = SQLTipoRecursoPorSessao
    Left = 872
    Top = 88
  end
  object cdsTipoRecursoPorSessao: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspTipoRecursoPorSessao'
    OnCalcFields = cdsTipoRecursoPorSessaoCalcFields
    Left = 872
    Top = 144
    object cdsTipoRecursoPorSessaoIDSESSAO: TIntegerField
      FieldName = 'IDSESSAO'
    end
    object cdsTipoRecursoPorSessaoIDTIPORECURSO: TIntegerField
      FieldName = 'IDTIPORECURSO'
    end
    object cdsTipoRecursoPorSessaoIDTIPORECURSOPORSESSAO: TIntegerField
      FieldName = 'IDTIPORECURSOPORSESSAO'
      Required = True
    end
    object cdsTipoRecursoPorSessaodescricaoTipoRecurso: TStringField
      FieldKind = fkCalculated
      FieldName = 'descricaoTipoRecurso'
      Size = 50
      Calculated = True
    end
  end
  object SQLAusencias: TSQLDataSet
    CommandText = 'SELECT * FROM AUSENCIAS'
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnection1
    Left = 992
    Top = 40
  end
  object dspAusencias: TDataSetProvider
    DataSet = SQLAusencias
    Left = 992
    Top = 96
  end
  object cdsAusencias: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspAusencias'
    Left = 992
    Top = 152
    object cdsAusenciasIDAUSENCIA: TIntegerField
      FieldName = 'IDAUSENCIA'
      Required = True
    end
    object cdsAusenciasIDPROFISSIONAL: TIntegerField
      FieldName = 'IDPROFISSIONAL'
    end
    object cdsAusenciasDATA: TDateField
      FieldName = 'DATA'
    end
    object cdsAusenciasDIATODO: TIntegerField
      FieldName = 'DIATODO'
    end
    object cdsAusenciasHORAINICIO1: TIntegerField
      FieldName = 'HORAINICIO1'
    end
    object cdsAusenciasHORAFINAL1: TIntegerField
      FieldName = 'HORAFINAL1'
    end
  end
  object dsTipoRecursoPorSessao: TDataSource
    DataSet = cdsTipoRecursoPorSessao
    Left = 872
    Top = 208
  end
  object SQLTipoRecurso: TSQLDataSet
    CommandText = 'SELECT * FROM TIPORECURSO'
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnection1
    Left = 144
    Top = 272
  end
  object dspTipoRecurso: TDataSetProvider
    DataSet = SQLTipoRecurso
    Left = 144
    Top = 336
  end
  object cdsTipoRecurso: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspTipoRecurso'
    Left = 144
    Top = 392
    object cdsTipoRecursoIDTIPORECURSO: TIntegerField
      FieldName = 'IDTIPORECURSO'
      Required = True
    end
    object cdsTipoRecursoDESCRICAOTIPORECURSO: TStringField
      FieldName = 'DESCRICAOTIPORECURSO'
      Size = 40
    end
  end
  object qryGenerator: TSQLDataSet
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnection1
    Left = 248
    Top = 272
  end
  object dspGenerator: TDataSetProvider
    DataSet = qryGenerator
    Left = 248
    Top = 328
  end
  object cdsGenerator: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspGenerator'
    Left = 248
    Top = 392
  end
  object dsGenerator: TDataSource
    DataSet = cdsGenerator
    Left = 248
    Top = 456
  end
end
