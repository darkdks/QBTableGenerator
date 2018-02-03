object Form3: TForm3
  Left = 0
  Top = 0
  Align = alCustom
  BorderStyle = bsSingle
  Caption = 'QB File Tool 0.4 by darkdks'
  ClientHeight = 860
  ClientWidth = 1075
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblFile: TLabel
    Left = 0
    Top = 841
    Width = 1075
    Height = 19
    Align = alBottom
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitWidth = 5
  end
  object pgc1: TPageControl
    Left = 0
    Top = 0
    Width = 1075
    Height = 824
    ActivePage = ts3
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object ts1: TTabSheet
      Caption = 'QB Files to Table file'
      object pnl2: TPanel
        Left = 0
        Top = 0
        Width = 1067
        Height = 105
        Align = alTop
        BevelEdges = [beLeft, beBottom]
        BevelOuter = bvNone
        TabOrder = 0
        object lbl2: TLabel
          Left = 3
          Top = 49
          Width = 135
          Height = 13
          Caption = 'Destination of the file tables'
        end
        object lbl1: TLabel
          Left = 3
          Top = 3
          Width = 119
          Height = 13
          Caption = 'Source folder with tables'
        end
        object edtTargetTabs: TJvFilenameEdit
          Left = 3
          Top = 68
          Width = 441
          Height = 21
          DialogKind = dkSave
          TabOrder = 0
          Text = 'C:\Users\Samuel Rodrigues\Desktop\THUG21\alltables.txt'
        end
        object edtSourceQBS: TJvDirectoryEdit
          Left = 3
          Top = 22
          Width = 441
          Height = 21
          OnAfterDialog = edtSourceQBSAfterDialog
          DialogKind = dkWin32
          TabOrder = 1
          Text = 'C:\Users\Samuel Rodrigues\Desktop\scripts'
        end
        object pro: TButton
          AlignWithMargins = True
          Left = 943
          Top = 15
          Width = 109
          Height = 75
          Margins.Left = 15
          Margins.Top = 15
          Margins.Right = 15
          Margins.Bottom = 15
          Align = alRight
          Caption = 'Get all tables'
          TabOrder = 2
          OnClick = proClick
        end
      end
      object ListBox1: TCheckListBox
        Left = 0
        Top = 105
        Width = 1067
        Height = 691
        Align = alClient
        ItemHeight = 13
        TabOrder = 1
      end
    end
    object ts2: TTabSheet
      Caption = 'Script Convert'
      ImageIndex = 1
      object pnl1: TPanel
        Left = 0
        Top = 0
        Width = 1067
        Height = 113
        Align = alTop
        BevelEdges = [beLeft, beBottom]
        BevelOuter = bvNone
        TabOrder = 0
        object lbl4: TLabel
          Left = 3
          Top = 49
          Width = 101
          Height = 13
          Caption = 'Decompiled Script file'
        end
        object lbl3: TLabel
          Left = 3
          Top = 3
          Width = 43
          Height = 13
          Caption = 'Table file'
        end
        object lblTablesCount: TLabel
          Left = 486
          Top = 49
          Width = 3
          Height = 13
          Alignment = taRightJustify
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object edt3: TJvFilenameEdit
          Left = 3
          Top = 68
          Width = 486
          Height = 21
          Filter = 'decompiled qb script (*.txt)|*.txt'
          TabOrder = 0
          OnChange = edt3Change
        end
        object edt2: TJvFilenameEdit
          Left = 4
          Top = 22
          Width = 485
          Height = 21
          Align = alCustom
          Filter = 'All tabs file (.txt)|*.txt'
          TabOrder = 1
          OnChange = edt2Change
        end
        object btn_convertScript: TButton
          AlignWithMargins = True
          Left = 946
          Top = 15
          Width = 106
          Height = 83
          Margins.Left = 15
          Margins.Top = 15
          Margins.Right = 15
          Margins.Bottom = 15
          Align = alRight
          Caption = 'Replace with tables'
          TabOrder = 2
          OnClick = btnConvertScript
        end
        object cb_autoReplace: TCheckBox
          Left = 404
          Top = 90
          Width = 85
          Height = 17
          Caption = 'Auto convert'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object cb_addUnknownTables: TCheckBox
          Left = 225
          Top = 90
          Width = 173
          Height = 17
          Caption = 'Add unknown tables to table list'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
      end
      object pgc2: TPageControl
        Left = 0
        Top = 113
        Width = 1067
        Height = 683
        ActivePage = ts5
        Align = alClient
        TabOrder = 1
        object ts4: TTabSheet
          Caption = 'Original'
          object mmoScriptOriginal: TMemo
            Left = 0
            Top = 0
            Width = 1059
            Height = 655
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 0
          end
        end
        object ts5: TTabSheet
          Caption = 'Converted'
          ImageIndex = 1
          object rcScriptConverted: TJvRichEdit
            Left = 0
            Top = 0
            Width = 1059
            Height = 655
            Align = alClient
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
        end
      end
    end
    object ts3: TTabSheet
      Caption = 'Script Folder decompiler'
      ImageIndex = 2
      object pnl3: TPanel
        Left = 0
        Top = 0
        Width = 1067
        Height = 105
        Align = alTop
        BevelEdges = [beLeft, beBottom]
        BevelOuter = bvNone
        TabOrder = 0
        object lbl6: TLabel
          Left = 3
          Top = 3
          Width = 94
          Height = 13
          Caption = 'Script Source folder'
        end
        object Label1: TLabel
          Left = 3
          Top = 49
          Width = 37
          Height = 13
          Caption = 'QB Tool'
        end
        object lbl5: TLabel
          Left = 71
          Top = 49
          Width = 189
          Height = 13
          Caption = 'Argument (without space and filename)'
        end
        object edt4: TJvDirectoryEdit
          Left = 3
          Top = 22
          Width = 441
          Height = 21
          OnAfterDialog = edt4AfterDialog
          DialogKind = dkWin32
          TabOrder = 0
          Text = 'C:\Users\Samuel Rodrigues\Desktop\scripts'
        end
        object btn1: TButton
          AlignWithMargins = True
          Left = 943
          Top = 15
          Width = 109
          Height = 75
          Margins.Left = 15
          Margins.Top = 15
          Margins.Right = 15
          Margins.Bottom = 15
          Align = alRight
          Caption = 'Decompile'
          TabOrder = 1
          OnClick = btn1Click
        end
        object edt_ToolName: TEdit
          Left = 3
          Top = 68
          Width = 62
          Height = 21
          TabOrder = 2
          Text = 'roq.exe'
        end
        object edt_QbArgument: TEdit
          Left = 71
          Top = 68
          Width = 189
          Height = 21
          TabOrder = 3
          Text = '-d'
        end
        object btnclearall: TButton
          Left = 850
          Top = 68
          Width = 75
          Height = 25
          Caption = 'Clear all'
          TabOrder = 4
        end
      end
      object ListBox2: TCheckListBox
        Left = 0
        Top = 105
        Width = 1067
        Height = 691
        Align = alClient
        ItemHeight = 13
        TabOrder = 1
      end
    end
    object ts6: TTabSheet
      Caption = 'Find text in a folder'
      ImageIndex = 3
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 1067
        Height = 105
        Align = alTop
        BevelEdges = [beLeft, beBottom]
        BevelOuter = bvNone
        TabOrder = 0
        object Label3: TLabel
          Left = 3
          Top = 3
          Width = 94
          Height = 13
          Caption = 'Script Source folder'
        end
        object Text: TLabel
          Left = 3
          Top = 49
          Width = 56
          Height = 13
          Caption = 'Text to find'
        end
        object JvDirectoryEdit1: TJvDirectoryEdit
          Left = 3
          Top = 22
          Width = 441
          Height = 21
          DialogKind = dkWin32
          TabOrder = 0
          Text = 'C:\Users\Samuel Rodrigues\Desktop\scripts'
        end
        object Button2: TButton
          AlignWithMargins = True
          Left = 943
          Top = 15
          Width = 109
          Height = 75
          Margins.Left = 15
          Margins.Top = 15
          Margins.Right = 15
          Margins.Bottom = 15
          Align = alRight
          Caption = 'Find'
          TabOrder = 1
          OnClick = FindText
        end
        object edtTextToFind: TEdit
          Left = 3
          Top = 68
          Width = 574
          Height = 21
          TabOrder = 2
          OnKeyPress = edtTextToFindKeyPress
        end
        object cb_caseSensitive: TCheckBox
          Left = 583
          Top = 68
          Width = 97
          Height = 17
          Caption = 'Case sensitive'
          TabOrder = 3
        end
      end
      object PG_FindString: TPageControl
        Left = 0
        Top = 105
        Width = 1067
        Height = 691
        ActivePage = TS_MachFound
        Align = alClient
        TabOrder = 1
        object TS_MachFound: TTabSheet
          Caption = 'Text Mach'
          object tvTextMach: TTreeView
            Left = 0
            Top = 0
            Width = 1059
            Height = 663
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Indent = 19
            ParentFont = False
            TabOrder = 0
            OnDblClick = tvTextMachDblClick
            OnKeyUp = tvTextMachKeyUp
          end
        end
        object TS_ViewFile: TTabSheet
          Caption = 'File View'
          ImageIndex = 1
          PopupMenu = pm2
          object rce_ViewFile: TJvRichEdit
            Left = 0
            Top = 0
            Width = 1059
            Height = 663
            Align = alClient
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            PopupMenu = pm2
            TabOrder = 0
          end
        end
      end
    end
    object ts7: TTabSheet
      Caption = 'Options'
      ImageIndex = 4
      object Label2: TLabel
        Left = 19
        Top = 17
        Width = 71
        Height = 13
        Caption = 'Custom viewer'
      end
      object lbl7: TLabel
        Left = 19
        Top = 63
        Width = 52
        Height = 13
        Caption = 'Arguments'
      end
      object lbl8: TLabel
        Left = 19
        Top = 109
        Width = 262
        Height = 44
        AutoSize = False
        Caption = 
          'Variables: %FILEPATH% = Full location of file to edit %LINE% = L' +
          'ine number of searched string %COLUMN% = Start position of the s' +
          'earched string'
        WordWrap = True
      end
      object chk_customEditor: TCheckBox
        Left = 378
        Top = 63
        Width = 126
        Height = 17
        Caption = 'Enable Custom editor'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = chk_customEditorClick
      end
      object edt_editorPath: TJvFilenameEdit
        Left = 19
        Top = 36
        Width = 302
        Height = 21
        Align = alCustom
        Filter = 'QB Editor (.exe)|*.exe|All files (*.*)|*.*'
        TabOrder = 1
        Text = 'C:\Program Files (x86)\Notepad++\notepad++.exe'
        OnChange = edt2Change
      end
      object edt_CVArg: TEdit
        Left = 19
        Top = 82
        Width = 302
        Height = 21
        TabOrder = 2
        Text = '%FILEPATH% -n%LINE% -c%COLUMN%'
      end
      object mmo1: TMemo
        Left = 112
        Top = 296
        Width = 497
        Height = 273
        TabOrder = 3
      end
      object btn2: TButton
        Left = 112
        Top = 265
        Width = 75
        Height = 25
        Caption = 'btn2'
        TabOrder = 4
        OnClick = btn2Click
      end
    end
  end
  object pb1: TProgressBar
    Left = 0
    Top = 824
    Width = 1075
    Height = 17
    Align = alBottom
    TabOrder = 1
  end
  object pm2: TPopupMenu
    Left = 752
    Top = 32
    object Close1: TMenuItem
      Caption = 'Close '
      OnClick = Close1Click
    end
  end
  object pm1: TPopupMenu
    Left = 784
    Top = 32
    object mniClear1: TMenuItem
      Caption = 'Clear'
      OnClick = mniClear1Click
    end
  end
  object FindDialog1: TFindDialog
    Left = 832
    Top = 72
  end
end
