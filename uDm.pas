unit uDm;

interface

uses
  SysUtils, Classes, DBXpress, FMTBcd, DB, SqlExpr, DBClient, Provider;

type
  Tdm = class(TDataModule)
    SQLConnection1: TSQLConnection;
    SQLSessao: TSQLDataSet;
    dspSessao: TDataSetProvider;
    cdsSessao: TClientDataSet;
    cdsSessaoIDSESSAO: TIntegerField;
    cdsSessaoDESCRICAOSESSAO: TStringField;
    dsSessao: TDataSource;
    SQLProfissional: TSQLDataSet;
    dspProfissional: TDataSetProvider;
    cdsProfissional: TClientDataSet;
    dsProfissional: TDataSource;
    cdsProfissionalIDPROFISSIONAL: TIntegerField;
    cdsProfissionalNOMEPROFISSIONAL: TStringField;
    SQLTempoSessao: TSQLDataSet;
    dspTempoSessao: TDataSetProvider;
    cdsTempoSessao: TClientDataSet;
    SQLDiaDaSemana: TSQLDataSet;
    dspDiaDaSemana: TDataSetProvider;
    cdsDiaDaSemana: TClientDataSet;
    cdsDiaDaSemanaIDDIADASEMANA: TIntegerField;
    cdsDiaDaSemanaDESCRICAODIASEMANA: TStringField;
    SQLRecurso: TSQLDataSet;
    dspRecurso: TDataSetProvider;
    cdsRecurso: TClientDataSet;
    cdsRecursoIDRECURSO: TIntegerField;
    cdsRecursoDESCRICAORECURSO: TStringField;
    cdsRecursoIDTIPORECURSO: TIntegerField;
    SQLAgendamento: TSQLDataSet;
    dspAgendamento: TDataSetProvider;
    cdsAgendamento: TClientDataSet;
    cdsAgendamentoIDAGENDAMENTO: TIntegerField;
    cdsAgendamentoDATA: TDateField;
    cdsAgendamentoHORAINICIO: TIntegerField;
    cdsAgendamentoHORAFINAL: TIntegerField;
    cdsAgendamentoIDPROFISSIONAL: TIntegerField;
    cdsAgendamentoIDSESSAO: TIntegerField;
    cdsAgendamentoIDCLIENTE: TIntegerField;
    SQLRecursoPorAgendamento: TSQLDataSet;
    dspRecursoPorAgendamento: TDataSetProvider;
    cdsRecursoPorAgendamento: TClientDataSet;
    cdsRecursoPorAgendamentoIDRECURSOPORAGENDAMENTO: TIntegerField;
    cdsRecursoPorAgendamentoIDRECURSO: TIntegerField;
    cdsRecursoPorAgendamentoIDAGENDAMENTO: TIntegerField;
    SQLTipoRecursoPorSessao: TSQLDataSet;
    dspTipoRecursoPorSessao: TDataSetProvider;
    cdsTipoRecursoPorSessao: TClientDataSet;
    cdsTipoRecursoPorSessaoIDSESSAO: TIntegerField;
    cdsTipoRecursoPorSessaoIDTIPORECURSO: TIntegerField;
    cdsTipoRecursoPorSessaoIDTIPORECURSOPORSESSAO: TIntegerField;
    SQLAusencias: TSQLDataSet;
    dspAusencias: TDataSetProvider;
    cdsAusencias: TClientDataSet;
    cdsAusenciasIDAUSENCIA: TIntegerField;
    cdsAusenciasIDPROFISSIONAL: TIntegerField;
    cdsAusenciasDATA: TDateField;
    cdsAusenciasDIATODO: TIntegerField;
    cdsAusenciasHORAINICIO1: TIntegerField;
    cdsAusenciasHORAFINAL1: TIntegerField;
    dsTipoRecursoPorSessao: TDataSource;
    cdsTipoRecursoPorSessaodescricaoTipoRecurso: TStringField;
    SQLTipoRecurso: TSQLDataSet;
    dspTipoRecurso: TDataSetProvider;
    cdsTipoRecurso: TClientDataSet;
    cdsTipoRecursoIDTIPORECURSO: TIntegerField;
    cdsTipoRecursoDESCRICAOTIPORECURSO: TStringField;
    qryGenerator: TSQLDataSet;
    dspGenerator: TDataSetProvider;
    cdsGenerator: TClientDataSet;
    dsGenerator: TDataSource;
    SQLRecursoPorAgendamentoIDRECURSOPORAGENDAMENTO: TIntegerField;
    SQLRecursoPorAgendamentoIDRECURSO: TIntegerField;
    SQLRecursoPorAgendamentoIDAGENDAMENTO: TIntegerField;
    cdsAgendamentoEXIGEEXCLUSIVIDADE: TIntegerField;
    cdsSessaoEXIGEEXCLUSIVIDADE: TIntegerField;
    procedure cdsTipoRecursoPorSessaoCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

uses uFuncoes;

{$R *.dfm}

procedure Tdm.cdsTipoRecursoPorSessaoCalcFields(DataSet: TDataSet);
begin
   cdsTipoRecursoPorSessaodescricaoTipoRecurso.AsString := buscaDescricaoTipoRecurso(cdsTipoRecursoPorSessaoIDTIPORECURSO.AsInteger);
end;

end.
