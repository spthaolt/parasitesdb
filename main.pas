unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Sqlite3DS, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Database;

type

  { TMainForm }

  TMainForm = class(TForm)
    BtnNext: TBitBtn;
    BtnExit: TBitBtn;
    BtnDbMgr: TBitBtn;
    Image1: TImage;
    Memo1: TMemo;
    Sqlite3Dataset1: TSqlite3Dataset;
    procedure BtnDbMgrClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if not Sqlite3Dataset1.TableExists then
    Sqlite3Dataset1.CreateTable;
  Sqlite3Dataset1.Open;
end;

procedure TMainForm.BtnExitClick(Sender: TObject);
begin
  MainForm.Close;
end;

procedure TMainForm.BtnDbMgrClick(Sender: TObject);
begin
  DatabaseForm.ShowModal;
end;

end.

