unit fsselectatable;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls,
  ButtonPanel;

type

  { TSelectATableForm }

  TSelectATableForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    ListBox1: TListBox;
  private
    { private declarations }
    function  GetTableSelected: string;
  public
    { public declarations }
    property TableSelected: string  read GetTableSelected;
  end;


implementation

{$R *.lfm}

{ TSelectATableForm }

function TSelectATableForm.GetTableSelected: string;
begin
  Result := ListBox1.Items.Strings[ListBox1.ItemIndex];
end;

end.

