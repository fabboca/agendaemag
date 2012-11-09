unit uAgendamentoAvulso;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, ComCtrls, Mask, ToolEdit, Buttons, Grids,
  DBGrids, XPMan, FMTBcd, DBClient, Provider, DB, SqlExpr;

type
  TfrmAgendamentoAvulso = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BitBtn4: TBitBtn;
    BitBtn2: TBitBtn;
    comboSessao: TComboBox;
    comboProfissional: TComboBox;
    DateTimePicker1: TDateTimePicker;
    XPManifest1: TXPManifest;
    GroupBox2: TGroupBox;
    lblPrevisto: TLabel;
    SQLProfissionalHabilitadosNoDia: TSQLDataSet;
    dspProfissionaisHabilitadosNoDia: TDataSetProvider;
    cdsProfissionaisHabilitadosNodia: TClientDataSet;
    cdsHorarioDisponivel: TClientDataSet;
    cdsHorarioDisponivelidProfissional: TIntegerField;
    cdsHorarioDisponivelhoraInicio: TIntegerField;
    cdsHorarioDisponivelhoraFinal: TIntegerField;
    SQLAgendamento: TSQLDataSet;
    dspAgendamento: TDataSetProvider;
    cdsAgendamento: TClientDataSet;
    dsHorarioDisponivel: TDataSource;
    cdsHorarioDisponiveltempoVago: TIntegerField;
    cdsRecursoDisponivelPorMinuto: TClientDataSet;
    cdsRecursoDisponivelPorMinutoidRecurso: TIntegerField;
    cdsRecursoDisponivelPorMinutoidTipoRecurso: TIntegerField;
    cdsRecursoDisponivelPorMinutohoraDisponivel: TIntegerField;
    cdsHorarioDisponivelFinal: TClientDataSet;
    cdsHorarioDisponivelFinalidProfissional: TIntegerField;
    cdsHorarioDisponivelFinalHoraInicio: TIntegerField;
    cdsHorarioDisponivelFinalHoraFinal: TIntegerField;
    cdsHorarioDisponivelFinaltempoVago: TIntegerField;
    cdsHorarioDisponivelFinalnomeProfissionalHabilitado: TStringField;
    dsHorarioDisponivelFinal: TDataSource;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    btnAgendar: TBitBtn;
    ProgressBar1: TProgressBar;
    cdsHorarioDisponivelFinalHoraInicioFormatada: TStringField;
    cdsHorarioDisponivelFinalHoraFinalFormatada: TStringField;
    procedure FormShow(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure cdsHorarioDisponivelCalcFields(DataSet: TDataSet);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnAgendarClick(Sender: TObject);
    procedure cdsHorarioDisponivelFinalCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAgendamentoAvulso: TfrmAgendamentoAvulso;
  iTempoSessao, i_idSessao : Integer;

implementation

uses uDm, DateUtils, uAgendamento, uFuncoes;

{$R *.dfm}

procedure TfrmAgendamentoAvulso.FormShow(Sender: TObject);
var
   i  : Integer;
   s: String;

begin

   lblPrevisto.Caption := '0';

   comboSessao.Items.Clear;
   comboSessao.Text := '';

   with dm.cdsSessao do begin
       Close;
       Open;
       First;
   end;

   while not dm.cdsSessao.Eof do begin
      i := dm.cdsSessaoIDSESSAO.AsInteger;
      s := dm.cdsSessaoDESCRICAOSESSAO.AsString;
      comboSessao.Items.AddObject(s, TObject(i));
      dm.cdsSessao.Next;
   end;

   with dm.cdsProfissional do begin
       Close;
       Open;
       First;
   end;

   comboProfissional.Items.Clear;
   comboProfissional.Text := '';

   while not dm.cdsProfissional.Eof do begin
      i := dm.cdsProfissionalIDPROFISSIONAL.AsInteger;
      s := dm.cdsProfissionalNOMEPROFISSIONAL.AsString;
      comboProfissional.Items.AddObject(s, TObject(i));
      dm.cdsProfissional.Next;
   end;

end;

procedure TfrmAgendamentoAvulso.BitBtn4Click(Sender: TObject);

var i_idDiaDaSemana, i_DiaDaSemana, vi_X : Integer;
    vl_HorarioDisponivelEmAberto : Boolean;
    vi_HoraFinalTurno, vi_ProximoHorarioDisponivelTestar, vi_AcumuladorMinutos : Integer;
    vs_SQL :String;

begin

   ProgressBar1.Position := 0;

   Screen.Cursor := crSQLWait;

   i_idSessao := integer(comboSessao.Items.Objects[comboSessao.ItemIndex]);
   i_DiaDaSemana := DayOfTheWeek(DateTimePicker1.Date) + 1;

   with dm.cdsDiaDaSemana do begin
      Open;
      Locate('IDDIADASEMANA',i_DiaDaSemana,[loCaseInsensitive]);
   end;

   dm.cdsTempoSessao.Close;

   with dm.SQLTempoSessao do begin
      close;
      Params[0].AsInteger := i_idSessao;
      Open;
   end;

   dm.cdsTempoSessao.Open;

   lblPrevisto.Caption := IntToStr(dm.cdsTempoSessao.Fields[0].AsInteger) + ' minutos ' ;
   iTempoSessao := dm.cdsTempoSessao.Fields[0].AsInteger;

   // Popula CDS com Profissionais Habilitados no Dia Solicitado

   with SQLProfissionalHabilitadosNoDia do begin
       Close;
       Params[0].AsInteger := i_idSessao;
       Params[1].AsInteger := dm.cdsDiaDaSemanaIDDIADASEMANA.AsInteger;
       Open;
   end;

   // Cria Horarios disponiveis dos profissionais de acordo com a escala de trabalho

   cdsHorarioDisponivel.EmptyDataSet;
   vl_HorarioDisponivelEmAberto := False;         

   with cdsProfissionaisHabilitadosNodia do begin
      Open;
      First;

      while not Eof do begin

         vi_HoraFinalTurno                 := cdsProfissionaisHabilitadosNodia.fieldByName('SAIDA1').AsInteger;
         vi_ProximoHorarioDisponivelTestar := cdsProfissionaisHabilitadosNodia.fieldByName('ENTRADA1').AsInteger;
         vi_AcumuladorMinutos              := 0;

         {localizar na tabela de ausencias se o profissional está presente no dia e horario}

          vs_SQL := 'SELECT * FROM AUSENCIAS WHERE AUSENCIAS.IDPROFISSIONAL = :IDPROFISSIONAL '
                  + '  AND AUSENCIAS.DATA = :DATA  AND AUSENCIAS.DIATODO = 1';

          dm.cdsAusencias.Close;
          with dm.SQLAusencias do begin
             Close;
             CommandText := vs_SQL;
             Params[0].AsInteger := cdsProfissionaisHabilitadosNodia.FieldByName('IDPROFISSIONAL').AsInteger;
             params[1].AsDate    := DateTimePicker1.Date;
             Open;
          end;

          with dm.cdsAusencias do begin
             Open;
             if dm.cdsAusencias.RecordCount > 0 then begin
                cdsProfissionaisHabilitadosNodia.Next;
                Continue;
             end;   
          end;

          for vi_X := cdsProfissionaisHabilitadosNodia.fieldbyname('ENTRADA1').AsInteger to cdsProfissionaisHabilitadosNodia.fieldbyname('SAIDA1').AsInteger do begin

              if vi_X < vi_ProximoHorarioDisponivelTestar then
                 Continue;

              {localizar na tabela de ausencias se o profissional está presente no dia e horario}

              vs_SQL := 'SELECT * FROM AUSENCIAS WHERE AUSENCIAS.IDPROFISSIONAL = :IDPROFISSIONAL '
                     + '  AND AUSENCIAS.DATA = :DATA  AND AUSENCIAS.DIATODO = 0 '
                     + '  AND AUSENCIAS.HORAINICIO1 <= :hora1 '
                     + '  AND AUSENCIAS.HORAFINAL1  >= :hora2 ';

              dm.cdsAusencias.Close;
              with dm.SQLAusencias do begin
                 Close;
                 CommandText := vs_SQL;
                 Params[0].AsInteger := cdsProfissionaisHabilitadosNodia.FieldByName('IDPROFISSIONAL').AsInteger;
                 params[1].AsDate    := DateTimePicker1.Date;
                 Params[2].AsInteger := vi_X;
                 Params[3].AsInteger := vi_X +1;
                 Open;
              end;

              with dm.cdsAusencias do begin
                 Open;
                 if (dm.cdsAusencias.RecordCount > 0) then begin
                     if (vl_HorarioDisponivelEmAberto) then begin
                        cdsHorarioDisponivelhoraFinal.AsInteger := vi_X;
                        vl_HorarioDisponivelEmAberto := False;
                        Continue;
                     end;
                     Continue;
                 end;
              end;

              {localizar na tabela de agenda se o profissional nao tem outro compromisso alocado}

              cdsAgendamento.Close;

              with SQLAgendamento do begin
                 close;
                 Params[0].AsDate    := DateTimePicker1.Date;
                 Params[1].AsInteger := cdsProfissionaisHabilitadosNodia.FieldByName('IDPROFISSIONAL').AsInteger;
                 Params[2].AsInteger := vi_X;
                 Params[3].AsInteger := vi_X + 1;
                open;
              end;

              cdsAgendamento.Open;
              cdsAgendamento.First;

              if (not vl_HorarioDisponivelEmAberto) and (cdsAgendamento.RecordCount = 0) then begin

                 cdsHorarioDisponivel.Append;
                 cdsHorarioDisponivelidProfissional.AsInteger  := cdsProfissionaisHabilitadosNodia.FieldByName('IDPROFISSIONAL').AsInteger;
                 cdsHorarioDisponivelhoraInicio.AsInteger      := vi_X;
                //cdsHorarioDisponivelnomeProfissionalHabilitado.AsString := cdsProfissionaisHabilitadosNodia.FieldByName('NOMEPROFISSIONAL').AsString;

                 vl_HorarioDisponivelEmAberto                  := true;
                 vi_AcumuladorMinutos                          := 0;


              end;
              if (cdsAgendamento.RecordCount > 0) and (vl_HorarioDisponivelEmAberto = true) then begin
                 cdsHorarioDisponivelhoraFinal.AsInteger := vi_X;
                 vi_ProximoHorarioDisponivelTestar       := cdsAgendamento.fieldbyname('HORAFINAL').AsInteger;
                 vl_HorarioDisponivelEmAberto            := False;
                 vi_AcumuladorMinutos                    := 0;
                 Continue;
              end;

              vi_AcumuladorMinutos := vi_AcumuladorMinutos + 1;

              {testar se atingiu o tempo da sessao, encerrar e continar a pesquisa para
               poder mostrar os horarios de 40 em 40 minutos por exemplo}

              if (vi_AcumuladorMinutos = dm.cdsTempoSessao.Fields[0].AsInteger) and (vl_HorarioDisponivelEmAberto) then begin
                 cdsHorarioDisponivelhoraFinal.AsInteger := vi_X + 1;
                 vl_HorarioDisponivelEmAberto := False;
                 vi_AcumuladorMinutos         := 0;
              end;

              {se for o fim do turno entao encerra o horario}

              if (vi_x = vi_HoraFinalTurno) and (vl_HorarioDisponivelEmAberto) then begin
                 cdsHorarioDisponivelhoraFinal.AsInteger := vi_X;
                 vl_HorarioDisponivelEmAberto := False;
              end;
          end;

          vi_HoraFinalTurno                 := cdsProfissionaisHabilitadosNodia.fieldByName('SAIDA2').AsInteger;
          vi_ProximoHorarioDisponivelTestar := cdsProfissionaisHabilitadosNodia.fieldByName('ENTRADA2').AsInteger;
          vi_AcumuladorMinutos              := 0;

          for vi_X := cdsProfissionaisHabilitadosNodia.fieldbyname('ENTRADA2').AsInteger to cdsProfissionaisHabilitadosNodia.fieldbyname('SAIDA2').AsInteger do begin

              if vi_X < vi_ProximoHorarioDisponivelTestar then
                 Continue;

              {localizar na tabela de ausencias se o profissional está presente no dia e horario}

              vs_SQL := 'SELECT * FROM AUSENCIAS WHERE AUSENCIAS.IDPROFISSIONAL = :IDPROFISSIONAL '
                     + '  AND AUSENCIAS.DATA = :DATA  AND AUSENCIAS.DIATODO = 0 '
                     + '  AND AUSENCIAS.HORAINICIO1 <= :hora1 '
                     + '  AND AUSENCIAS.HORAFINAL1  >= :hora2 ';

              dm.cdsAusencias.Close;
              with dm.SQLAusencias do begin
                 Close;
                 CommandText := vs_SQL;
                 Params[0].AsInteger := cdsProfissionaisHabilitadosNodia.FieldByName('IDPROFISSIONAL').AsInteger;
                 params[1].AsDate    := DateTimePicker1.Date;
                 Params[2].AsInteger := vi_X;
                 Params[3].AsInteger := vi_X +1;
                 Open;
              end;

              with dm.cdsAusencias do begin
                 Open;
                 if (dm.cdsAusencias.RecordCount > 0) then begin
                     if (vl_HorarioDisponivelEmAberto) then begin
                        cdsHorarioDisponivelhoraFinal.AsInteger := vi_X;
                        vl_HorarioDisponivelEmAberto := False;
                        Continue;
                     end;
                     Continue;
                 end;
              end;

              {localizar na tabela de agenda se o profissional nao tem outro compromisso alocado}

              cdsAgendamento.Close;

              with SQLAgendamento do begin
                 close;
                 Params[0].AsDate    := DateTimePicker1.Date;
                 Params[1].AsInteger := cdsProfissionaisHabilitadosNodia.FieldByName('IDPROFISSIONAL').AsInteger;
                 Params[2].AsInteger := vi_X;
                 Params[3].AsInteger := vi_X + 1;
                open;
              end;

              cdsAgendamento.Open;
              cdsAgendamento.First;

              if (not vl_HorarioDisponivelEmAberto) and (cdsAgendamento.RecordCount = 0) then begin

                 cdsHorarioDisponivel.Append;
                 cdsHorarioDisponivelidProfissional.AsInteger  := cdsProfissionaisHabilitadosNodia.FieldByName('IDPROFISSIONAL').AsInteger;
                 cdsHorarioDisponivelhoraInicio.AsInteger      := vi_X;
                //cdsHorarioDisponivelnomeProfissionalHabilitado.AsString := cdsProfissionaisHabilitadosNodia.FieldByName('NOMEPROFISSIONAL').AsString;

                 vl_HorarioDisponivelEmAberto                  := true;
                 vi_AcumuladorMinutos                          := 0;


              end;
              if (cdsAgendamento.RecordCount > 0) and (vl_HorarioDisponivelEmAberto = true) then begin
                 cdsHorarioDisponivelhoraFinal.AsInteger := vi_X;
                 vi_ProximoHorarioDisponivelTestar       := cdsAgendamento.fieldbyname('HORAFINAL').AsInteger;
                 vl_HorarioDisponivelEmAberto            := False;
                 vi_AcumuladorMinutos                    := 0;
                 Continue;
              end;

              vi_AcumuladorMinutos := vi_AcumuladorMinutos + 1;

              {testar se atingiu o tempo da sessao, encerrar e continar a pesquisa para
               poder mostrar os horarios de 40 em 40 minutos por exemplo}

              if (vi_AcumuladorMinutos = dm.cdsTempoSessao.Fields[0].AsInteger) and (vl_HorarioDisponivelEmAberto) then begin
                 cdsHorarioDisponivelhoraFinal.AsInteger := vi_X + 1;
                 vl_HorarioDisponivelEmAberto := False;
                 vi_AcumuladorMinutos         := 0;
              end;

              {se for o fim do turno entao encerra o horario}

              if (vi_x = vi_HoraFinalTurno) and (vl_HorarioDisponivelEmAberto) then begin
                 cdsHorarioDisponivelhoraFinal.AsInteger := vi_X;
                 vl_HorarioDisponivelEmAberto := False;
              end;
          end;

          vi_HoraFinalTurno                 := cdsProfissionaisHabilitadosNodia.fieldByName('SAIDA3').AsInteger;
          vi_ProximoHorarioDisponivelTestar := cdsProfissionaisHabilitadosNodia.fieldByName('ENTRADA3').AsInteger;
          vi_AcumuladorMinutos              := 0;

          for vi_X := cdsProfissionaisHabilitadosNodia.fieldbyname('ENTRADA3').AsInteger to cdsProfissionaisHabilitadosNodia.fieldbyname('SAIDA3').AsInteger do begin

              if vi_X < vi_ProximoHorarioDisponivelTestar then
                 Continue;

              {localizar na tabela de ausencias se o profissional está presente no dia e horario}

              vs_SQL := 'SELECT * FROM AUSENCIAS WHERE AUSENCIAS.IDPROFISSIONAL = :IDPROFISSIONAL '
                     + '  AND AUSENCIAS.DATA = :DATA  AND AUSENCIAS.DIATODO = 0 '
                     + '  AND AUSENCIAS.HORAINICIO1 <= :hora1 '
                     + '  AND AUSENCIAS.HORAFINAL1  >= :hora2 ';

              dm.cdsAusencias.Close;
              with dm.SQLAusencias do begin
                 Close;
                 CommandText := vs_SQL;
                 Params[0].AsInteger := cdsProfissionaisHabilitadosNodia.FieldByName('IDPROFISSIONAL').AsInteger;
                 params[1].AsDate    := DateTimePicker1.Date;
                 Params[2].AsInteger := vi_X;
                 Params[3].AsInteger := vi_X +1;
                 Open;
              end;

              with dm.cdsAusencias do begin
                 Open;
                 if (dm.cdsAusencias.RecordCount > 0) then begin
                     if (vl_HorarioDisponivelEmAberto) then begin
                        cdsHorarioDisponivelhoraFinal.AsInteger := vi_X;
                        vl_HorarioDisponivelEmAberto := False;
                        Continue;
                     end;
                     Continue;
                 end;
              end;

              {localizar na tabela de agenda se o profissional nao tem outro compromisso alocado}

              cdsAgendamento.Close;

              with SQLAgendamento do begin
                 close;
                 Params[0].AsDate    := DateTimePicker1.Date;
                 Params[1].AsInteger := cdsProfissionaisHabilitadosNodia.FieldByName('IDPROFISSIONAL').AsInteger;
                 Params[2].AsInteger := vi_X;
                 Params[3].AsInteger := vi_X + 1;
                open;
              end;

              cdsAgendamento.Open;
              cdsAgendamento.First;

              if (not vl_HorarioDisponivelEmAberto) and (cdsAgendamento.RecordCount = 0) then begin

                 cdsHorarioDisponivel.Append;
                 cdsHorarioDisponivelidProfissional.AsInteger  := cdsProfissionaisHabilitadosNodia.FieldByName('IDPROFISSIONAL').AsInteger;
                 cdsHorarioDisponivelhoraInicio.AsInteger      := vi_X;
                //cdsHorarioDisponivelnomeProfissionalHabilitado.AsString := cdsProfissionaisHabilitadosNodia.FieldByName('NOMEPROFISSIONAL').AsString;

                 vl_HorarioDisponivelEmAberto                  := true;
                 vi_AcumuladorMinutos                          := 0;


              end;
              if (cdsAgendamento.RecordCount > 0) and (vl_HorarioDisponivelEmAberto = true) then begin
                 cdsHorarioDisponivelhoraFinal.AsInteger := vi_X;
                 vi_ProximoHorarioDisponivelTestar       := cdsAgendamento.fieldbyname('HORAFINAL').AsInteger;
                 vl_HorarioDisponivelEmAberto            := False;
                 vi_AcumuladorMinutos                    := 0;
                 Continue;
              end;

              vi_AcumuladorMinutos := vi_AcumuladorMinutos + 1;

              {testar se atingiu o tempo da sessao, encerrar e continar a pesquisa para
               poder mostrar os horarios de 40 em 40 minutos por exemplo}

              if (vi_AcumuladorMinutos = dm.cdsTempoSessao.Fields[0].AsInteger) and (vl_HorarioDisponivelEmAberto) then begin
                 cdsHorarioDisponivelhoraFinal.AsInteger := vi_X + 1;
                 vl_HorarioDisponivelEmAberto := False;
                 vi_AcumuladorMinutos         := 0;
              end;

              {se for o fim do turno entao encerra o horario}

              if (vi_x = vi_HoraFinalTurno) and (vl_HorarioDisponivelEmAberto) then begin
                 cdsHorarioDisponivelhoraFinal.AsInteger := vi_X;
                 vl_HorarioDisponivelEmAberto := False;
              end;
          end;

          next;
      end;
   end;

   ProgressBar1.Position := 25;

   {
   cdsHorarioDisponivel.First;
   while not cdsHorarioDisponivel.Eof do begin

      ShowMessage(cdsHorarioDisponivelidProfissional.AsString);
      ShowMessage(cdsHorarioDisponivelhoraInicio.AsString);
      ShowMessage(cdsHorarioDisponivelhoraFinal.AsString);

      cdsHorarioDisponivel.Next;
   end;
   }        

   cdsRecursoDisponivelPorMinuto.EmptyDataSet;

   with dm.SQLRecurso do begin
      Close;
      Open;
      First;
   end;

   dm.cdsRecurso.Open;

   { percorre todos os horarios e grava os recursos (equipamentos) disponiveis no momento por minuto - 0 a 1439 }
   
   for vi_x := 540 to 1320 do begin

      { Todos os Recursos estão disponiveis a principio }
      with dm.cdsRecurso do begin
         First;
         while not Eof do begin
            cdsRecursoDisponivelPorMinuto.Append;
            cdsRecursoDisponivelPorMinutoidRecurso.AsInteger      := dm.cdsRecursoIDRECURSO.AsInteger;
            cdsRecursoDisponivelPorMinutoidTipoRecurso.AsInteger  := dm.cdsRecursoIDTIPORECURSO.AsInteger;
            cdsRecursoDisponivelPorMinutohoraDisponivel.AsInteger := vi_X;
            next;
         end;
      end;

      vs_SQL := 'SELECT * FROM AGENDAMENTO WHERE AGENDAMENTO.DATA = :DATA ';
      vs_SQL := vs_SQL + 'AND AGENDAMENTO.HORAINICIO <= :HORAINI ';
      vs_SQL := vs_SQL +  'AND AGENDAMENTO.HORAFINAL >= :HORAFIM';

      {verifico agendamentos no horário}

      dm.cdsAgendamento.Close;
      
      with dm.SQLAgendamento do begin
         Close;
         CommandText := vs_SQL;
         Params[0].AsDate    := DateTimePicker1.Date;
         Params[1].AsInteger := vi_X;
         Params[2].AsInteger := vi_X + 1;   
         Open;
      end;
      
      with dm.cdsAgendamento do begin
         Open;
         First;

        // ShowMessage('Horario:' + IntToStr(vi_X) + ' - ' + 'Numero de Agendamentos: ' + IntToStr(dm.cdsAgendamento.RecordCount));

         { dos agendamentos no horario, quais recursos estao sendo utilizados ? }

         while not Eof do begin

            dm.cdsRecursoPorAgendamento.Close;

            with dm.SQLRecursoPorAgendamento do begin
               close;
               vs_SQL := 'SELECT * FROM RECURSOPORAGENDAMENTO WHERE IDAGENDAMENTO = :IDAGENDAMENTO';
               CommandText := vs_SQL;
               Params[0].AsInteger := dm.cdsAgendamentoIDAGENDAMENTO.AsInteger;
               Open;
            end;

            with dm.cdsRecursoPorAgendamento do begin
               open;
               First;

              // ShowMessage('Horario:' + IntToStr(vi_X) + ' - ' + 'Numero de Recursos Sendo Utilizados: ' + IntToStr(dm.cdsRecursoPorAgendamento.RecordCount));

               while not Eof do begin

                  //showmessage('ID Do Recurso Por Agendamento: ' + IntToStr(dm.cdsRecursoPorAgendamentoIDRECURSOPORAGENDAMENTO.AsInteger) + ' - ' + 'Hora Inicio: ' + IntToStr(dm.cdsAgendamentoHORAINICIO.AsInteger) + 'Hora Final: ' + IntToStr(dm.cdsAgendamentoHORAFINAL.AsInteger));
                  if cdsRecursoDisponivelPorMinuto.Locate('HoraDisponivel;IdRecurso',VarArrayOf([vi_X,dm.cdsRecursoPorAgendamentoIDRECURSO.AsInteger]),[]) then
                     cdsRecursoDisponivelPorMinuto.Delete;

                  next;
               end;
            end;               
            next;
         end;
      end;
   end;

   ProgressBar1.Position := 50;

   { codigo pra depurar se os recursos foram deletados conforme os agendamentos}

   {
   with cdsRecursoDisponivelPorMinuto do begin
      First;
      while not Eof do begin
         ShowMessage('Horario: ' + IntToStr(cdsRecursoDisponivelPorMinutohoraDisponivel.AsInteger) + ' - ' + 'idRecurso Disponivel: ' + IntToStr(cdsRecursoDisponivelPorMinutoidRecurso.AsInteger) );
         next;
      end;
   end;
   }


   vs_SQL := 'SELECT * FROM TIPORECURSOPORSESSAO WHERE IDSESSAO = :IDSESSAO';

   dm.cdsTipoRecursoPorSessao.Close;
   with dm.SQLTipoRecursoPorSessao do begin
      Close;
      CommandText := vs_SQL;
      params[0].AsInteger := i_idSessao;
      Open;
   end;

   vl_HorarioDisponivelEmAberto := False;


   {Verifica se tem equipamento disponivel para realizar a sessao, caso contrario
    o horario nao pode estar disponivel}

   cdsHorarioDisponivelFinal.EmptyDataSet;
   with cdsHorarioDisponivel do begin
      First;
      while not Eof do begin

          //ShowMessage('teste');

          for vi_x := cdsHorarioDisponivelhoraInicio.AsInteger to cdsHorarioDisponivelhoraFinal.AsInteger do begin

             if (vi_x = cdsHorarioDisponivelhoraFinal.AsInteger) and (vl_HorarioDisponivelEmAberto = true) then begin
                cdsHorarioDisponivelFinalHoraFinal.AsInteger := vi_X;
                cdsHorarioDisponivelFinaltempoVago.AsInteger := cdsHorarioDisponivelFinalHoraFinal.AsInteger - cdsHorarioDisponivelFinalHoraInicio.AsInteger;
                if dm.cdsProfissional.Locate('idProfissional',cdsHorarioDisponivelFinalidProfissional.AsInteger,[]) then
                   cdsHorarioDisponivelFinalnomeProfissionalHabilitado.AsString := dm.cdsProfissionalNOMEPROFISSIONAL.AsString;
                vl_HorarioDisponivelEmAberto := False;
                Continue;
             end;

             if vl_HorarioDisponivelEmAberto = False then begin
                 cdsHorarioDisponivelFinal.Append;
                 cdsHorarioDisponivelFinalHoraInicio.AsInteger := vi_X;
                 cdsHorarioDisponivelFinalidProfissional.AsInteger := cdsHorarioDisponivelidProfissional.AsInteger;
                 vl_HorarioDisponivelEmAberto := True;

             end;

             with dm.cdsTipoRecursoPorSessao do begin
                Open;
                First;

                while not Eof do begin

                   if not cdsRecursoDisponivelPorMinuto.Locate('HoraDisponivel;IdTipoRecurso',VarArrayOf([vi_X, dm.cdsTipoRecursoPorSessaoIDTIPORECURSO.AsInteger]),[]) then begin

                      cdsHorarioDisponivelFinalHoraFinal.AsInteger := vi_X;
                      vl_HorarioDisponivelEmAberto := False;

                      if cdsHorarioDisponivelFinalHoraInicio.AsInteger = cdsHorarioDisponivelFinalHoraFinal.AsInteger then
                         cdsHorarioDisponivelFinal.Delete;
                   end;
                   next;
                end;
             end;

             if (vi_x = cdsHorarioDisponivelhoraFinal.AsInteger) and (vl_HorarioDisponivelEmAberto = true) then begin
                cdsHorarioDisponivelFinalHoraFinal.AsInteger := vi_X;

                if cdsHorarioDisponivelFinalHoraInicio.AsInteger = cdsHorarioDisponivelFinalHoraFinal.AsInteger then
                   cdsHorarioDisponivelFinal.Delete;

                vl_HorarioDisponivelEmAberto := False;
                continue;
             end;
          end;
          next;
       end;
   end;

   ProgressBar1.Position := 100;

   cdsHorarioDisponivelFinal.First;
   if cdsHorarioDisponivelFinal.RecordCount > 0 then
      btnAgendar.Enabled := True;

   Screen.Cursor := crDefault;

   ProgressBar1.Position := 0;

end;

procedure TfrmAgendamentoAvulso.BitBtn2Click(Sender: TObject);
begin
   Close;
end;

procedure TfrmAgendamentoAvulso.cdsHorarioDisponivelCalcFields(
  DataSet: TDataSet);
begin
    cdsHorarioDisponiveltempoVago.AsInteger := cdsHorarioDisponivelhoraFinal.AsInteger - cdsHorarioDisponivelhoraInicio.AsInteger;
end;

procedure TfrmAgendamentoAvulso.DBGrid2DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin

   if DBGrid2.DataSource.DataSet.FieldByName('tempoVago').AsInteger < iTempoSessao then begin
      DBGrid2.Canvas.Brush.Color := clYellow;
      DBGrid2.Canvas.Font.Color   := clBlack;
   end;

   if gdSelected in State then begin
      DBGrid2.Canvas.Brush.Color:= clBlue;
      DBGrid2.Canvas.Font.Color:= clYellow;
   end;

    {
   else begin
      DBGrid2.Canvas.Brush.Color := $66FF66;
      DBGrid2.Canvas.Font.Color   := clBlack;
   end;
    }
   DBGrid2.DefaultDrawDataCell(Rect, DBGrid2.Columns[DataCol].Field, State);

end;

procedure TfrmAgendamentoAvulso.btnAgendarClick(Sender: TObject);
begin

   with TfrmAgendamento.Create(Self,DateTimePicker1.Date, cdsHorarioDisponivelFinalidProfissional.AsInteger, cdsHorarioDisponivelFinalHoraInicio.AsInteger, cdsHorarioDisponivelFinalHoraFinal.AsInteger, i_idSessao)  do begin
      ShowModal;
      Free;
   end;

end;

procedure TfrmAgendamentoAvulso.cdsHorarioDisponivelFinalCalcFields(
  DataSet: TDataSet);
begin
   cdsHorarioDisponivelFinalHoraInicioFormatada.AsString := retornaHora(cdsHorarioDisponivelFinalHoraInicio.AsInteger);
   cdsHorarioDisponivelFinalHoraFinalFormatada.AsString := retornaHora(cdsHorarioDisponivelFinalHoraFinal.AsInteger)
end;

end.
