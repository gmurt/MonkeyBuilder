unit untDprojUtils;

interface

uses Windows, Classes, ComObj, XMLIntf, XMLDoc, Registry, MonkeyBuilder_Intf;


function ReadPropertyGroupValue(AXMlDoc: IXmlDocument; APlatform, AName: string): string; overload;
function ReadPropertyGroupValueWithCondition(AXMlDoc: IXmlDocument; ACondition, AName: string): string; overload;


procedure GetProjectJarFiles(ADproj: string; AJarFiles: TStrings);
function GetProjectSearchPath(ADproj: string; APlatform: TmbPlatform): string;

function GetProjectConditionalDefines(ADproj: string; APlatform: TmbPlatform): string;

function GetCertificateKeystoreFile(ADProj: string): string;
function GetCertificateKeyStorePass(ADProj: string): string;

function GetCertificateAliasKey(ADProj: string): string;
function GetCertificateAliasKeyPass(ADProj: string): string;

procedure ReadProjectJarFiles(ADproj: string; AJarFiles: TStrings);
procedure CopyJavaFiles(ADProj, ADir: string);

procedure DelphiProjectsFromProjectGroup(AProjectGroupFile: string; ADprFiles: TStrings);


implementation

uses SysUtils, JclFileUtils, MonkeyBuilder.Project;

function ReplaceEnvironmentVars(APlatform: TmbPlatform; AText: string): string;
var
  AVars: TStrings;
  APlatformName: string;
  AXmlDoc: IXMLDocument;
  APropertyGroup: IXMLNode;
  ANode: IXMLNode;
  ICount: integer;
  AVerNum: string;
begin
    AVerNum := C_DELPHI_11_0_VER_NUM;
    AXmlDoc := TXmlDocument.Create(GetEnvironmentVariable('APPDATA')+'\Embarcadero\BDS\'+AVerNum+'\environment.proj');
    Result := AText;
    APlatformName := GetPlatformString(APlatform);
    AVars := TStringList.Create;
    try
      APropertyGroup := (AXmlDoc.ChildNodes[0].ChildNodes[0]);

      for ICount := 0 to APropertyGroup.ChildNodes.Count-1 do
      begin
        ANode := APropertyGroup.ChildNodes[ICount];
        Result := StringReplace(Result, '$('+ANode.NodeName+')', ANode.Text, [rfReplaceAll]);
      end;
      Result := StringReplace(Result, '$(PLATFORM)', APlatformName, [rfReplaceAll]);
    finally
      AVars.Free;
    end;
end;

function GetCertificateKeystoreFile(ADProj: string): string;
var
  AXml: IXMLDocument;
begin
  AXml := TXMLDocument.Create(ADProj);
  Result := ReadPropertyGroupValueWithCondition(AXml, '''$(Cfg_2_Android64)''!=''''', 'PF_KeyStore');
  if Result = '' then
    Result := ReadPropertyGroupValueWithCondition(AXml, '''$(Base_Android64)''!=''''', 'PF_KeyStore');

end;

function GetCertificateAliasKeyPass(ADProj: string): string;
var
  AXml: IXMLDocument;
begin
  AXml := TXMLDocument.Create(ADProj);
  Result := ReadPropertyGroupValueWithCondition(AXml, '''$(Cfg_2_Android64)''!=''''', 'PF_AliasKeyPass');
  if Result = '' then
    Result := ReadPropertyGroupValueWithCondition(AXml, '''$(Base_Android64)''!=''''', 'PF_AliasKeyPass');
end;

function GetCertificateKeyStorePass(ADProj: string): string;
var
  AXml: IXMLDocument;
begin
  AXml := TXMLDocument.Create(ADProj);
  Result := ReadPropertyGroupValueWithCondition(AXml, '''$(Cfg_2_Android64)''!=''''', 'PF_KeyStorePass');
  if Result = '' then
    Result := ReadPropertyGroupValueWithCondition(AXml, '''$(Base_Android64)''!=''''', 'PF_KeyStorePass');
end;

function GetCertificateAliasKey(ADProj: string): string;
var
  AXml: IXMLDocument;
begin
  AXml := TXMLDocument.Create(ADProj);
  Result := ReadPropertyGroupValueWithCondition(AXml, '''$(Cfg_2_Android64)''!=''''', 'PF_AliasKey');
  if Result = '' then
    Result := ReadPropertyGroupValueWithCondition(AXml, '''$(Base_Android64)''!=''''', 'PF_AliasKey');
end;

function GetProjectSearchPath(ADproj: string; APlatform: TmbPlatform): string;
var
  AXml: IXMLDocument;
  APath: TStrings;
  AResult: TStrings;
  AStr: string;
  APlatformStr: string;
begin
  APath := TStringList.Create;
  AResult := TStringList.Create;
  try
    APlatformStr := GetPlatformString(APlatform);
    AXml := TXMLDocument.Create(ADProj);
    APath.Delimiter := ';';
    APath.DelimitedText := ReadPropertyGroupValueWithCondition(AXml, '''$(Base_'+APlatformStr+')''!=''''', 'DCC_UnitSearchPath');
    for AStr in APath do
      if AResult.IndexOf(AStr) = -1 then
        AResult.Add(AStr);

    APath.DelimitedText := ReadPropertyGroupValueWithCondition(AXml, '''$(Cfg_2_'+APlatformStr+')''!=''''', 'DCC_UnitSearchPath');

    for AStr in APath do
      if AResult.IndexOf(AStr) = -1 then
        AResult.Add(AStr);

    if AResult.IndexOf('$(DCC_UnitSearchPath)') > -1 then
      AResult.Delete(AResult.IndexOf('$(DCC_UnitSearchPath)'));
    AResult.Text := Trim(AResult.Text);

    Result := AResult.CommaText;
    Result := StringReplace(Result, ',', ';', [rfReplaceAll]);
  finally
    APath.Free;
    AResult.Free;
  end;
end;


function GetProjectConditionalDefines(ADproj: string; APlatform: TmbPlatform): string;
var
  AXml: IXMLDocument;
  APath: TStrings;
  AResult: TStrings;
  AStr: string;
  APlatformStr: string;
begin
  APath := TStringList.Create;
  AResult := TStringList.Create;
  try
    APlatformStr := GetPlatformString(APlatform);
    AXml := TXMLDocument.Create(ADProj);
    APath.Delimiter := ';';
    APath.DelimitedText := ReadPropertyGroupValueWithCondition(AXml, '''$(Base_'+APlatformStr+')''!=''''', 'DCC_UnitSearchPath');
    for AStr in APath do
      if AResult.IndexOf(AStr) = -1 then
        AResult.Add(AStr);

    APath.DelimitedText := ReadPropertyGroupValueWithCondition(AXml, '''$(Cfg_2_'+APlatformStr+')''!=''''', 'DCC_UnitSearchPath');

    for AStr in APath do
      if AResult.IndexOf(AStr) = -1 then
        AResult.Add(AStr);
    AResult.DelimitedText := ';';
    if AResult.IndexOf('$(DCC_UnitSearchPath)') > -1 then
      AResult.Delete(AResult.IndexOf('$(DCC_UnitSearchPath)'));
    Result := AResult.DelimitedText;
  finally
    APath.Free;
    AResult.Free;
  end;
end;

procedure GetProjectJarFiles(ADproj: string; AJarFiles: TStrings);
var
  AXml: IXMLDocument;
  ICount: integer;
  ICount2: integer;
  ANode: IXMLNode;
  AValue: IXMLNode;
  AFiles: TStrings;
begin
  AXml := TXmlDocument.Create(ADproj);
  AFiles := TStringList.Create;
  try
    AFiles.Delimiter := ';';
    for ICount := 0 to AXml.ChildNodes[0].ChildNodes.Count-1 do
    begin
      ANode := AXml.ChildNodes[0].ChildNodes[ICOunt];
      if ANode.HasAttribute('Condition') then
      begin
        if (ANode.NodeName = 'PropertyGroup') and ((ANode.Attributes['Condition']) = '''$(Base_Android64)''!=''''') then
        begin
          AValue := ANode.ChildNodes.FindNode('EnabledSysJars');
          if AValue <> nil then
          begin
            AFiles.DelimitedText := AValue.Text;
            AJarFiles.Assign(AFiles);
            for ICount2 := 0 to AJarFiles.Count-1 do
            begin
              if Trim(AJarFiles[ICount2]) <> '' then
                AJarFiles[ICount2] := '$(BDSLIB)\android\Release\'+AJarFiles[ICount2];
            end;
          end;
        end;
      end;
      if (ANode.NodeName = 'ItemGroup') then
      begin
        for ICount2 := 0 to ANode.ChildNodes.Count-1 do
        begin
          AValue := ANode.ChildNodes[ICount2];
          if AValue.NodeName = 'JavaReference' then
          begin
            AJarFiles.Add(AValue.Attributes['Include']);
          end;
        end;
      end;
    end;

  finally
    AFiles.Free;
  end;
end;

function ReadPropertyGroupValueWithCondition(AXMlDoc: IXmlDocument; ACondition, AName: string): string;
var
  AStrings: TStrings;
  ANode: IXMLNode;
  ICount: integer;
  AValue: IXMLNode;
begin
  Result := '';
  AStrings := TStringList.Create;
  try
    for ICount := 0 to AXmlDoc.ChildNodes[0].ChildNodes.Count-1 do
    begin
      ANode := AXMlDoc.ChildNodes[0].ChildNodes[ICOunt];
      if (ANode.NodeName = 'PropertyGroup') and (ANode.Attributes['Condition'] = ACondition) then
      begin
        AValue := ANode.ChildNodes.FindNode(AName);
        if AValue <> nil then
        begin
          Result := AValue.Text;
          Exit;
        end;
      end;
    end;
  finally
    AStrings.Free;
  end;
end;

function ReadPropertyGroupValue(AXMlDoc: IXmlDocument; APlatform, AName: string): string;
begin
  Result := ReadPropertyGroupValueWithCondition(AXMlDoc, '''$(Cfg_2_'+APlatform+')''!=''''', AName);
  if Result = '' then
    Result := ReadPropertyGroupValueWithCondition(AXMlDoc, '''$(Base_'+APlatform+')''!=''''', AName);
end;



procedure ReadProjectJarFiles(ADproj: string; AJarFiles: TStrings);
var
  AXml: IXMLDocument;
  ANode: IXMLNode;
  ICount: integer;
begin
  AJarFiles.Clear;
  AXml := TXMLDocument.Create(ADproj);

  for ICount := 0 to AXml.ChildNodes[0].ChildNodes.FindNode('ItemGroup').ChildNodes.Count-1 do
  begin
    ANode := AXml.ChildNodes[0].ChildNodes.FindNode('ItemGroup').ChildNodes[ICount];
    if ANode.NodeName = 'JavaReference' then
    begin
      AJarFiles.Add(ANode.Attributes['Include']);
    end;
  end;
end;


procedure CopyJavaFiles(ADProj, ADir: string);
var
  AFiles: TStrings;
  AFile: string;
begin
  AFiles := TStringList.Create;
  try
    ReadProjectJarFiles(ADProj, AFiles);
    for AFile in AFiles do
      FileCopy(AFile, IncludeTrailingPathDelimiter(ADir)+ExtractFileName(AFile));
  finally
    AFiles.Free;
  end;
end;

procedure DelphiProjectsFromProjectGroup(AProjectGroupFile: string; ADprFiles: TStrings);
var
  AXml: IXMLDocument;
  ANode: IXMLNode;
  ICount: integer;
  ADir: string;

begin
  ADir := IncludeTrailingPathDelimiter(ExtractFilePath(AProjectGroupFile));
  AXml := TXMLDocument.Create(AProjectGroupFile);

  for ICount := 0 to AXml.ChildNodes[0].ChildNodes.FindNode('ItemGroup').ChildNodes.Count-1 do
  begin
    ANode := AXml.ChildNodes[0].ChildNodes.FindNode('ItemGroup').ChildNodes[ICount];
    if ANode.NodeName = 'Projects' then
    begin


      ADprFiles.Add(LowerCase(ADir+ANode.Attributes['Include']));
    end;
  end;
end;


end.
