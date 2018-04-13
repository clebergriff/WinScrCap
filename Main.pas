unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, Vcl.Graphics,
  Vcl.Forms, System.Classes, Vcl.ExtCtrls;

type
  TfrmMain = class(TForm)
    TrayIcon1: TTrayIcon;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TrayIcon1Click(Sender: TObject);
  private
    { Private declarations }
    FHotkeyWnd : HWND;
    procedure HandleHotkey(var msg : TMessage);

    procedure CaptureScreen(ABitmap: TBitmap);
    procedure CaptureClipboard;
    procedure pLimparMemoria;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

const
  HOTKEY1_ID = 1;

implementation

uses
  ShellAPI, Clipbrd;

{$R *.dfm}

procedure TfrmMain.CaptureClipboard;
var
  vBmp: TBitmap;
begin
  vBmp := TBitmap.Create;

  try
    CaptureScreen(vBmp);
    Clipboard.Assign(vBmp);
  finally
    vBmp.Free;
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnregisterHotKey(FHotkeyWnd, HOTKEY1_ID);
  DeallocateHWND(FHotkeyWnd);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  { Hide the window and set its state variable to wsMinimized. }
  Hide;
  WindowState := wsMinimized;

  { Show the animated tray icon and also a hint balloon. }
  TrayIcon1.Visible := True;

  FHotkeyWnd := AllocateHWND(HandleHotkey);
  RegisterHotKey(FHotkeyWnd, HOTKEY1_ID, MOD_CONTROL, VK_SNAPSHOT);

  pLimparMemoria;
end;

procedure TfrmMain.HandleHotkey(var msg: TMessage);
var
  hWindow: HWND;
begin
  if msg.Msg = WM_HOTKEY then
  begin
    CaptureClipboard;

    ShellExecute(Handle,
                'open',
                PChar('mspaint'),
                nil,//PChar(ExtractFilePath(Application.ExeName) +'TMP1.jpg'),
                nil,
                SW_MAXIMIZE);

    repeat
      hWindow := FindWindow(nil, PChar('Sem título - Paint'));

      if hWindow <> 0 then
      begin
        BringWindowToTop(hWindow); // Coloca o aplicativo em 1º plano
        ShowWindow(hWindow, SW_SHOWMAXIMIZED); // Realiza o foco dele

        Keybd_event(VK_CONTROL, 0, 0, 0);
        Keybd_event(Byte('V'), 0, 0, 0);
        Keybd_event(Byte('V'), 0, KEYEVENTF_KEYUP, 0);
        Keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);
      end;
    until hWindow <> 0;
  end
  else
    Msg.Result := DefWindowProc(FHotkeyWnd, msg.Msg, msg.wParam, msg.lParam);

  pLimparMemoria;
end;

procedure TfrmMain.pLimparMemoria;
var
  MainHandle : THandle;
begin
  try
    MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessID);
    SetProcessWorkingSetSize(MainHandle, $FFFFFFFF, $FFFFFFFF);
    CloseHandle(MainHandle);
  finally
  end;

  Application.ProcessMessages;
end;

procedure TfrmMain.TrayIcon1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMain.CaptureScreen(ABitmap: TBitmap);
var
  vDesktopDC: HDC;   // variable to store the device context handle of desktop window
begin
  // get the device context handle of current desktop window
  vDesktopDC := GetWindowDC(GetDesktopWindow);
  try
    // adjust the dimension and format of the supplied bitmap to match the screen
    ABitmap.PixelFormat := pf24bit;
    ABitmap.Height := Screen.Height;
    ABitmap.Width := Screen.Width;

    // draw the content of desktop into ABitmap
    BitBlt(ABitmap.Canvas.Handle, 0, 0, ABitmap.Width, ABitmap.Height, vDesktopDC, 0, 0, SRCCOPY);
  finally
    // mark that we have done with the desktop device context
    ReleaseDC(GetDesktopWindow, vDesktopDC);
  end;
end;

end.
