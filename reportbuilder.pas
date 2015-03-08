unit ReportBuilder;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, memds, Sqlite3DS, db, FileUtil, PrintersDlgs, LR_Class,
  LR_DBSet, LR_View, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
  Buttons, DbCtrls, Printers;

type

  { TReportBuilderForm }

  TReportBuilderForm = class(TForm)
    BtnPrint: TBitBtn;
    BtnPreview: TBitBtn;
    BtnClose: TBitBtn;
    PrintDialog1: TPrintDialog;
    RpDetailDS: TDataSource;
    ReportDS: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    EditFullname: TDBEdit;
    EditYOB: TDBEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    GroupRecommendation: TGroupBox;
    GroupCustomerInfo: TGroupBox;
    GroupDiagnoses: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    MemoAddress: TDBMemo;
    MemoDescription: TDBMemo;
    MemoRecommendation: TDBMemo;
    MemoReportRecommend: TDBMemo;
    RpDetailSQLite: TSqlite3Dataset;
    ReportSQLite: TSqlite3Dataset;
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnPreviewClick(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ReportBuilderForm: TReportBuilderForm;

implementation

{$R *.lfm}

{ TReportBuilderForm }

procedure TReportBuilderForm.BtnCloseClick(Sender: TObject);
begin
  ReportBuilderForm.Close;
end;

procedure TReportBuilderForm.BtnPreviewClick(Sender: TObject);
begin
  frReport1.LoadFromFile('defaultreport.lrf');
  frReport1.ShowReport;
end;

procedure TReportBuilderForm.BtnPrintClick(Sender: TObject);
var AppDirectory: string;
  FromPage, ToPage, NumberCopies: Integer;
  ind: Integer;
  Collap: Boolean;
begin
  // Load report definition from application directory
  AppDirectory:=ExtractFilePath(ParamStr(0));
  frReport1.LoadFromFile('defaultreport.lrf');
  // Need to keep track of which printer was originally selected to check for user changes
  ind:= Printer.PrinterIndex;
  // Prepare the report and just stop if we hit an error as continuing makes no sense
  if not frReport1.PrepareReport then Exit;
  // Set up dialog with some sensible defaults which user can change
  with PrintDialog1 do
  begin
    Options:=[poPageNums ]; // allows selecting pages/page numbers
    Copies:=1;
    Collate:=true; // ordened copies
    FromPage:=1; // start page
    ToPage:=frReport1.EMFPages.Count; // last page
    MaxPage:=frReport1.EMFPages.Count; // maximum allowed number of pages
    if Execute then // show dialog; if succesful, process user feedback
    begin
      if (Printer.PrinterIndex <> ind ) // verify if selected printer has changed
        or frReport1.CanRebuild // ... only makes sense if we can reformat the report
        or frReport1.ChangePrinter(ind, Printer.PrinterIndex) //... then change printer
        then
        frReport1.PrepareReport //... and reformat for new printer
      else
        exit; // we couldn't honour the printer change

      if PrintDialog1.PrintRange = prPageNums then // user made page range selection
      begin
        FromPage:=PrintDialog1.FromPage; // first page
        ToPage:=PrintDialog1.ToPage;  // last page
      end;
      NumberCopies:=PrintDialog1.Copies; // number of copies
      // Print the report using the supplied pages & copies
      frReport1.PrintPreparedReport(inttostr(FromPage)+'-'+inttostr(ToPage), NumberCopies);
    end;
  end;
end;

procedure TReportBuilderForm.FormCreate(Sender: TObject);
begin
  if not ReportSQLite.TableExists then
    ReportSQLite.CreateTable;
  if not RpDetailSQLite.TableExists then
    RpDetailSQLite.CreateTable;
end;

procedure TReportBuilderForm.FormShow(Sender: TObject);
begin
  ReportSQLite.Active:=true;
  ReportSQLite.Append;
  ReportSQLite.FieldByName('fullname').AsString:='';
  ReportSQLite.Post;
  ReportSQLite.RefetchData;
  ReportSQLite.Last;
  RpDetailSQLite.Active:=true;

  //
end;

end.

