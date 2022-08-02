if ($args.Count -eq 0){
    return;
}

# 获取到对应的Com组件的shell
$shell = New-Object -COMObject "Shell.Application";
$count = 0;
for($i = 0; $i -lt $args.Count; $i++){
    $targets=$args[$i];
    # 路径解析
    try{
        $targets=Resolve-Path $targets -ErrorAction Stop;
    }catch{
        Write-Host "args[$i]: >$args[$i]< is illegal";
        continue;
    }

    # 移动到回收站

    for($j = 0; $j -lt $targets.Count; $j++){
        try{
            $item = $shell.Namespace(0).ParseName($targets[$j].Path);
            $item.InvokeVerb("delete");
        }catch {
            Write-Host "target[$($i+1)]: >$($args[$i])< not exist";
            continue;
        }
    $count++;
    }
}

if ($count -gt 0) {
    Write-Host "$count Files had benn Remove into RecycleBin" -NoNewLine;
}elseif (($count -eq 0) -and ($args.Count -ne 0)){
    Write-Host "Stupid Neko!" -NoNewLine;
}
