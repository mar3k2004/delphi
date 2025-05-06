unit Baza;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait,
  FireDAC.Comp.Client, Data.DB;

type
  TdmBaza = class(TDataModule)
    FDCon: TFDConnection;
    FDTransaction: TFDTransaction;
    procedure FDConAfterConnect(Sender: TObject);
    procedure FDConBeforeConnect(Sender: TObject);
    procedure FDConAfterDisconnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
//  dmBaza: TdmBaza;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TdmBaza.FDConAfterConnect(Sender: TObject);
begin

{$IFDEF TESTOWA}
  showmessage('Po³¹czono FDCON');
{$ENDIF}
end;

procedure TdmBaza.FDConAfterDisconnect(Sender: TObject);
begin

{$IFDEF TESTOWA}
  showmessage('Po³¹czenie zosta³o roz³¹czone FDCON');
{$ENDIF}
end;

procedure TdmBaza.FDConBeforeConnect(Sender: TObject);

const
  dName = 'SQLite';

begin

  FDCon.DriverName := dName;

  try
    // C:\Users\%USERNAME%\Documents\
    FDCon.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, _sTblSlownikowa);

  except

    on e: Exception do
      _ErrorToFILE(e.Message, true);

  end;

end;


