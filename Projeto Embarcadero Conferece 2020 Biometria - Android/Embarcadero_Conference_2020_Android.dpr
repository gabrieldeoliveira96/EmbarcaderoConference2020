program Embarcadero_Conference_2020_Android;

uses
  System.StartUpCopy,
  FMX.Forms,
  uPrincipal in 'uPrincipal.pas' {Form1},
  Android.KeyguardManager in 'Biometria\Android.KeyguardManager.pas',
  DW.Androidapi.JNI.KeyguardManager in 'Biometria\DW.Androidapi.JNI.KeyguardManager.pas',
  SharedPreference in '..\src\features\SharedPreference.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
