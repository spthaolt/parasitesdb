unit ReportBuilder;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_Class, LR_DBSet, Forms, Controls, Graphics,
  Dialogs, StdCtrls;

type

  { TReportBuilderForm }

  TReportBuilderForm = class(TForm)
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ReportBuilderForm: TReportBuilderForm;

implementation

{$R *.lfm}

end.

