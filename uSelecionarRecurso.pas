unit uSelecionarRecurso;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, FMTBcd, DB, DBClient, Provider, SqlExpr;

type
  TfrmSelecionarRecurso = class(TForm)
    GroupBox1: TGroupBox;
    BitBtn4: TBitBtn;
    BitBtn2: TBitBtn;
    comboSelecionarRecurso: TComboBox;
    SQLRecurso: TSQLDataSet;
    dspRecurso: TDataSetProvider;
    cdsRecurso: TClientDataSet;
    dsGenerator: TDataSource;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
  private

    i_HoraInicio, i_HoraFinal, i_TipoRecurso, i_IdAgendamento: Integer;
    d_Data : TDate;

    { Private declarations }
  public
    { Public declarations }

    constructor Create(AOwner : TComponent; pi_HoraInicio, pi_HoraFinal, pi_TipoRecurso, pi_IdAgendamento  : Integer; pd_Data : TDate);

  end;

var
  frmSelecionarRecurso: TfrmSelecionarRecurso;

implementation

uses uDm, uAgendamento;

{$R *.dfm}

procedure TfrmSelecionarRecurso.BitBtn2Click(Sender: TObject);
begin
   Close;
end;

constructor TfrmSelecionarRecurso.Create(AOwner: TComponent; pi_HoraInicio,
  pi_HoraFinal, pi_TipoRecurso, pi_IdAgendamento: Integer; pd_Data : TDate);
begin
    inherited create(AOwner);

    i_TipoRecurso   := pi_TipoRecurso;
    i_HoraInicio    := pi_HoraInicio;
    i_HoraFinal     := pi_HoraFinal;
    d_Data          := pd_Data;
    i_IdAgendamento := pi_IdAgendamento;

end;

procedure TfrmSelecionarRecurso.FormShow(Sender: TObject);

var
   i  : Integer;
   s: String;

begin

   comboSelecionarRecurso.Items.Clear;

   cdsRecurso.Close;
   with SQLRecurso do begin
       Close;
       ParamByName('IDTIPORECURSO').AsInteger := i_TipoRecurso;
       ParamByName('HORAINICIAL').AsInteger := i_HoraInicio;
       ParamByName('HORAFINAL').AsInteger := i_HoraFinal;
       ParamByName('DATA').AsDate := d_Data;
       Open;
   end;

   cdsRecurso.Open;

   while not cdsRecurso.Eof do begin
      i := cdsRecurso.fieldbyname('IDRECURSO').AsInteger;
      s := cdsRecurso.fieldbyname('DESCRICAORECURSO').AsString;
      comboSelecionarRecurso.Items.AddObject(s, TObject(i));
      cdsRecurso.Next;
   end;

end;

procedure TfrmSelecionarRecurso.BitBtn4Click(Sender: TObject);
begin

   frmAgendamento.cdsRecursoPorAgendamento.Open;
   frmAgendamento.cdsRecursoPorAgendamento.Append;
   frmAgendamento.cdsRecursoPorAgendamentoIDRECURSO.AsInteger := integer(comboSelecionarRecurso.Items.Objects[comboSelecionarRecurso.ItemIndex]);
   frmAgendamento.cdsRecursoPorAgendamentoIDAGENDAMENTO.AsInteger := i_IdAgendamento;
   
   Close;

end;

end.
