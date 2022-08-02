pwsh -NoExit -Command {
    [System.Collections.ArrayList] $array = $Env:Path -split ";";
    [System.Collections.ArrayList] $patterns = $Env:MSYS2 -split ";";
    foreach ($pattern in $patterns) {$array.Remove($pattern)}
    $Env:Path =  $array -join ";";
    $array = $null;
    $patterns = $null;
    Import-Module "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll";
    Enter-VsDevShell cc2d9686 -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64";
}
