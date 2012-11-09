unit uFuncoes;

interface

function buscaNomeProfissional (pi_IdProfissional :Integer) : String;
function buscaNomeSessao (pi_IdSessao : Integer) : String;
function buscaDescricaoTipoRecurso (pi_IdTipoRecurso: Integer) : String;
function BuscarGenerator(pNomeGenerator : String) : Integer;
function retornaHora(pHoraEmMinutos: Cardinal) : String;

implementation

uses uDm, DB, SqlExpr, StdCtrls, SysUtils;

function buscaNomeProfissional (pi_IdProfissional :Integer) : String;
   var ps_SQL : String;

   begin
      dm.cdsProfissional.Close;
      ps_SQL := 'SELECT * FROM PROFISSIONAL WHERE IDPROFISSIONAL = :IDPROFISSIONAL';

      with dm.SQLProfissional do begin
         Close;
         CommandText := ps_SQL;
         Params[0].AsInteger := pi_IdProfissional;
         Open;
      end;

      dm.cdsProfissional.Open;

      if dm.cdsProfissional.RecordCount > 0 then
         Result := dm.cdsProfissionalNOMEPROFISSIONAL.AsString;

   end;


function buscaNomeSessao (pi_IdSessao : Integer) : String;
   var ps_SQL : String;

   begin
      dm.cdsSessao.Close;
      ps_SQL := 'SELECT * FROM SESSAO WHERE IDSESSAO = :IDSESSAO';

      with dm.SQLSessao do begin
         Close;
         CommandText := ps_SQL;
         Params[0].AsInteger := pi_IdSessao;
         Open;
      end;

      dm.cdsSessao.Open;

      if dm.cdsSessao.RecordCount > 0 then
         Result := dm.cdsSessaoDESCRICAOSESSAO.AsString;

   end;


function buscaDescricaoTipoRecurso (pi_IdTipoRecurso: Integer) : String;
   var ps_SQL : String;

   begin
      dm.cdsTipoRecurso.Close;
      ps_SQL := 'SELECT * FROM TIPORECURSO WHERE IDTIPORECURSO = :IDTIPORECURSO';

      with dm.SQLTipoRecurso do begin
         Close;
         CommandText := ps_SQL;
         Params[0].AsInteger := pi_IdTipoRecurso;
         Open;
      end;

      dm.cdsTipoRecurso.Open;

      if dm.cdsTipoRecurso.RecordCount > 0 then
         Result := dm.cdsTipoRecursoDESCRICAOTIPORECURSO.AsString;

   end;

function BuscarGenerator(pNomeGenerator : String) : Integer;
   var
      v_SQL : String;

   begin

      v_SQL := 'SELECT GEN_ID('
             + pNomeGenerator
             + ',1) FROM RDB$DATABASE';

      with dm.qryGenerator do begin
         Close;
         CommandText := v_SQL;
         Open;
         Result := fields[0].AsInteger;
       end;
   end;

   function retornaHora(pHoraEmMinutos: Cardinal) : String;
      var
         horaFinal : String;

      begin
         horaFinal := Format('%.2d:%.2d', [pHoraEmMinutos div 60, pHoraEmMinutos mod 60]);
         Result := horaFinal;
      end;
END.
