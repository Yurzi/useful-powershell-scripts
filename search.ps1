param(
        [Parameter(
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
            )]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("google", "baidu", "bing", "yandex")]
        [String]$Engine="google",

        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
            )]
        [ValidateNotNullOrEmpty()]
        [String[]]$problem,

        [Parameter(
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("edge", "firefox")]
        [String]$Browser = "edge"
        )
Begin {
## 支持的搜索引擎列表(位置)
[System.Collections.Hashtable] $engines_list = @{
    google  = 'https://www.google.com/search?q=';
    baidu   = 'https://www.baidu.com/s?wd=';
    bing    = 'https://cn.bing.com/search?q=';
    yandex  = 'https://yandex.com/search/?text=';
}
## 支持的浏览器列表(位置)
[System.Collections.Hashtable] $browesers_list = @{
    edge    = 'edge';
    firefox = 'firefox';
}


## 生成的命令
# 将空格去除
$problem = $problem -join '%20';
$problem = $problem.ToCharArray();
$string_builder = New-Object -TypeName "System.Text.StringBuilder";

foreach($char in $problem) {
    if ($char -eq ' ') {
        [void]$string_builder.Append('+');
    }elseif ($char -eq "'") {
        [void]$string_builder.Append('%27');
    }else {
        [void]$string_builder.Append($char);
    }
}

$problem = $string_builder.ToString();

$cmd = $browesers_list[$Browser] + ' ' + $engines_list[$Engine] + $problem;

}

Process {
    Invoke-Expression $cmd;
}

End {

}
