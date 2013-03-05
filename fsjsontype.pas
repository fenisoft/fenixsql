unit fsjsontype;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ButtonPanel,
  ExtCtrls;

type

  { TJsonTypeForm }

  TJsonTypeForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    JsonTypeRadioGroup: TRadioGroup;
  private
    function GetJsonArray: boolean;
    { private declarations }
  public
    { public declarations }
    property JsonArray: boolean read GetJsonArray;
  end;



implementation

{$R *.lfm}

{ TJsonTypeForm }

function TJsonTypeForm.GetJsonArray: boolean;
begin
  Result :=  JsonTypeRadioGroup.ItemIndex = 0 ;
end;

end.

