unit uAgendamento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, FMTBcd, DBClient, Provider,
  DB, SqlExpr;

type
  TfrmAgendamento = class(TForm)
    GroupBox1: TGroupBox;
    BitBtn2: TBitBtn;
    BitBtn4: TBitBtn;
    GroupBox2: TGroupBox;
    lblData: TLabel;
    GroupBox3: TGroupBox;
    lblProfissional: TLabel;
    GroupBox4: TGroupBox;
    lblHoraInicio: TLabel;
    GroupBox5: TGroupBox;
    lblHoraFinal: TLabel;
    GroupBox6: TGroupBox;
    lblCliente: TLabel;
    GroupBox7: TGroupBox;
    lblSessao: TLabel;
    GroupBox8: TGroupBox;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    GroupBox9: TGroupBox;
    lblIdAgendamento: TLabel;
    BitBtn1: TBitBtn;
    SQLRecursoPorAgendamento: TSQLDataSet;
    SQLRecursoPorAgendamentoIDRECURSOPORAGENDAMENTO: TIntegerField;
    SQLRecursoPorAgendamentoIDRECURSO: TIntegerField;
    SQLRecursoPorAgendamentoIDAGENDAMENTO: TIntegerField;
    dspRecursoPorAgendamento: TDataSetProvider;
    cdsRecursoPorAgendamento: TClientDataSet;
    cdsRecursoPorAgendamentoIDRECURSOPORAGENDAMENTO: TIntegerField;
    cdsRecursoPorAgendamentoIDRECURSO: TIntegerField;
    cdsRecursoPorAgendamentoIDAGENDAMENTO: TIntegerField;
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
    cdsAgendamentoEXIGEEXCLUSIVIDADE: TIntegerField;
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }

    i_idProfissional, i_HoraiInicial, i_HoraFinal, i_sessao : Integer;
    d_Data : TDate;

  public
    { Public declarations }

     constructor Create(AOwner : TComponent; pd_Data: TDate; pi_IdProfissional, pi_horaInicial, pi_HoraFinal, pi_Sessao  : Integer);

  end;

var
  frmAgendamento: TfrmAgendamento;

implementation

uses uDm, uFuncoes, uSelecionarRecurso;

{$R *.dfm}

{ TfrmAgendamento }


{ TfrmAgendamento }

constructor TfrmAgendamento.Create(AOwner: TComponent; pd_Data: TDate;
  pi_IdProfissional, pi_horaInicial, pi_HoraFinal, pi_sessao: Integer);
begin
   inherited create(AOwner);

   d_Data := pd_Data;
   i_IdProfissional := pi_IdProfissional;
   i_HoraiInicial := pi_horaInicial;
   i_HoraFinal := pi_HoraFinal;
   i_sessao := pi_Sessao;

end;

procedure TfrmAgendamento.FormShow(Sender: TObject);

var i_IDAgendamento : Integer;

begin

   i_IDAgendamento := BuscarGenerator('GEN_AGENDAMENTO_ID');
   lblIdAgendamento.Caption := IntToStr(i_IDAgendamento);

   lblData.Caption := DateToStr((d_Data));
   lblProfissional.Caption := buscaNomeProfissional(i_idProfissional);
   lblHoraInicio.Caption := retornaHora(i_HoraiInicial);
   lblHoraFinal.Caption := retornaHora(i_HoraFinal);
   lblSessao.Caption := buscaNomeSessao(i_sessao);

   dm.cdsTipoRecursoPorSessao.Close;
   with dm.SQLTipoRecursoPorSessao do begin
      Close;
      CommandText := 'SELECT * FROM TIPORECURSOPORSESSAO WHERE IDSESSAO = :IDSESSAO';
      Params[0].AsInteger := i_sessao;
      Open;
   end;
   dm.cdsTipoRecursoPorSessao.Open;
   {
   dm.cdsRecursoPorAgendamento.Close;
   with dm.SQLRecursoPorAgendamento do begin
      Close;
      CommandText := 'SELECT * FROM RECURSOPORAGENDAMENTO WHERE IDAGENDAMENTO = :IDAGENDAMENTO';
      Params[0].AsInteger := i_sessao;
      Open;
   end;
   dm.cdsRecursoPorAgendamento.Open;
    }

end;

procedure TfrmAgendamento.BitBtn2Click(Sender: TObject);
begin
   Close;
end;

procedure TfrmAgendamento.BitBtn4Click(Sender: TObject);
begin

   cdsAgendamento.Open;

   cdsAgendamento.Append;

   cdsAgendamentoIDAGENDAMENTO.AsInteger  := StrToInt(lblIdAgendamento.Caption);
   cdsAgendamentoHORAINICIO.AsInteger     := i_HoraiInicial;
   cdsAgendamentoHORAFINAL.AsInteger      := i_HoraFinal;
   cdsAgendamentoDATA.AsDateTime          := d_Data;
   cdsAgendamentoIDPROFISSIONAL.AsInteger := i_idProfissional;
   cdsAgendamentoIDSESSAO.AsInteger       := i_sessao;
   CdsAgendamentoIDCLIENTE.AsInteger      := 1;
   cdsAgendamentoEXIGEEXCLUSIVIDADE.AsInteger := dm.cdsSessaoEXIGEEXCLUSIVIDADE.AsInteger;

   cdsAgendamento.ApplyUpdates(-1);
   cdsRecursoPorAgendamento.ApplyUpdates(-1);


end;

procedure TfrmAgendamento.BitBtn1Click(Sender: TObject);
begin
   {
   dm.cdsSessao.Close;
   with dm.SQLSessao do begin
      Close;
      CommandText := 'SELECT * FROM SESSAO WHERE IDSESSAO = :IDSESSAO';
      Params[0].AsInteger := i_sessao;
      Open;
   end;
   dm.cdsSessao.Open;
   }
   
   with TfrmSelecionarRecurso.Create(Self,
                                     i_HoraiInicial,
                                     i_HoraFinal,
                                     dm.cdsTipoRecursoPorSessaoIDTIPORECURSO.AsInteger,
                                     StrToInt(lblIdAgendamento.Caption),
                                     StrToDate(lblData.Caption))  do begin
      ShowModal;
      Free;
   end;
end;

end.
