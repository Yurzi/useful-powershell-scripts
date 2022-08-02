Param (
        [Parameter(
            Position=0,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
            )]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Mingw", "MSVC")]
        [String]$Toolchain = "Mingw"
        )
Begin {
# Clear this session's toolchain infomation
[System.Collections.ArrayList] $path = $Env:Path -split ";";
[System.Collections.ArrayList] $patterns = $Env:MSYS2 -split ";";
[System.Collections.ArrayList] $after_path = $path.Clone();
foreach ($pattern in $patterns) {
    $after_path.Remove($pattern);
}

$Env:Path = $after_path -join ";";
$after_path = $null; # clear the var
$patterns = $null;
}
Process {
    switch ($Toolchain) {
        "Mingw" {
            pwsh -NoExit -NoLogo -Command {
                $Env:Path = "C:\Packages\Qt\current\mingw_64\bin;C:\Packages\Qt\Tools\mingw1120_64\bin;" + $Env:Path;
            }
        }
        "MSVC" {
            pwsh -NoExit -NoLogo -Command {
                $Env:Path = "C:\Packages\Qt\current\msvc2019_64\bin;" + $Env:Path;
                Import-Module "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll";
                Enter-VsDevShell cc2d9686 -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64";
            }
        }
    }
}

End {
    $Env:Path = $path -join ";";
}
