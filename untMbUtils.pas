unit untMbUtils;

interface

uses Classes;

  function GetResourceFile(AName: string; AStrings: TStrings): Boolean;
  function GetResourceStream(AName: string; AStream: TStream): Boolean;


implementation

uses System.Types;

function GetResourceStream(AName: string; AStream: TStream): Boolean;
var
  ResStream: TResourceStream;
begin
  Result := False;
  AStream.Size := 0;
  AStream.Position := 0;
  if(FindResource(hInstance, PChar(AName), RT_RCDATA) = 0)then
    Exit;
  ResStream := TResourceStream.Create(HInstance, AName, RT_RCDATA);
  try
    ResStream.Position := 0;
    AStream.CopyFrom(ResStream, ResStream.Size);
    AStream.Position := 0;
    Result := True;
  finally
    ResStream.Free;
  end;
end;

function GetResourceFile(AName: string; AStrings: TStrings): Boolean;
var
  ResStream: TResourceStream;
begin
  Result := False;
  AStrings.Clear;
  if(FindResource(hInstance, PChar(AName), RT_RCDATA) = 0)then
    Exit;
  ResStream := TResourceStream.Create(HInstance, AName, RT_RCDATA);
  try
    ResStream.Position := 0;
    AStrings.LoadFromStream(ResStream);
    Result := True;
  finally
    ResStream.Free;
  end;
end;


end.
