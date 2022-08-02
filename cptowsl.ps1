## 将剪贴板的图片写入WSL中的对应文件夹

Add-Type -Assembly PresentationCore
$img=[Windows.Clipboard]::GetImage();
if ($img -eq $null) {
    Write-Host "Clipboard contains no image."
    Exit
}

$fcb = New-Object Windows.Media.Imaging.FormatConvertedBitmap($img, [Windows.Media.PixelFormats]::Rgb24, $null, 0)
$file ="\\wsl.localhost/Arch/home/yurzi/FromWin/clipboard-{0}.png" -f ((Get-Date -f s) -replace '[-T:]','')
Write-Host ("`n Found Pic {0}x{1} pixel. Saving to {2} `n" -f $img.PixelWidth, $img.PixelHeight, $file)

$stream = [IO.File]::Open($file, "OpenOrCreate")
$encoder = New-Object Windows.Media.Imaging.PngBitmapEncoder
$encoder.Frames.Add([Windows.Media.Imaging.BitmapFrame]::Create($fcb))
$encoder.Save($stream)
$stream.Dispose()
