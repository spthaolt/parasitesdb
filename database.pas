unit Database;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Sqlite3DS, db, FileUtil, Forms, Controls, Graphics,
  Dialogs, DBGrids, DbCtrls, StdCtrls, ExtCtrls;

type

  { TDatabaseForm }

  TDatabaseForm = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBMemo1: TDBMemo;
    DBMemo2: TDBMemo;
    DBNavigator1: TDBNavigator;
    EditSearch: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure EditSearchChange(Sender: TObject);
    procedure EditSearchClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  DatabaseForm: TDatabaseForm;

implementation

{$R *.lfm}

{ TDatabaseForm }

procedure TDatabaseForm.EditSearchChange(Sender: TObject);
var
  Options: TLocateOptions;
begin
  if EditSearch.Text = 'Type here to search' then
     Exit;
  if EditSearch.Text = '' then
     Exit;
  Options := [loCaseInsensitive, loPartialKey];

  TSqlite3Dataset (DataSource1.DataSet).Locate('name', EditSearch.Text,Options);
end;

procedure TDatabaseForm.EditSearchClick(Sender: TObject);
begin
  if EditSearch.Text = 'Type here to search' then
     EditSearch.Text:= '';

end;

end.

