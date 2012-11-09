unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons, Grids, DBGrids;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    BitBtn1: TBitBtn;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses uAgendamentoAvulso;

{$R *.dfm}

procedure TfrmMain.BitBtn1Click(Sender: TObject);
begin
   if frmAgendamentoAvulso = nil then
      Application.CreateForm(TfrmAgendamentoAvulso, frmAgendamentoAvulso);
   frmAgendamentoAvulso.ShowModal;

   frmAgendamentoAvulso := nil;
end;

end.
