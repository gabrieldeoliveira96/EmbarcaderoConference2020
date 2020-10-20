unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.StdCtrls, FMX.Effects, FMX.Objects,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts,
  System.Actions, FMX.ActnList, System.Threading,


  Macapi.Helpers,
  iOSapi.Foundation;

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
    TabItemLogin: TTabItem;
    TabItemPrincipal: TTabItem;
    Layout1: TLayout;
    Image1: TImage;
    Edit1: TEdit;
    Edit2: TEdit;
    btnEntrar: TRectangle;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    ShadowEffect1: TShadowEffect;
    ShadowEffect2: TShadowEffect;
    Label1: TLabel;
    Layout5: TLayout;
    Image2: TImage;
    ListView1: TListView;
    Layout7: TLayout;
    chkHabilitarFaceID: TCheckBox;
    ActionList1: TActionList;
    ctaLogin: TChangeTabAction;
    ctaPrincipal: TChangeTabAction;
    Image3: TImage;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnEntrarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    const
     FaceID = 'FaceID';
    function TryTouchID: Boolean;
    procedure TouchIDReply(success: Pointer; error: Pointer);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses iOSapi.LocalAuthentication, SharedPreference;

function TForm1.TryTouchID: Boolean;
var
  Context: LAContext;
  canEvaluate: Boolean;
begin
  Result := false;
  TThread.Synchronize(nil,
    procedure
    begin
      try
        Context := TLAContext.Alloc;
        Context := TLAContext.Wrap(Context.init);

        canEvaluate := Context.canEvaluatePolicy
          (LAPolicy.DeviceOwnerAuthenticationWithBiometrics, nil);
        if canEvaluate then
        begin
          Context.evaluatePolicy
            (LAPolicy.DeviceOwnerAuthenticationWithBiometrics,
            StrToNSSTR('Mensagem LocalAuthentication'), TouchIDReply);
        end;
      finally
        Context.release;
      end;
    end);

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TabControl1.TabPosition := TTabPosition.None;
  TabControl1.ActiveTab := TabItemLogin;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  chkHabilitarFaceID.IsChecked:= GetPropertiesMobile(FaceID) = 'S';
end;

procedure TForm1.btnEntrarClick(Sender: TObject);
begin

  if chkHabilitarFaceID.IsChecked then
  begin

    SetPropertiesMobile(FaceID,'S');

    TThread.CreateAnonymousThread(
      procedure
      begin

        TThread.Synchronize(TThread.CurrentThread,
          procedure
          begin
            TryTouchID;
          end);

      end).Start;

  end
  else
  begin
    SetPropertiesMobile(FaceID,'N');
    ctaPrincipal.Execute;
  end;
end;

procedure TForm1.TouchIDReply(success: Pointer; error: Pointer);
var
  E: NSError;
begin
  if Assigned(success) then
  begin
    TThread.Synchronize(TThread.CurrentThread,
    procedure
    begin
      TabControl1.ActiveTab:= TabItemPrincipal;
    end);
  end
  else
  begin
    TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        ShowMessage('Invalido');
      end);
  end;
end;

end.
