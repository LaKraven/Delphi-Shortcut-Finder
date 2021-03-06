unit nick.shortcut.element.DLLExpertBase;

interface

uses
  nick.shortcut.core.ShortCutList,
  {$IFDEF VER220}
  Windows;
  {$ELSE}
  WinApi.Windows;
  {$ENDIF}

type
  TDLLExpertBaseElement = class abstract(TShortCutList)
  private
  protected
    function CheckForExpertDLL(const AExpertName : string) : Boolean;
    function IsVersionAllowed(const AVSFixedFileInfo : TVSFixedFileInfo) : Boolean; virtual;
  public
  end;

implementation

uses
  nick.shortcut.repository.IRegistry;

function TDLLExpertBaseElement.IsVersionAllowed(const AVSFixedFileInfo: TVSFixedFileInfo): Boolean;
begin
  Result := True;
end;

function TDLLExpertBaseElement.CheckForExpertDLL(const AExpertName: string): Boolean;
var
  LRegistryRepository : IRegistryRepository;
  LBaseRegistryKey: string;
  LFilePath: string;
  LVSFixedFileInfo: TVSFixedFileInfo;
begin
  Result := False;
  if not  RepositoryFactory().ToolsApiRepository().GetBaseRegistryKey(LBaseRegistryKey) then
    Exit;

  LRegistryRepository := RepositoryFactory().RegistryRepository();

  if not LRegistryRepository.OpenKeyReadOnly(LBaseRegistryKey + '\Experts\') then
    Exit;

  try
    LFilePath := LRegistryRepository.ReadString(AExpertName);

    if not RepositoryFactory().SystemRepository().FileExists(LFilePath) then
      Exit;

    if not RepositoryFactory().SystemRepository().GetVersionInformation(LFilePath, LVSFixedFileInfo) then
      Exit;

    Result := IsVersionAllowed(LVSFixedFileInfo);
  finally
    LRegistryRepository.CloseKey;
  end;
end;

end.
