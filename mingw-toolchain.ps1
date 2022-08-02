pwsh -NoExit -Command {
    [System.Collections.ArrayList]$array = $Env:Path -split ";";
    $array[$array.IndexOf("C:\msys64\ucrt64\bin")] = "C:\msys64\mingw64\bin"
    $Env:Path = $array -join ";";
    $array = $null;
}
