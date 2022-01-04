unit DW.Cryptor;

// *** EXTREMELY **** simple "encrypt/decrypt"
// DO NOT USE THIS FOR ANYTHING SUPER CRITICAL - it's just to appease app users

interface

uses
  System.SysUtils;

type
  TCryptor = record
  private
    class procedure AdjustBytes(const ABytes: TBytes); static;
  public
    class function Decrypt(const ASource: string): string; overload; static;
    class function Encrypt(const ASource: string): string; overload; static;
  end;


implementation

uses
  // RTL
  System.ZLib, System.NetEncoding;

{ TCryptor }

class procedure TCryptor.AdjustBytes(const ABytes: TBytes);
var
  LSwap: Byte;
  LLast: Integer;
begin
  LLast := Length(ABytes) - 1;
  if LLast > 1 then
  begin
    LSwap := ABytes[0];
    ABytes[0] := ABytes[LLast];
    ABytes[LLast] := LSwap;
  end;
end;

class function TCryptor.Decrypt(const ASource: string): string;
var
  LBytes: TBytes;
begin
  LBytes := TNetEncoding.Base64.DecodeStringToBytes(ASource);
  AdjustBytes(LBytes);
  Result := ZDecompressStr(LBytes);
end;

class function TCryptor.Encrypt(const ASource: string): string;
var
  LBytes: TBytes;
begin
  LBytes := ZCompressStr(ASource);
  AdjustBytes(LBytes);
  Result := TNetEncoding.Base64.EncodeBytesToString(LBytes);
end;

end.
