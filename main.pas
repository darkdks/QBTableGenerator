unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvToolEdit, ufuncoes, ComCtrls, QBTables,
  ExtCtrls, JvRichEdit, Buttons,
  CheckLst, Menus, JvExStdCtrls, Mask, JvExMask, ShellAPI, IOUtils;

type

  TForm3 = class(TForm)
    pgc1: TPageControl;
    ts1: TTabSheet;
    tsScriptConvert: TTabSheet;
    pnl1: TPanel;
    pnl2: TPanel;
    edt3: TJvFilenameEdit;
    lbl4: TLabel;
    edt2: TJvFilenameEdit;
    lbl3: TLabel;
    btn_convertScript: TButton;
    edtTargetTabs: TJvFilenameEdit;
    lbl2: TLabel;
    edtSourceQBS: TJvDirectoryEdit;
    lbl1: TLabel;
    pro: TButton;
    pb1: TProgressBar;
    lblFile: TLabel;
    lblTablesCount: TLabel;
    cb_autoReplace: TCheckBox;
    cb_addUnknownTables: TCheckBox;
    pgc_scriptConvert: TPageControl;
    tsScriptOriginal: TTabSheet;
    tsScriptConverted: TTabSheet;
    ts3: TTabSheet;
    pnl3: TPanel;
    lbl6: TLabel;
    edt4: TJvDirectoryEdit;
    btn1: TButton;
    Label1: TLabel;
    edt_ToolName: TEdit;
    ListBox2: TCheckListBox;
    ListBox1: TCheckListBox;
    ts6: TTabSheet;
    Panel1: TPanel;
    Label3: TLabel;
    Text: TLabel;
    JvDirectoryEdit1: TJvDirectoryEdit;
    Button2: TButton;
    edtTextToFind: TEdit;
    PG_FindString: TPageControl;
    TS_MachFound: TTabSheet;
    TS_ViewFile: TTabSheet;
    rce_ViewFile: TJvRichEdit;
    cb_caseSensitive: TCheckBox;
    tvTextMach: TTreeView;
    pm2: TPopupMenu;
    Close1: TMenuItem;
    ts7: TTabSheet;
    lbl5: TLabel;
    edt_QbArgument: TEdit;
    pm1: TPopupMenu;
    mniClear1: TMenuItem;
    Label2: TLabel;
    chk_customEditor: TCheckBox;
    edt_editorPath: TJvFilenameEdit;
    FindDialog1: TFindDialog;
    edt_CVArg: TEdit;
    lbl7: TLabel;
    lbl8: TLabel;
    btnclearall: TButton;
    pcScriptConverted: TPageControl;
    ts_conv_script: TTabSheet;
    ts_conv_table: TTabSheet;
    pcScriptOriginal: TPageControl;
    ts_orig_script: TTabSheet;
    mmoScriptOriginal: TMemo;
    ts_orig_table: TTabSheet;
    mmoOrigTableFile: TMemo;
    pnl4: TPanel;
    btnSaveScript: TButton;
    dlgSave1: TSaveDialog;
    Panel2: TPanel;
    btnSaveTables: TButton;
    rcTableConverted: TMemo;
    rcScriptConverted: TMemo;

    procedure proClick(Sender: TObject);
    procedure btnConvertScript(Sender: TObject);
    procedure edt3Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtSourceQBSAfterDialog(Sender: TObject; var AName: string;
      var AAction: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edt2Change(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure edtTimeOutKeyPress(Sender: TObject; var Key: Char);
    procedure FindText(Sender: TObject);
    procedure tvTextMachDblClick(Sender: TObject);
    procedure edtTextToFindKeyPress(Sender: TObject; var Key: Char);
    procedure mniClear1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure edt4AfterDialog(Sender: TObject; var AName: string;
      var AAction: Boolean);
    procedure FindDialog1Find(Sender: TObject);
    procedure chk_customEditorClick(Sender: TObject);
    procedure tvTextMachKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnSaveScriptClick(Sender: TObject);

  private
    Tables: TQBTables;
    procedure AddAllFilesInDir(ListBox: TCheckListBox; FileExt: string;
      const Dir: string);
    procedure FormtarHTML(RichEdit: TJvRichEdit;
      xTextValue, xTag, DopCol: TColor);

    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.btn1Click(Sender: TObject);
var
  I: Integer;
  TimePassed: Cardinal;
  MainFolder, CurrentFolder, FileName, FileSubDir, Arg: string;
  ScriptBat: TStringList;
begin
  if ListBox2.Count < 1 then
  begin
    ShowMessage('No files. Select a folder fisrt.');
    Exit;

  end;
  MainFolder := edt4.Text;
  CurrentFolder := '';
  ScriptBat := TStringList.Create;
  ShowMessage('If a file decompile take more than 10 secs' + #13 +
    'close the next window and unselect this file' + #13 +
    'from the list, because probably this file is bugged.');

  ScriptBat.Add('@echo off');
  ScriptBat.Add('color F0');
  ScriptBat.Add('title QB Tool - Folder QB Decompiler');
  ScriptBat.Add(ExtractFileDrive(edt4.Text));
  ScriptBat.Add('cd "' + edt4.Text + '"');
  ScriptBat.Add('copy "' + ExtractFilePath(Application.ExeName) +
    edt_ToolName.Text + '" "' + MainFolder + '" /y ');

  for I := 0 to ListBox2.Count - 1 do
  begin
    if ListBox2.Checked[I] then
    begin
      CurrentFolder := ExtractFilePath(ListBox2.Items[I]);
      FileSubDir := StringReplace(CurrentFolder, MainFolder + '\', '', []);
      FileName := TPath.GetFileNameWithoutExtension(ListBox2.Items[I]);
      ScriptBat.Add('echo. ');
      ScriptBat.Add('echo    ' + IntToStr(I) + ' of ' + IntToStr(ListBox2.Count)
        + ' files processed');
      ScriptBat.Add('echo    Decompiling file ' + FileSubDir + FileName
        + '.qb ');
      ScriptBat.Add(edt_ToolName.Text + ' ' + edt_QbArgument.Text + ' ' +
        FileSubDir + FileName + '.qb > ' + FileSubDir + FileName + '.txt');

      ScriptBat.Add('cls');
    end;

  end;
  ScriptBat.Add('echo.');
  ScriptBat.Add('echo Files processed.');
  ScriptBat.Add('echo.');
  ScriptBat.Add('echo.');
  ScriptBat.Add('echo.');
  ScriptBat.Add('echo.');
  ScriptBat.Add('echo.');
  ScriptBat.Add('echo.');
  ScriptBat.Add('pause');
  ScriptBat.SaveToFile(MainFolder + '\ScriptDescompile.bat');
  ScriptBat.Free;
  ExecuteFile(MainFolder + '\ScriptDescompile.bat', '');

end;

procedure TForm3.btnSaveScriptClick(Sender: TObject);
Var
  fileToSave: TStringList;
begin
  fileToSave := TStringList.Create;
  try

    if Sender = btnSaveScript then
    fileToSave.Text := rcScriptConverted.Text;
    if Sender = btnSaveTables then
    fileToSave.Text := rcTableConverted.Text;
    if dlgSave1.Execute(Self.Handle) then
    begin
       fileToSave.SaveToFile(dlgSave1.FileName);
      ShowMessage('Saved');
    end;
  finally
    FreeAndNil(fileToSave);
  end;
end;

{
  procedure TForm3.btn2Click(Sender: TObject);
  var SpecialWords: array of string;
  begin
  SetLength(SpecialWords, 50);
  SpecialWords[0] := '#/ QB Script version 2.1 by RoQ www.HackTHPS.de';
  SpecialWords[0] := '%include "x.qb_table.qbi"   #/ Table file';
  SpecialWords[0] := 'function';
  SpecialWords[0] := 'endfunction';
  SpecialWords[0] := 'if';
  SpecialWords[0] := 'else';
  SpecialWords[0] := 'endif';
  SpecialWords[0] := 'while';
  SpecialWords[0] := 'loop_to';
  SpecialWords[0] := 'continue';
  SpecialWords[0] := 'NOT';
  SpecialWords[0] := 'CALL';
  SpecialWords[0] := 'arguments';
  SpecialWords[0] := 'OR';
  SpecialWords[0] := '%GLOBAL%';
  SpecialWords[0] := 'isNull';
  SpecialWords[0] := ':i';
  SpecialWords[0] := 'a{';
  SpecialWords[0] := 'a }{ ;
  SpecialWords[0] := 's }{ ';
  SpecialWords[0] := 's{';
  SpecialWords[0] := '%f';
  SpecialWords[0] := '(';
  SpecialWords[0] := ')';
  SpecialWords[0] := '"';
  SpecialWords[0] := '%i';
  SpecialWords[0] := '=';
  SpecialWords[0] := '$';
  SpecialWords[0] := '>';
  SpecialWords[0] := '<';
  SpecialWords[0] := '-';
  SpecialWords[0] := '+';
  SpecialWords[0] := '*';
  SpecialWords[0] := '.';
  SpecialWords[0] := ',';




  //for i := 0 to List.Count - 1 do


  end;
}
procedure TForm3.btnConvertScript(Sender: TObject);
var
  Script: TStringList;

  NO_ID_COUNT, FOUND_ID_COUNT, I: Integer;
var
  tables_qbi: TStringList;
begin
  if High(Tables.Table) < 0 then
  begin
    ShowMessage('No table file loaded.');
    Exit;
  end;
  Script := TStringList.Create;
  Script.AddStrings(mmoScriptOriginal.Lines);
  tables_qbi := TStringList.Create;
  pb1.Max := Script.Count + 49;
  lblFile.Caption := ('Reading tab file...');
  Application.ProcessMessages;
  pb1.Position := 50;
  lblFile.Caption := (IntToStr(High(Tables.Table)) +
    ' tables loaded. Loading script file...');
  Application.ProcessMessages;
  Tables.ProcessScript(Script, tables_qbi, cb_addUnknownTables.Checked,
    NO_ID_COUNT, FOUND_ID_COUNT);

  pb1.Position := 0;
  Application.ProcessMessages;
  rcScriptConverted.Lines.Text := Script.Text;
  rcTableConverted.Lines.Text := tables_qbi.Text;
  lblFile.Caption := 'Processed tables: ' +
    IntToStr(FOUND_ID_COUNT + NO_ID_COUNT) + '           Found: ' +
    IntToStr(FOUND_ID_COUNT) + '           Not found: ' + IntToStr(NO_ID_COUNT);
  Application.ProcessMessages;
  tsScriptConverted.TabVisible := True;
  pgc_scriptConvert.ActivePage := tsScriptConverted;
  pcScriptConverted.ActivePage := ts_conv_script;
  Script.Free;
  tables_qbi.Free;

end;

{
  procedure TForm3.Button1Click(Sender: TObject);
  var iPosIni, iPosLast, i, y : integer;
  FunsWords: TFunTypes;

  begin
  FunsWords := TFunTypes.Create;
  with rce_ViewFile do begin
  Lines.BeginUpdate;
  FunsWords.AddFun(' function', $000000BB, True, Font.Size);
  FunsWords.AddFun(' endfunction', $000000BB, True, Font.Size);
  FunsWords.AddFun('if', $00207D00, True, Font.Size);
  FunsWords.AddFun('else', $00207D00, True, Font.Size);
  FunsWords.AddFun('endif', $00207D00, True, Font.Size);
  FunsWords.AddFun('while', clBlue, True, Font.Size);
  FunsWords.AddFun('loop_to', clBlue, True, Font.Size);
  FunsWords.AddFun('continue', clBlue, True, Font.Size);
  FunsWords.AddFun('arguments', clNavy, True, Font.Size);
  FunsWords.AddFun('NOT', $00207D00, True, Font.Size);
  FunsWords.AddFun('CALL', clNavy, True, Font.Size);
  FunsWords.AddFun(':i', clBlack, false, Font.Size + 5);
  FunsWords.AddFun('$', clBlack, True, Font.Size);
  FunsWords.AddFun('.', clBlack, True, Font.Size + 3);

  //Carrega o RichEdit com as propriedades iniciais

  //Funções
  for I := 0 to High(FunsWords.Funs) do begin
  iPosLast := 0;
  iPosIni := 0;
  while iPosIni >= 0 do begin
  iPosIni := rce_ViewFile.FindText(FunsWords.Funs[i].NAME, iPosLast, length(rce_ViewFile.Text), []);
  if iPosIni >= 0 then
  begin
  SelStart  := iPosIni;
  SelLength := length(FunsWords.Funs[i].NAME);
  SelAttributes.color := FunsWords.Funs[i].Color;
  SelAttributes.Bold := FunsWords.Funs[i].Bold;
  end;
  iPosLast := iPosIni + Length(FunsWords.Funs[i].NAME);
  end;
  end;

  SelStart := 0;
  SelText := '';
  Lines.EndUpdate;
  end;
  FunsWords.Free;
  end; }
procedure TForm3.chk_customEditorClick(Sender: TObject);
begin
  edt_editorPath.Enabled := chk_customEditor.Checked = True;
  edt_CVArg.Enabled := chk_customEditor.Checked = True;
end;

procedure TForm3.Close1Click(Sender: TObject);
begin
  rce_ViewFile.Clear;
  TS_ViewFile.TabVisible := False;
end;

procedure TForm3.FindDialog1Find(Sender: TObject);

var
  FoundAt: LongInt;
  StartPos, ToEnd: Integer;
  mySearchTypes: TRichSearchTypes;
  myFindOptions: TFindOptions;
begin
  mySearchTypes := [];
  with rce_ViewFile do
  begin
    if frMatchCase in FindDialog1.Options then
      mySearchTypes := mySearchTypes + [stMatchCase];
    if frWholeWord in FindDialog1.Options then
      mySearchTypes := mySearchTypes + [stWholeWord];
    { Begin the search after the current selection, if there is one. }
    { Otherwise, begin at the start of the text. }
    if SelLength <> 0 then
      StartPos := SelStart + SelLength
    else
      StartPos := 0;
    { ToEnd is the length from StartPos through the end of the
      text in the rich edit control. }
    ToEnd := Length(Text) - StartPos;
    FoundAt := rce_ViewFile.FindText(FindDialog1.FindText, StartPos, ToEnd,
      mySearchTypes);
    if FoundAt <> -1 then
    begin
      SetFocus;
      SelStart := FoundAt;
      SelLength := Length(FindDialog1.FindText);
    end
    else
      Beep;
  end;
end;

procedure TForm3.FindText(Sender: TObject);
var
  ListBox: TCheckListBox;
  TextStrings: TStringList;
  I, Y, FindPos: Integer;
  TextToSeek: String;
  CaseSensitive: Boolean;
  MainTreeNode: TTreeNode;
  SubTreeNode: TTreeNode;
  SubTreeNodes: array of TTreeNode;
  LastFileFound: string;
  ItensFound: Integer;
begin
  ListBox := TCheckListBox.Create(Self);
  ListBox.Visible := False;
  ListBox.Parent := Self;
  TextStrings := TStringList.Create;
  ListBox.Clear;
  FindPos := 0;
  LastFileFound := '';
  CaseSensitive := cb_caseSensitive.Checked;
  MainTreeNode := tvTextMach.Items.Add(nil, 'Matching results for "' +
    edtTextToFind.Text + '"');

  if CaseSensitive then
    TextToSeek := edtTextToFind.Text
  else
    TextToSeek := AnsiUpperCase(edtTextToFind.Text);
  AddAllFilesInDir(ListBox, '.txt', JvDirectoryEdit1.Text);
  ListBox.CheckAll(cbChecked, True, True);
  pb1.Max := ListBox.Count;
  pb1.Position := 0;
  for I := 0 to ListBox.Count - 1 do
  begin
    TextStrings.Clear;
    TextStrings.LoadFromFile(ListBox.Items[I], TEncoding.UTF8);
    for Y := 0 to TextStrings.Count - 1 do
    begin
      if CaseSensitive then
        FindPos := Pos(TextToSeek, TextStrings[Y])
      else
        FindPos := Pos(TextToSeek, AnsiUpperCase(TextStrings[Y]));
      if FindPos > 0 then
      begin
        if LastFileFound = ListBox.Items[I] then
        begin
          tvTextMach.Items.AddChild(SubTreeNode, ' Line: ' + IntToStr(Y + 1) +
            ' Pos: ' + IntToStr(FindPos));
        end
        else
        begin
          SubTreeNode := tvTextMach.Items.AddChild(MainTreeNode,
            ListBox.Items[I]);
          tvTextMach.Items.AddChild(SubTreeNode, ' Line: ' + IntToStr(Y + 1) +
            ' Pos: ' + IntToStr(FindPos));

          LastFileFound := ListBox.Items[I];
        end;
        Inc(ItensFound, 1);
      end;
    end;
    pb1.Position := I;
    Application.ProcessMessages;
  end;
  MainTreeNode.Text := 'Matching results for "' + edtTextToFind.Text + '" (' +
    IntToStr(ItensFound) + ' results found)';
  ListBox.Free;
  TextStrings.Free;
  For I := 0 to tvTextMach.Items.Count - 1 do
    tvTextMach.Items.Item[I].Collapse(True);
  pb1.Position := 0;
  lblFile.Caption := IntToStr(ItensFound) + ' results found';
  // tvTextMach.Items[tvTextMach.Items.Count - 1].Selected := True;

  PG_FindString.ActivePage := TS_MachFound;
end;

procedure TForm3.edtTimeOutKeyPress(Sender: TObject; var Key: Char);
Var
  Allowed: Boolean;
begin
  Allowed := False;
  if Key in ['0' .. '9', #8, #127] then
    Allowed := True;
  if Allowed = False then
    Abort;

end;

procedure TForm3.edtSourceQBSAfterDialog(Sender: TObject; var AName: string;
  var AAction: Boolean);
begin
  AddAllFilesInDir(ListBox1, '.qb', AName);
  ListBox1.CheckAll(cbChecked, True, True);
end;

procedure TForm3.edtTextToFindKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    FindText(Sender);

end;

procedure TForm3.edt2Change(Sender: TObject);
begin
  Tables.Free;
  Tables := TQBTables.Create;
  if Tables.LoadFromFile(edt2.FileName) then
  begin
    lblTablesCount.Caption := IntToStr(High(Tables.Table)) + ' tables loaded';
  end
  else
  begin
    ShowMessage('Falied to load tables');
    lblTablesCount.Caption := '0 tables loaded';
    Exit
  end;
end;

procedure TForm3.edt3Change(Sender: TObject);
var
  table_path: String;
begin
  mmoScriptOriginal.Clear;
  mmoScriptOriginal.Lines.LoadFromFile(edt3.FileName);
  ts_orig_script.Caption := ExtractFileName(edt3.FileName);

  lblFile.Caption := 'Script loaded: ' + edt3.FileName;
  table_path := ExtractFilePath(edt3.FileName) +
    TPath.GetFileNameWithoutExtension(edt3.FileName) + '.qb_table.qbi';
  if FileExists(table_path) then
  begin
    mmoOrigTableFile.Lines.LoadFromFile(table_path);
    ts_orig_table.Caption := ExtractFileName(table_path);

  end;
  tsScriptConverted.TabVisible := False;
  if cb_autoReplace.Checked then
    btnConvertScript(Sender);

end;

procedure TForm3.edt4AfterDialog(Sender: TObject; var AName: string;
  var AAction: Boolean);
begin

  AddAllFilesInDir(ListBox2, '.qb', AName);
  ListBox2.CheckAll(cbChecked, True, True);
end;

procedure TForm3.proClick(Sender: TObject);
var
  Tables: TQBTables;
  ResultLines: TStringList;
  BytesTable: TBytesTables;
  I: Integer;
begin
  ListBox1.Clear;
  ListBox1.Items.BeginUpdate;
  AddAllFilesInDir(ListBox1, '.qb', edtSourceQBS.Directory);
  ListBox1.Items.EndUpdate;
  ListBox1.CheckAll(cbChecked, True, True);
  pb1.Max := ListBox1.Count;
  pb1.Position := 0;
  Tables := TQBTables.Create;

  for I := 0 to ListBox1.Count - 1 do
  begin
    lblFile.Caption := ListBox1.Items[I];
    BytesTable := Tables.QBToBytesTables(ListBox1.Items[I]);
    Tables.AddBytesTables(BytesTable);
    pb1.Position := I + 1;
    Application.ProcessMessages;
  end;
  lblFile.Caption := 'Tables loaded, converting to text';
  Application.ProcessMessages;
  ResultLines := Tables.ToStrings;
  lblFile.Caption := 'Saving File...';
  ResultLines.SaveToFile(edtTargetTabs.FileName);
  Application.ProcessMessages;
  // free
  Tables.Free;
  ResultLines.Free;
  SetLength(BytesTable, 0);

  lblFile.Caption := 'Done.';
  pb1.Position := 0;
  Application.ProcessMessages;

end;

procedure TForm3.tvTextMachDblClick(Sender: TObject);
Var
  Selected, ParentSelected, Arg, Line, Column: string;
  TextLine, TextPos: Integer;
begin

  if Assigned(tvTextMach.Selected) then
  begin
    if chk_customEditor.Checked = False then
    begin

      if Assigned(tvTextMach.Selected.Parent) then
        ParentSelected := tvTextMach.Selected.Parent.Text;
      Selected := tvTextMach.Selected.Text;
      if AnsiUpperCase(ExtractFileExt(ParentSelected)) = '.TXT' then
      begin
        rce_ViewFile.Lines.LoadFromFile(ParentSelected);
        TS_ViewFile.TabVisible := True;
        TS_ViewFile.Caption := ExtractFileName(ParentSelected);
        PG_FindString.ActivePage := TS_ViewFile;
      end
      else
      begin
        if AnsiUpperCase(ExtractFileExt(Selected)) = '.TXT' then
        begin
          rce_ViewFile.Lines.LoadFromFile(Selected);
          TS_ViewFile.TabVisible := True;
          TS_ViewFile.Caption := ExtractFileName(Selected);
          PG_FindString.ActivePage := TS_ViewFile;
        end;
      end;

      try
        if (Copy(Selected, 8, Pos('Pos:', Selected) - 9)) <> '' then
        begin

          TextLine := StrToInt(Copy(Selected, 8, Pos('Pos:', Selected) - 9));
          rce_ViewFile.SelStart := rce_ViewFile.Perform(EM_LINEINDEX,
            TextLine, 0);
        end;
      finally
        // Silent Discart
      end;
    end
    else
    begin
      ParentSelected := tvTextMach.Selected.Parent.Text;
      Selected := tvTextMach.Selected.Text;
      if AnsiUpperCase(ExtractFileExt(ParentSelected)) = '.TXT' then
      begin
        if (Copy(Selected, 8, Pos('Pos:', Selected) - 9)) <> '' then
        begin
          Line := Copy(Selected, 8, Pos('Pos:', Selected) - 9);
          Column := Copy(Selected, Pos('Pos:', Selected) + 5,
            Length(Selected) - Pos('Pos:', Selected));
          Arg := StringReplace(edt_CVArg.Text, '%FILEPATH%',
            '"' + ParentSelected + '"', [rfReplaceAll, rfIgnoreCase]);
          Arg := StringReplace(Arg, '%LINE%', Line,
            [rfReplaceAll, rfIgnoreCase]);
          Arg := StringReplace(Arg, '%COLUMN%', Column,
            [rfReplaceAll, rfIgnoreCase]);
          ShellExecute(Handle, 'open', PChar(edt_editorPath.Text), PChar(Arg),
            '', SW_NORMAL);
        end
        else
        begin
          ShellExecute(Handle, 'open', PChar(edt_editorPath.Text),
            PChar(ParentSelected), '', SW_NORMAL);
        end;

      end;

    end;
    // rce_ViewFile.SetSelection(Pos(rce_ViewFile.Lines[TextLine], rce_ViewFile.Lines.Text), 2, True);
  end;
  // Button1Click(Sender);
  // rce_ViewFile.SetSelection();

end;

procedure TForm3.tvTextMachKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 70) and (Shift = [ssCtrl]) then
  begin
    FindDialog1.Position := Point(rce_ViewFile.Left + rce_ViewFile.Width,
      rce_ViewFile.Top);
    FindDialog1.Execute;
  end;
end;

{ for i := 0 to tvTextMach.Items .Count - 1 do
  if tvTextMach.Items.Item[i].Selected then begin
  TS_ViewFile.TabVisible := True;
  ShowMessage(tvTextMach.Items.Item[i].Text);

  Exit;
  end; }

{ var ListaOut, ListaIn, ListaQB: TStringList;
  I,y, x: Integer;
  Tables: array of TQBTable;
  Line: string;
  TableID: String;
  begin
  ListBox1.Items.BeginUpdate;
  AddAllFilesInDir(edt1.Directory);
  ListBox1.Items.EndUpdate;
  ListaOut := TStringList.Create;
  ListaIn := TStringList.Create;
  pb1.Max := ListBox1.Count;
  pb1.Position := 0;
  SetLength(Tables,1);
  Tables[0] := TQBTable.Create;

  for i := 0 to ListBox1.Count - 1 do begin
  ListaIn.LoadFromFile(ListBox1.Items[i]);
  for y := 0 to ListaIn.Count - 1 do begin
  Line := ListaIn[y];
  if not LineExists(ListaOut, Line) then begin
  end;
  end;
  pb1.Position := i +1;
  Application.ProcessMessages;
  end;

  ListaOut.SaveToFile(edt1.Text + '\alltables.txt');
  ListaOut.Free;
  ListaIn.Free;
  pb1.Position:=0; }

procedure TForm3.AddAllFilesInDir(ListBox: TCheckListBox; FileExt: string;
  const Dir: string);
var
  SR: TSearchRec;
begin

  if FindFirst(IncludeTrailingBackslash(Dir) + '*.*', faAnyFile or faDirectory,
    SR) = 0 then
    try
      repeat

        if ((SR.Attr and faDirectory) = 0) then
        begin
          if ExtractFileExt(SR.Name) = FileExt then
            ListBox.Items.Add(Dir + '\' + SR.Name)
        end
        else if (SR.Name <> '.') and (SR.Name <> '..') then
          AddAllFilesInDir(ListBox, FileExt, IncludeTrailingBackslash(Dir) +
            SR.Name); // recursive call!
      until FindNext(SR) <> 0;
    finally
      FindClose(SR);
    end;
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Tables.Free;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  Tables := TQBTables.Create;
  tsScriptConverted.TabVisible := False;
  TS_ViewFile.TabVisible := False;
  PG_FindString.ActivePage := TS_MachFound;
  if FileExists(ExtractFilePath(Application.ExeName)+ 'alltables.txt') then
  edt2.FileName := ExtractFilePath(Application.ExeName)+ 'alltables.txt';
end;

procedure TForm3.FormtarHTML(RichEdit: TJvRichEdit;
  xTextValue, xTag, DopCol: TColor);

var

  I, iDop: Integer;

  s: string;

  xCor: TColor;

  isTag, isDop: Boolean;

begin

  iDop := 0;
  isDop := False;
  isTag := False;
  xCor := xTextValue;
  RichEdit.SetFocus;
  for I := 0 to Length(RichEdit.Text) do
  begin
    RichEdit.SelStart := I;
    RichEdit.SelLength := 1;
    s := RichEdit.SelText;
    if (s = '<') or (s = '{') then
      isTag := True;

    if isTag then
    begin
      if (s = '"') then
        if not isDop then
        begin
          iDop := 1;
          isDop := True;
        end
        else
        begin
          isDop := False;
        end;
      if isDop then
      begin
        if iDop <> 1 then
          xCor := DopCol;
      end
      else
        xCor := xTag
    end
    else
    begin
      xCor := xTextValue;
    end;
    RichEdit.SelAttributes.Color := xCor;
    iDop := 0;
    if (s = '<') or (s = '}') then
      isTag := False;
  end;
  RichEdit.SelLength := 0;

end;

procedure TForm3.mniClear1Click(Sender: TObject);
begin
  tvTextMach.Items.Clear;
end;

end.
