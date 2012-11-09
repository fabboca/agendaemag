program AgendaEmag;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain},
  uDm in 'uDm.pas' {dm: TDataModule},
  uAgendamentoAvulso in 'uAgendamentoAvulso.pas' {frmAgendamentoAvulso},
  uAgendamento in 'uAgendamento.pas' {frmAgendamento},
  uFuncoes in 'uFuncoes.pas',
  uSelecionarRecurso in 'uSelecionarRecurso.pas' {frmSelecionarRecurso};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfrmSelecionarRecurso, frmSelecionarRecurso);
  //Application.CreateForm(TfrmAgendamento, frmAgendamento);
  //Application.CreateForm(TfrmAgendamentoAvulso, frmAgendamentoAvulso);
  Application.Run;
end.
