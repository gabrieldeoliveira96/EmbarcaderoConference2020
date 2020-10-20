unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.StdCtrls, FMX.Effects, FMX.Objects,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, Android.KeyguardManager,
  System.Actions, FMX.ActnList;

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
    TabItemLogin: TTabItem;
    Layout1: TLayout;
    Image1: TImage;
    ShadowEffect1: TShadowEffect;
    Layout2: TLayout;
    Edit1: TEdit;
    Layout3: TLayout;
    Edit2: TEdit;
    Layout4: TLayout;
    btnEntrar: TRectangle;
    ShadowEffect2: TShadowEffect;
    Label1: TLabel;
    Layout7: TLayout;
    chkHabilitarFaceID: TCheckBox;
    TabItemPrincipal: TTabItem;
    Layout5: TLayout;
    Image2: TImage;
    ListView1: TListView;
    ActionList1: TActionList;
    ctaLogin: TChangeTabAction;
    ctaPrincipal: TChangeTabAction;
    Image3: TImage;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnEntrarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    const
     FaceID = 'FaceID';
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses SharedPreference;


procedure TForm1.btnEntrarClick(Sender: TObject);
var
 Android:TEventResultClass;

begin
  if chkHabilitarFaceID.IsChecked then
  begin
    SetPropertiesMobile(FaceID,'S');

    Android:= TEventResultClass.Create(self);
    if Android.DeviceSecure then
      Android.StartActivityKeyGuard
    else
      ctaPrincipal.Execute;
  end
  else
  begin
    SetPropertiesMobile(FaceID,'N');
    ctaPrincipal.Execute;
  end;
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

end.
