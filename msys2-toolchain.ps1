pwsh -NoExit -Command {
    [System.Collections.ArrayList]$array = $Env:Path -split ";";
    $array.RemoveAt($array.IndexOf("C:\msys64\ucrt64\bin"));
    $Env:Path = $array -join ";";
    $array = $null;
}
