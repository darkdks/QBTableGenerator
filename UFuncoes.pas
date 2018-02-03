unit UFuncoes;

interface

 uses
 SysUtils,  WinProcs, Classes, TlHelp32, ShellAPI,
 Forms, PsAPI;
 type
  TWordTriple = Array[0..2] of Word;
  procedure ExecuteFile(Path: string; Arguments: String);
  function GetParentDirectory(path : string) : string;
  function ExecuteFileAndWait(hWnd: HWND; filename: string; Parameters: string; ShowWindows: Integer; TimeOutSecs: Integer): Boolean;
  function StrEmAspas(Texto: String): string;
  function CreateNewFolderInto(Path, FolderName: String): String;
  function ExplorerFileOp(Source: TStringList; Destination: String; Operation: UINT;
  Silent: Boolean; Handle: THandle):Boolean;
  function FormatByteSize(const bytes: Int64): string;
  function GetSubText(Const Item: String; Index: Integer; Delimiter: Char): string;
  function CleanText(Text: string): string;
  Function TextToInt(Text: String): Int64;
 function ProcessMemory: longint;
 function ProcessExists(ProcessName: string): Boolean;
 Function  KillProcessByName(ExeName: String): Boolean;
 Function LineExists(List: TStringList; Line: string): Boolean;

//------------------------------------------------------------------------------


 implementation




//-------------------------- STRING FUNCTIONS ---------------------------------


 function FormatByteSize(const bytes: Int64): string;
 const
   B = 1; //byte
   KB = 1024 * B; //kilobyte
   MB = 1024 * KB; //megabyte
   GB = 1024 * MB; //gigabyte
 begin
   if bytes > GB then
     result := FormatFloat('#.## GB', bytes / GB)
   else
     if bytes > MB then
       result := FormatFloat('#.## MB', bytes / MB)
     else
       if bytes > KB then
         result := FormatFloat('#.## KB', bytes / KB)
       else
        if bytes > 0 then
         result := FormatFloat('#.## bytes', bytes)
          else
          Result := '0 bytes';
 end;




function StrEmAspas(Texto: String): string;
begin
  Result := '"' + Texto + '"';
end;

function GetParentDirectory(path : string) : string;
begin
   result := ExpandFileName(path + '\..');
end;

//------------------------- FILE EXECUTATION -----------------------------------

procedure ExecuteFile(Path: string; Arguments: String);
Var
FileName, FilePath: string;
WState: Integer;
WHandle: HWND;
begin
  //dbg('Executing file ' + Path );
  FileName :=  ExtractFileName(Path);
  FilePath :=  ExtractFilePath(Path);
  WState := SW_SHOWMAXIMIZED;
  if FileExists(Path) then begin
    if Arguments <> '' then begin
      ShellExecute(WHandle,
      PChar('Open'),
      PChar(FileName),
      nil,
      PChar(FilePath),
      WState);
     end else begin
      ShellExecute(WHandle,
      PChar('Open'),
      PChar(FileName),
      PChar(Arguments),
      PChar(FilePath),
      WState);
     end;
  end else begin
   //dbg('Cant load ' + Path );
  end;
  //dbg('End of executing file ' + Path );
end;

function ExecuteFileAndWait(hWnd: HWND; filename: string; Parameters: string;
ShowWindows: Integer; TimeOutSecs: Integer): Boolean;
{
    See Step 3: Redesign for UAC Compatibility (UAC)
    http://msdn.microsoft.com/en-us/library/bb756922.aspx
}
var
    sei: TShellExecuteInfo;
    ExitCode: DWORD;
    Times: Integer;

begin
    TimeOutSecs := TimeOutSecs * 1000;
    Times := 0;
    //dbg('Executing File and waiting - ' + filename );
    ZeroMemory(@sei, SizeOf(sei));
    sei.cbSize := SizeOf(TShellExecuteInfo);
    sei.Wnd := hwnd;
    sei.fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI or SEE_MASK_NOCLOSEPROCESS;
    sei.lpVerb := PChar('runas');
    sei.lpFile := PChar(Filename); // PAnsiChar;
    if parameters <> '' then
        sei.lpParameters := PChar(parameters); // PAnsiChar;
    sei.nShow := ShowWindows; //Integer;



    Application.ProcessMessages;
   if ShellExecuteEx(@sei) then begin
     repeat
     Sleep(250);

       Application.ProcessMessages;
       GetExitCodeProcess(sei.hProcess, ExitCode) ;
       if (Times * 250) >= TimeOutSecs then begin
       ExitCode := 0;
       KillProcessByName(ExtractFileName(filename));
       end;
       Inc(Times, 1);
     until (ExitCode <> STILL_ACTIVE) or  (Application.Terminated);
   end;
     //dbg('End of File executation waiting - ' + filename );

end;



//---------------------- FILE OPERATIONS ---------------------------------------

function CreateNewFolderInto(Path, FolderName: String): String;

 var I: Integer;
FullPath: String;
begin
  Result := '';
  Path := IncludeTrailingBackslash(Path);
  FolderName := ExcludeTrailingBackslash(FolderName);
  FullPath := IncludeTrailingBackslash(Path) + FolderName;

  if DirectoryExists(FullPath) then begin
    for i := 1 to 100 do begin
       FullPath := Path + FolderName +' (' + IntToStr(I) + ')';
       if DirectoryExists(FullPath) = False then begin
          Try
          if CreateDir(PWideChar(FullPath)) then Result := FullPath;
          except
          Exit;
          End;
          Exit;
       end;
    end;
  end else begin
    Try
     if CreateDir(PWideChar(FullPath)) then Result := FullPath;
    except
      Exit;
    End;
  end;

end;

function ExplorerFileOp(Source: TStringList; Destination: String; Operation: UINT;
 Silent: Boolean; Handle: THandle):Boolean;
var
  FileOP: TSHFileOpStruct;
  I: Integer;
  StrFrom, StrTo: string;
begin
  ZeroMemory(@FileOP, SizeOf(FileOP));
  StrTo := '';
  StrFrom := '';
  FileOP.Wnd := Handle;
  for i := 0 to Source.Count - 1 do StrFrom := StrFrom + Source[i] +#0;
  StrFrom := StrFrom + #0;
  StrTo := Destination;

  case Operation of
    FO_MOVE: begin
      FileOP.wFunc := FO_MOVE;
      FileOP.pFrom := PWideChar(StrFrom);
      FileOP.pTo := PWideChar(StrTo);
    end;
    FO_COPY: begin
      FileOP.wFunc := FO_COPY;
      FileOP.pFrom := PWideChar(StrFrom);
      FileOP.pTo := PWideChar(StrTo);
      FileOP.fFlags := FileOP.fFlags + FOF_NOCONFIRMATION;
    end;
    FO_DELETE: begin
      FileOP.wFunc := FO_DELETE;
      FileOP.pFrom := PWideChar(StrFrom);
    end;
    FO_RENAME: begin
      FileOP.wFunc := FO_RENAME;
      FileOP.pFrom := PWideChar(StrFrom);
      FileOP.pTo := PWideChar(StrTo);
    end;
  end;

  Result := (0 = ShFileOperation(FileOP));

end;

function GetSubText(const Item: String; Index: Integer; Delimiter: Char): string;
var I: Integer;
DC, DP: Integer;
TmpStr: String;
begin
DC := -1;
Result := '';
TmpStr := Delimiter + Item + Delimiter;
 for I := 0 to Length(TmpStr) - 1 do begin
   if TmpStr[i] = Delimiter then begin
     DC := DC + 1;
     DP := i;
   end;
   if DC = Index then  begin
    Result := Result + TmpStr[i];
   end;
  end;
 if Result <> '' then
 Result := Copy(Result, 3 , Length(Result) - 3);
end;

function CleanText(Text: string): string;
var I: Integer;
begin
    Result := '';
    for I := 1 to Length(Text)  do
      if Text[i] in ['a'..'z', 'A'..'Z', '0'..'9', '-', ' ', '_'] then
      Result := Result + Text[I];
end;

Function TextToInt(Text: String): Int64;
var
  i: Integer;
  ResultText: String;
begin
 for i := 0 to Length(Text) do if Text[i] in ['0'..'9'] then ResultText := ResultText + Text[i];
 if ResultText <> '' then Result := StrToInt64(ResultText) else Result := -0;
end;

 function ProcessMemory: longint;
var
  pmc: PPROCESS_MEMORY_COUNTERS;
  cb: Integer;
begin
  // Get the used memory for the current process
  cb := SizeOf(TProcessMemoryCounters);
  GetMem(pmc, cb);
  pmc^.cb := cb;
  if GetProcessMemoryInfo(GetCurrentProcess(), pmc, cb) then
     Result:= Longint(pmc^.WorkingSetSize);

  FreeMem(pmc);
end;


 function ProcessExists(ProcessName: string): Boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  LC: Integer;
begin
  LC := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while (Integer(ContinueLoop) <> 0) and (LC <= 1000) do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ProcessName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ProcessName))) then
    begin
      Result := True;
      ContinueLoop := False;
      end else begin
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
    end;
    Inc(LC);
  end;
  CloseHandle(FSnapshotHandle);

end;


Function  KillProcessByName(ExeName: String): Boolean;
  var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  LC: Integer;
begin
  LC:=0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while (Integer(ContinueLoop) <> 0) and (LC <= 1000) do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeName))) then
    begin
    TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0), FProcessEntry32.th32ProcessID), 0);
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
    Inc(LC);
  end;
  CloseHandle(FSnapshotHandle);
   Result := ProcessExists(ExeName) = False;

end;




Function LineExists(List: TStringList; Line: string): Boolean;
var i: Integer;
begin
Result := False;
 for I := 0 to List.Count - 1 do
  begin
   if List[i] = Line then begin
     Result := True;
     Exit;
   end;
  end;

end;




 end.




