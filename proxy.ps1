Function Set-PSProxy {
    [CmdletBinding()]
    Param (
            [Parameter(
                Position = 0,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true
                )]
            [ValidateNotNullOrEmpty()]
            [Alias("Host")]
            [String]$Proxy = "http://127.0.0.1:7890",

            [switch]$off
          )

    Process {
        if ($off) {
            Remove-Item Env:http_proxy -ErrorAction SilentlyContinue;
            Remove-Item Env:https_proxy -ErrorAction SilentlyContinue;
        }else {
            if($Env:http_proxy -or $Env:https_proxy) {
                Remove-Item Env:http_proxy -ErrorAction SilentlyContinue;
                Remove-Item Env:https_proxy -ErrorAction SilentlyContinue;
                $off = $true;
            } else{
                $Env:http_proxy=$Proxy;
                $Env:https_proxy=$Proxy;
            }
        }
    }

    End {
        if($off) {
            Write-Output "取消代理";
            if($Env:http_proxy -or $Env:https_proxy){
                Write-Host "代理未成功取消";
            }
        }else {

            Write-Output "设置代理为:";
            if($Env:http_proxy){Write-Output "Http: ${Env:http_proxy}";}
            if($Env:http_proxy){Write-Output "Https: ${Env:https_proxy}";}
        }
    }
}

Function Set-NetProxy {
    [CmdletBinding()]
    Param (
            [Parameter(
                Position = 0,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true
                )]
            [ValidateNotNullOrEmpty()]
            [Alias("Host")]
            [String]$Proxy = "127.0.0.1:7890",

            [Parameter(
                Position = 1,
                Mandatory = $False,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true
                )]
            [AllowEmptyString()]
            [Alias("Pac")]
            [String]$acs,

            [switch]$off
          )

    Begin {
        $regKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings";
    }

    Process {
        if($off) {
            Set-ItemProperty -Path $regKey ProxyEnable -value 0 -ErrorAction SilentlyContinue;
            Set-ItemProperty -Path $regKey ProxyServer -value "" -ErrorAction SilentlyContinue;
            Set-ItemProperty -Path $regKey AutoConfigURL -value "" -ErrorAction SilentlyContinue;
        }else {
            Set-ItemProperty -Path $regKey ProxyEnable -value 1;
            Set-ItemProperty -Path $regKey ProxyServer -value $Proxy;

            if($acs) {
                Set-ItemProperty -Path $regKey AutoConfigURL -value $acs;
            }
        }
    }

    End {
        if($off) {
            Write-Output "System proxy is now Disabled";
        }else {
            Write-Output "System porxy is now enabled.";
            Write-Output "Proxy Server: $Proxy";
        }
    }
}
