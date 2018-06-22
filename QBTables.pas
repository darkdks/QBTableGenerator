unit QBTables;

interface

uses
  Classes, SysUtils, Graphics, StrUtils;

type
  TBytesTables = array of Byte;

  TQBTable = class(TObject)
  private
  public
    NAME: String;
    ID: String;
    constructor Create;
    destructor Destroy; override;
  end;

  TFunType = class(TObject)
  private
  public
    NAME: String;
    Color: TColor;
    Bold: Boolean;
    Size: Integer;
    constructor Create;
    destructor Destroy; override;
  end;

  TFunTypes = class(TObject)
  private
  public
    Funs: array of TFunType;
    function AddFun(NameID: string; Color: TColor; Bold: Boolean;
      Size: Integer): Boolean;
    constructor Create;
    destructor Destroy; override;
  end;

  TQBTables = class(TObject)
  private
  public
    Table: array of TQBTable;
    function AddTable(ID, NAME: string): Boolean;
    function TabExists(ID: string): Boolean;
    function ToStrings: TStringList;
    function AddBytesTables(Table: array of Byte): Integer;
    function QBToBytesTables(FileName: String): TBytesTables;
    function LoadFromFile(FileName: String): Boolean;
    function FindTable(ID: String): String;
    function InvertCheckSum(ID: String): String;
    function ProcessScript(Script: TStringList; var tableQbi: TStringList;
      ADDnoIDToTabList: Boolean; var NO_ID_COUNT, FOUND_ID_COUNT
      : Integer): Boolean;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

// ==============================================================================
{ TQBTable }

constructor TQBTable.Create;
begin
  NAME := '';
  ID := '';
end;

destructor TQBTable.Destroy;
begin

  inherited;
end;

{ TQBTables }

function TQBTables.AddTable(ID, NAME: string): Boolean;
begin
  Result := False;
  if TabExists(ID) = False then
  begin
    SetLength(Table, Length(Table) + 1);
    Table[High(Table)] := TQBTable.Create;
    Table[High(Table)].NAME := Name;
    Table[High(Table)].ID := ID;
    Result := True;
  end;
end;

constructor TQBTables.Create;
begin
  SetLength(Table, 0);
end;

destructor TQBTables.Destroy;
var
  i: Integer;
begin
  for i := 0 to High(Table) do
    Table[i].Free;

  inherited;
end;

function TQBTables.FindTable(ID: String): String;
var
  i: Integer;
begin
  // ShowMessage(IntToStr(Length(Table)));
  Result := '';
  if Assigned(Table) then
  begin
    for i := 0 to High(Table) do
    begin
      if Table[i].ID = ID then
      begin
        Result := Table[i].NAME;
        Break;
      end;
    end;
  end;

end;

function TQBTables.InvertCheckSum(ID: String): String;
begin
  if Length(ID) <> 8 then
    raise Exception.Create('Invalid ID Length count for ' + ID);

  Result := ReverseString( ID[2] + ID[1] + ID[4] + ID[3] + ID[6] + ID[5] + ID[8] + ID[7]);
end;

function TQBTables.TabExists(ID: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  if Assigned(Table) then
  begin
    for i := 0 to High(Table) do
    begin
      if Table[i].ID = ID then
      begin
        Result := True;
        Break;
      end;
    end;

  end;
end;

function TQBTables.ToStrings: TStringList;
var
  i: Integer;
begin
  Result := TStringList.Create;
  if Length(Table) <> 0 then
  begin
    for i := 0 to High(Table) do
    begin
      Result.Add('0x' + Table[i].ID + ' "' + Table[i].NAME + '"');
    end;

  end;

end;

function TQBTables.AddBytesTables(Table: array of Byte): Integer;
var
  B, P, y: Integer;
  HEXid, TabName: String;
begin
  Result := 0;
  for B := 0 to High(Table) do
  begin
    HEXid := '';
    TabName := '';
    if Table[B] = 43 then
    begin // 2B - Inicio da ID
      for y := 1 to 4 do
        HEXid := HEXid + IntToHex(Table[B + y], 2); // Copiar a HEX ID da tab
      for y := 5 to 50 do
      begin // Copiar o Nome da tab, tamanho máximo 50
        if Table[B + y] = 0 then
          Break;
        TabName := TabName + AnsiChar(Table[B + y]);
      end;
    end;
    if (HEXid <> '') and (TabName <> '') then
    begin
      if AddTable(HEXid, TabName) then
        Inc(Result, 1);
    end;
  end;
end;

function TQBTables.QBToBytesTables(FileName: String): TBytesTables;
var
  ID, i: Integer;
  Stream: TFileStream;
  Bytes: array of Byte;
  BytesTables: TBytesTables;

begin
  // Ler todo o arquivo
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    SetLength(Bytes, Stream.Size);
    if Stream.Size > 0 then
      for ID := 0 to High(Bytes) do
      begin
        Stream.ReadBuffer(Bytes[ID], SizeOf(Bytes[ID]));
      end;
  finally
    Stream.Free;
  end;
  // Procurar pela parte de tables
  for ID := 0 to High(Bytes) do
  begin // varrer todos os bytes

    if (Bytes[ID] = 1) and (Bytes[ID + 1] = 43) then
    begin // Hex 01 2B - Inicio da table
      SetLength(BytesTables, High(Bytes) - ID + 1);
      for i := 0 to High(BytesTables) do
      begin // Loop Inicio da ID até o fim do arquivo
        BytesTables[i] := Bytes[ID + i];
      end;
    end;

  end;
  Result := BytesTables;
end;

Function TQBTables.LoadFromFile(FileName: String): Boolean;
Var
  i, y: Integer;
  Line, ID, NAME: String;
  Tables: TStringList;
begin
  Tables := TStringList.Create;
  Tables.LoadFromFile(FileName);
  Result := False;
  if Tables.Count > 0 then
  begin

    for i := 0 to Tables.Count - 1 do
    begin
      Line := Tables[i];
      y := Pos('0x', Line);
      if y > 0 then
      begin
        ID := Copy(Line, y + 2, 8);
        Name := Copy(Line, Pos('"', Line) + 1, Length(Line) - Pos('"',
          Line) - 1);
        AddTable(ID, Name);

      end;

    end;
  end;
  Result := Length(Table) > 0;
  Tables.Free;
end;

function TQBTables.ProcessScript(Script: TStringList; var tableQbi: TStringList;
  ADDnoIDToTabList: Boolean; var NO_ID_COUNT, FOUND_ID_COUNT: Integer): Boolean;
var
  i, y, x, z: Integer;
  ID_HEX: array of string;
  HEX_NAME, Temp, Line: string;
  nextTagPos: Integer;
  NewRoqScript: Boolean;
begin
  SetLength(ID_HEX, 0);
  NO_ID_COUNT := 0;
  FOUND_ID_COUNT := 0;
  NewRoqScript := Pos('$[', Script.Text) > 0;
  if NewRoqScript then
    nextTagPos := 11
  else
    nextTagPos := 9;
  for i := 0 to Script.Count - 1 do
  begin // Varrer todas as linhas
    Line := Script[i]; // Trabalhar com a linha

    for x := 0 to Length(Line) - 1 do
    begin
      // Criar uma lista com as IDS a serem mudadas
      // $12345678$
      // if x+9 < High(Line) then
      if (Line[x] = '$') and (Line[x + nextTagPos] = '$') then
      begin // Pré verificação
        Temp := '';
        for z := x + 1 to x + nextTagPos - 1 do
          if Line[z] in ['0' .. '9', 'A' .. 'F', 'a' .. 'f'] then
            Temp := Temp + Line[z]; // Copiar todos os digitos válidos
        if Length(Temp) = 8 then
        begin // Verificar se é uma TAB
          SetLength(ID_HEX, Length(ID_HEX) + 1);
          ID_HEX[High(ID_HEX)] := Temp;
          // Colocar na lista de IDS a serem buscadas
        end;
      end;
    end;
    // Buscar e substituir todas as IDS
    for y := 0 to Length(ID_HEX) - 1 do
    begin
      HEX_NAME := FindTable(AnsiUpperCase(ID_HEX[y]));
      if HEX_NAME = '' then
      begin
        HEX_NAME := 'NO_ID_FOUND_' + IntToStr(NO_ID_COUNT);
        Inc(NO_ID_COUNT, 1);
        if ADDnoIDToTabList then
          AddTable(AnsiUpperCase(ID_HEX[y]), HEX_NAME);
      end
      else
      begin
        Inc(FOUND_ID_COUNT, 1);
      end;
      if NewRoqScript then
        Line := StringReplace(Line, '[' + ID_HEX[y] + ']', HEX_NAME, [])
      else
        Line := StringReplace(Line, ID_HEX[y], HEX_NAME, []);
      // Substituir a ID HEX por Name
      tableQbi.Add('#addx 0x' + UpperCase(InvertCheckSum(ID_HEX[y])) + ' "' +
        HEX_NAME + '"');
    end;
    Script[i] := Line;
    SetLength(ID_HEX, 0); // Resetar array
  end;
end;

{ TFunType }

constructor TFunType.Create;
begin
  NAME := '';
  Color := clBlack;
  Bold := False;
  Size := 8;
end;

destructor TFunType.Destroy;
begin
  NAME := '';
  Color := 0;
  Size := 0;
  inherited;
end;

{ TFunTypes }

function TFunTypes.AddFun(NameID: string; Color: TColor; Bold: Boolean;
  Size: Integer): Boolean;
begin
  SetLength(Funs, Length(Funs) + 1);
  Funs[High(Funs)] := TFunType.Create;
  Funs[High(Funs)].NAME := NameID;
  Funs[High(Funs)].Color := Color;
  Funs[High(Funs)].Bold := Bold;
end;

constructor TFunTypes.Create;
begin
  SetLength(Funs, 0);
end;

destructor TFunTypes.Destroy;
var
  i: Integer;
begin
  for i := 0 to High(Funs) do
  begin
    Funs[i].Destroy;

  end;
  SetLength(Funs, 0);
  inherited;
end;

end.
