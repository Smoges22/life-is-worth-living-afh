Add-Type -AssemblyName System.Drawing

$Root = (Get-Location).Path
$LogoTargets = @{
  "logo-horizontal.png" = 720
  "logo-primary.png" = 820
  "logo-dark-bg.png" = 820
  "logo-circle.png" = 512
  "logo-icon.png" = 512
}

function Open-ImageUnlocked($Path) {
  $Bytes = [System.IO.File]::ReadAllBytes($Path)
  $Stream = [System.IO.MemoryStream]::new($Bytes)
  $Image = [System.Drawing.Image]::FromStream($Stream)
  $Bitmap = [System.Drawing.Bitmap]::new($Image)
  $Image.Dispose()
  $Stream.Dispose()
  return $Bitmap
}

function Get-ContentBounds($Bitmap) {
  $MinX = $Bitmap.Width
  $MinY = $Bitmap.Height
  $MaxX = 0
  $MaxY = 0

  for ($y = 0; $y -lt $Bitmap.Height; $y += 2) {
    for ($x = 0; $x -lt $Bitmap.Width; $x += 2) {
      $Pixel = $Bitmap.GetPixel($x, $y)
      $IsWhite = ($Pixel.R -gt 246 -and $Pixel.G -gt 246 -and $Pixel.B -gt 246)
      $IsTransparent = ($Pixel.A -lt 10)
      if (-not $IsWhite -and -not $IsTransparent) {
        if ($x -lt $MinX) { $MinX = $x }
        if ($y -lt $MinY) { $MinY = $y }
        if ($x -gt $MaxX) { $MaxX = $x }
        if ($y -gt $MaxY) { $MaxY = $y }
      }
    }
  }

  if ($MaxX -le $MinX -or $MaxY -le $MinY) {
    return [System.Drawing.Rectangle]::new(0, 0, $Bitmap.Width, $Bitmap.Height)
  }

  $Pad = 24
  $MinX = [Math]::Max(0, $MinX - $Pad)
  $MinY = [Math]::Max(0, $MinY - $Pad)
  $MaxX = [Math]::Min($Bitmap.Width - 1, $MaxX + $Pad)
  $MaxY = [Math]::Min($Bitmap.Height - 1, $MaxY + $Pad)
  return [System.Drawing.Rectangle]::new($MinX, $MinY, $MaxX - $MinX + 1, $MaxY - $MinY + 1)
}

function Save-PngAtomic($Bitmap, $Path) {
  $Output = "$Path.optimized.png"
  if (Test-Path -LiteralPath $Output) {
    Remove-Item -Force -LiteralPath $Output
  }
  $Bitmap.Save($Output, [System.Drawing.Imaging.ImageFormat]::Png)
}

function Optimize-Logo($Path, $MaxDimension) {
  $Source = Open-ImageUnlocked $Path
  $Bounds = Get-ContentBounds $Source
  $Scale = [Math]::Min($MaxDimension / $Bounds.Width, $MaxDimension / $Bounds.Height)
  if ($Scale -gt 1) { $Scale = 1 }
  $Width = [Math]::Max(1, [int][Math]::Round($Bounds.Width * $Scale))
  $Height = [Math]::Max(1, [int][Math]::Round($Bounds.Height * $Scale))
  $Output = [System.Drawing.Bitmap]::new($Width, $Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $Graphics = [System.Drawing.Graphics]::FromImage($Output)
  $Graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $Graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $Graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $Graphics.Clear([System.Drawing.Color]::Transparent)
  $Graphics.DrawImage($Source, [System.Drawing.Rectangle]::new(0, 0, $Width, $Height), $Bounds, [System.Drawing.GraphicsUnit]::Pixel)
  $Graphics.Dispose()
  $Source.Dispose()
  Save-PngAtomic $Output $Path
  $Output.Dispose()
}

foreach ($AssetRoot in @("assets", "public\assets")) {
  foreach ($Entry in $LogoTargets.GetEnumerator()) {
    $Path = Join-Path $Root "$AssetRoot\logo\$($Entry.Key)"
    if (Test-Path -LiteralPath $Path) {
      Optimize-Logo $Path $Entry.Value
    }
  }
}

Write-Host "Created optimized logo files with .optimized.png suffix."
