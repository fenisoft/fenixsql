(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
   http://fblib.altervista.org

   file:fsconfig.pas


  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.

*)

{$mode objfpc}{$H+}

unit fsconfig;

interface

uses SysUtils, Classes, Forms, Graphics, iniFiles, ibase_h;

var
  MaxFetchResult: integer;
  MaxGridRows: integer;
  AutoCommitDDL: boolean;
  SystemObjectsVisible: boolean;
  VerboseSqlScript: boolean;
  SetTermVisible: boolean;
  OutputGridType: integer; // 0 string grid 1 memo
  FileFilterForDialog: string;
  FileExtentionForDialog: string;
  ConfigDirPath: string;
  LastAliasConnected: string;
  SqlEditPanelHeight: Integer;

const
  APP_TITLE = 'fenixsql';
  APP_VERSION = '0.9.2 beta';
  APP_PROJECT_URL = 'http://code.google.com/p/fenixsql';
  ALIAS_INI_FILE = 'aliases.ini';
  CONFIG_INI_FILE = 'config.ini';
  (* config.ini section *)
  SECTION_GENERAL = 'GENERAL';
  SECTION_PATH = 'PATH';
  SECTION_SECURE_DB = 'SECURE-DB';
  SECTION_FONT_BROWSER = 'FONT/BROWSER';
  SECTION_FONT_EDIT = 'FONT/EDIT';
  SECTION_FONT_TEXTGRID = 'FONT/TEXTGRID';
  SECTION_FONT_MEMO = 'FONT/MEMO';


procedure InitFileConfig;
function GetAliasIniFile: string;
function GetConfigIniFile: string;
procedure ReadConfigFile;
procedure WriteConfigFile;
procedure WriteConfigEdit(const ASection: string; AFont: TFont; ABackColor: TColor);
procedure ReadConfigEdit(const ASection: string; AFont: TFont; var ABackColor: TColor);
procedure WriteConfigSynEdit;
procedure ReadConfigSynEdit;
procedure SaveHistory(const AAlias: string; AHistory: TStrings);
procedure LoadHistory(const AAlias: string; AHistory: TStrings);
procedure DeleteHistory(const AAlias: string);
procedure SaveFormPos(AForm: TForm);
procedure LoadFormPos(AForm: TForm);
procedure GetAliasNames(AAliases: TStrings);
procedure SetDefaultVariable;

implementation

uses
  fsdm;

procedure InitFileConfig;
begin
  ConfigDirPath := GetAppConfigDir(False);
  if not DirectoryExists(ConfigDirPath) then
    mkdir(ConfigDirPath);
end;

//------------------------------------------------------------------------------

function GetAliasIniFile: string;
begin
  Result := ConfigDirPath + ALIAS_INI_FILE;
end;

//------------------------------------------------------------------------------

function GetConfigIniFile: string;
begin
  Result := ConfigDirPath + CONFIG_INI_FILE;
end;

//------------------------------------------------------------------------------


procedure ReadConfigFile;
var
  iniFile: TiniFile;
begin
  IniFile := TiniFile.Create(GetConfigIniFile);
  try
    LastAliasConnected := iniFile.ReadString(SECTION_GENERAL,
      'LastAliasConnected', '');
    MaxFetchResult := inifile.ReadInteger(SECTION_GENERAL, 'MaxFetch', 0);
    MaxGridRows := inifile.ReadInteger(SECTION_GENERAL, 'MaxGridRows', 6000);
    if (MaxGridRows < 500) and (MaxGridRows > 10000) then
      MaxGridRows := 6000;
    AutoCommitDDL := inifile.ReadBool(SECTION_GENERAL, 'AutoCommitDDL', False);
    SystemObjectsVisible := inifile.ReadBool(SECTION_GENERAL, 'ShowSystemObjs', False);
    VerboseSqlScript := inifile.ReadBool(SECTION_GENERAL, 'VerboseSqlScript', False);
    SetTermVisible := inifile.ReadBool(SECTION_GENERAL, 'ShowSetTerm', False);
    OutputGridType := inifile.ReadInteger(SECTION_GENERAL, 'SetOutputGrid', 0);
    SqlEditPanelHeight := inifile.ReadInteger(SECTION_GENERAL, 'SqlEditPanelHeight',160);
  finally
    iniFile.Free;
  end;
end;

//------------------------------------------------------------------------------


procedure WriteConfigFile;
var
  iniFile: TiniFile;
begin
  IniFile := TiniFile.Create(GetConfigIniFile);
  try
    IniFile.WriteString(SECTION_GENERAL, 'LastAliasConnected', LastAliasConnected);
    IniFile.WriteInteger(SECTION_GENERAL, 'MaxFetch', MaxFetchResult);
    IniFile.WriteInteger(SECTION_GENERAL, 'MaxGridRows', MaxGridRows);
    IniFile.WriteBool(SECTION_GENERAL, 'AutoCommitDDL', AutoCommitDDL);
    Inifile.WriteBool(SECTION_GENERAL, 'ShowSystemObjs', SystemObjectsVisible);
    Inifile.WriteBool(SECTION_GENERAL, 'VerboseSqlScript', VerboseSqlScript);
    Inifile.WriteBool(SECTION_GENERAL, 'ShowSetTerm', SetTermVisible);
    inifile.WriteInteger(SECTION_GENERAL, 'SetOutputGrid', OutputGridType);
    inifile.WriteInteger(SECTION_GENERAL, 'SqlEditPanelHeight',SqlEditPanelHeight);
    iniFile.UpdateFile;
  finally
    iniFile.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure WriteConfigEdit(const ASection: string; AFont: TFont; ABackColor: TColor);
var
  Inifile: TiniFile;
begin
  IniFile := TiniFile.Create(GetConfigIniFile);
  try
    IniFile.WriteString(ASection, 'Name', AFont.Name);
    inifile.WriteInteger(ASection, 'Size', AFont.Size);
    inifile.WriteInteger(ASection, 'Height', AFont.Height);
    inifile.WriteString(ASection, 'Foreground', ColorToString(AFont.Color));
    inifile.WriteString(ASection, 'Background', ColorToString(ABackColor));
    inifile.WriteBool(ASection, 'Bold', fsBold in AFont.Style);
    inifile.WriteBool(ASection, 'Italic', fsItalic in AFont.Style);
    inifile.WriteBool(ASection, 'Underline', fsItalic in AFont.Style);
    inifile.WriteBool(ASection, 'StrikeOut', fsStrikeOut in AFont.Style);
    inifile.WriteInteger(ASection, 'CharSet', integer(AFont.CharSet));
    inifile.UpdateFile;
  finally
    IniFile.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure ReadConfigEdit(const ASection: string; AFont: TFont; var ABackColor: TColor);
var
  Inifile: TiniFile;
begin
  IniFile := TiniFile.Create(GetConfigIniFile);
  try
    if inifile.SectionExists(ASection) then
    begin
      AFont.Name := inifile.ReadString(ASection, 'Name', '');
      AFont.Size := Inifile.ReadInteger(ASection, 'Size', 0);
      AFont.Height := inifile.ReadInteger(ASection, 'Height', 0);
      AFont.Color := StringToColor(IniFile.ReadString(ASection, 'Foreground', ''));
      ABackColor := StringToColor(Inifile.ReadString(ASection, 'Background', ''));
      if IniFile.ReadBool(ASection, 'Bold', False) then
        AFont.Style := AFont.Style + [fsBold];
      if IniFile.ReadBool(ASection, 'Italic', False) then
        AFont.Style := AFont.Style + [fsItalic];
      if IniFile.ReadBool(ASection, 'Underline', False) then
        AFont.Style := AFont.Style + [fsUnderline];
      if IniFile.ReadBool(ASection, 'StrikeOut', False) then
        AFont.Style := AFont.Style + [fsStrikeOut];
      AFont.CharSet := TFontCharSet(inifile.ReadInteger(ASection, 'CharSet', 0));
    end;
  finally
    IniFile.Free;
  end;
end;

//------------------------------------------------------------------------------


procedure WriteConfigSynEdit;
var
  Inifile: TIniFile;
begin
  IniFile := TiniFile.Create(GetConfigIniFile);
  try
    with MainDataModule do
    begin
      SynSQLSyn1.CommentAttri.SaveToFile(IniFile);
      SynSQLSyn1.KeyAttri.SaveToFile(IniFile);
      SynSQLSyn1.StringAttri.SaveToFile(IniFile);
      SynSQLSyn1.NumberAttri.SaveToFile(IniFile);
      SynSQLSyn1.TableNameAttri.SaveToFile(IniFile);
      SynSQLSyn1.DataTypeAttri.SaveToFile(IniFile);
      SynSQLSyn1.IdentifierAttri.SaveToFile(IniFile);
    end;
    Inifile.UpdateFile;
  finally
    IniFile.Free;
  end;
end;


//------------------------------------------------------------------------------

procedure ReadConfigSynEdit;
var
  Inifile: TiniFile;
begin
  IniFile := TiniFile.Create(GetConfigIniFile);
  try
    with MainDataModule do
    begin
      SynSQLSyn1.CommentAttri.LoadFromFile(IniFile);
      SynSQLSyn1.KeyAttri.LoadFromFile(IniFile);
      SynSQLSyn1.StringAttri.LoadFromFile(IniFile);
      SynSQLSyn1.NumberAttri.LoadFromFile(IniFile);
      SynSQLSyn1.TableNameAttri.LoadFromFile(IniFile);
      SynSQLSyn1.DataTypeAttri.LoadFromFile(IniFile);
      SynSQLSyn1.IdentifierAttri.LoadFromFile(IniFile);
    end;
  finally
    IniFile.Free;
  end;
end;

//------------------------------------------------------------------------------


procedure SaveHistory(const AAlias: string; AHistory: TStrings);
var
  FileName: string;
  ListTemp: TStringList;
  i: integer;
begin
  FileName := ConfigDirPath + AAlias + '.history';
  ListTemp := TStringList.Create;
  try
    for i := 0 to AHistory.Count - 1 do
    begin
      ListTemp.Add(AHistory.Strings[i] + '#END');
    end;
    ListTemp.SaveToFile(FileName);
  finally
    ListTemp.Free;
  end;

end;

//------------------------------------------------------------------------------

procedure LoadHistory(const AAlias: string; AHistory: TStrings);
var
  FileName: string;
  ListTemp: TStringList;
  i, p: integer;
  item: string;
begin
  FileName := ConfigDirPath + AAlias + '.history';
  ListTemp := TStringList.Create;
  try
    if FileExists(FileName) then
    begin
      ListTemp.LoadFromFile(FileName);
      item := '';
      for i := 0 to ListTemp.Count - 1 do
      begin
        p := Pos('#END', ListTemp.Strings[i]);
        if p > 0 then
        begin
          item := item + LeftStr(ListTemp.Strings[i], p - 1);
          AHistory.Add(item);
          item := '';
        end
        else
          item := item + ListTemp.Strings[i] + LineEnding;
      end;
    end;
  finally
    ListTemp.Free;
  end;

end;

//------------------------------------------------------------------------------

procedure DeleteHistory(const AAlias: string);
var
  historyFile: string;
begin
  historyFile := ConfigDirPath + AAlias + '.history';
  if FileExists(historyFile) then
    DeleteFile(historyFile);
end;

//------------------------------------------------------------------------------

procedure SetDefaultVariable;
begin
  if GetFbClientVersion = 7 then
  begin
    FileFilterForDialog :=
      'Firebird (*.fdb)|*.fdb;*.FDB|Interbase/Firebird 1.0 (*.gdb)|*.gdb';
    FileExtentionForDialog := 'fdb';
  end
  else
  begin
    FileFilterForDialog :=
      'Interbase/Firebird 1.0 (*.gdb)|*.gdb;*.GDB|Firebird (*.fdb)|*.fdb';
    FileExtentionForDialog := 'gdb';
  end;
end;

//------------------------------------------------------------------------------

procedure SaveFormPos(AForm: TForm);
var
  Inifile: TiniFile;
  Section: string;
begin
  IniFile := TIniFile.Create(GetConfigIniFile);
  Section := AForm.Name;
  try
    Inifile.WriteInteger(Section, 'Top', AForm.Top);
    Inifile.WriteInteger(Section, 'Left', AForm.Left);
    Inifile.WriteInteger(Section, 'Height', AForm.Height);
    Inifile.WriteInteger(Section, 'Width', AForm.Width);
    IniFile.UpdateFile;
  finally
    IniFile.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure LoadFormPos(AForm: TForm);
var
  Inifile: TiniFile;
  Section: string;
begin
  IniFile := TIniFile.Create(GetConfigIniFile);
  Section := AForm.Name;
  try
    if inifile.SectionExists(Section) then
    begin
      AForm.Left := Inifile.ReadInteger(Section, 'Left', 0);
      AForm.Top := Inifile.ReadInteger(Section, 'Top', 0);
      AForm.Height := IniFile.ReadInteger(Section, 'Height', 300);
      Aform.Width := Inifile.ReadInteger(Section, 'Width', 300);
    end;
  finally
    Inifile.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure GetAliasNames(AAliases: TStrings);
var
  inifile: TIniFile;
begin
  inifile := TiniFile.Create(GetAliasIniFile);
  try
    inifile.ReadSections(AAliases);
  finally
    inifile.Free
  end;
end;

//------------------------------------------------------------------------------

initialization
  //SetDefaultVariable;

end.
