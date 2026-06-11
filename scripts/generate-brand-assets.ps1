Add-Type -AssemblyName System.Drawing

$Root = (Get-Location).Path
$AssetRoots = @(
  (Join-Path $Root "public\assets"),
  (Join-Path $Root "assets")
)

$Colors = @{
  Navy = "#16324F"
  Sage = "#7C9A7D"
  Gold = "#D4AF37"
  Cream = "#FAF9F6"
  Teal = "#159AA5"
  Orange = "#F59E0B"
  Ink = "#132326"
  Muted = "#5F7376"
}

function Convert-HexColor($Hex) {
  return [System.Drawing.ColorTranslator]::FromHtml($Hex)
}

function New-BrandBrush($Hex) {
  return [System.Drawing.SolidBrush]::new((Convert-HexColor $Hex))
}

function Draw-CenteredText($Graphics, $Text, $Font, $Brush, $Rect) {
  $Format = [System.Drawing.StringFormat]::new()
  $Format.Alignment = [System.Drawing.StringAlignment]::Center
  $Format.LineAlignment = [System.Drawing.StringAlignment]::Center
  $Graphics.DrawString($Text, $Font, $Brush, $Rect, $Format)
  $Format.Dispose()
}

function Save-Image($Bitmap, $Path, $Format) {
  $Directory = Split-Path -Parent $Path
  New-Item -ItemType Directory -Force -Path $Directory | Out-Null
  if (Test-Path -LiteralPath $Path) {
    return
  }
  $TempPath = "$Path.tmp"
  $Bitmap.Save($TempPath, $Format)
  Move-Item -LiteralPath $TempPath -Destination $Path -Force
}

function Copy-LogoFiles($AssetRoot) {
  $LogoDir = Join-Path $AssetRoot "logo"
  New-Item -ItemType Directory -Force -Path $LogoDir | Out-Null

  foreach ($Name in @("logo-primary.png", "logo-horizontal.png", "logo-dark-bg.png", "logo-circle.png", "logo-icon.png")) {
    $Source = Join-Path $Root "assets\logo\$Name"
    $Target = Join-Path $LogoDir $Name
    if ((Test-Path -LiteralPath $Source) -and ($Source -ne $Target) -and (-not (Test-Path -LiteralPath $Target))) {
      Copy-Item -LiteralPath $Source -Destination $Target -Force
    }
  }
}

function Crop-LogoWhitespace($Path) {
  $SourceBitmap = [System.Drawing.Bitmap]::FromFile($Path)
  $MinX = $SourceBitmap.Width
  $MinY = $SourceBitmap.Height
  $MaxX = 0
  $MaxY = 0

  for ($y = 0; $y -lt $SourceBitmap.Height; $y += 2) {
    for ($x = 0; $x -lt $SourceBitmap.Width; $x += 2) {
      $Pixel = $SourceBitmap.GetPixel($x, $y)
      $IsWhite = ($Pixel.R -gt 245 -and $Pixel.G -gt 245 -and $Pixel.B -gt 245)
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
    $SourceBitmap.Dispose()
    return
  }

  $Pad = 36
  $MinX = [Math]::Max(0, $MinX - $Pad)
  $MinY = [Math]::Max(0, $MinY - $Pad)
  $MaxX = [Math]::Min($SourceBitmap.Width - 1, $MaxX + $Pad)
  $MaxY = [Math]::Min($SourceBitmap.Height - 1, $MaxY + $Pad)
  $CropRect = [System.Drawing.Rectangle]::new($MinX, $MinY, $MaxX - $MinX + 1, $MaxY - $MinY + 1)
  $Cropped = [System.Drawing.Bitmap]::new($CropRect.Width, $CropRect.Height)
  $CropGraphics = [System.Drawing.Graphics]::FromImage($Cropped)
  $CropGraphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $CropGraphics.DrawImage($SourceBitmap, [System.Drawing.Rectangle]::new(0, 0, $CropRect.Width, $CropRect.Height), $CropRect, [System.Drawing.GraphicsUnit]::Pixel)
  $CropGraphics.Dispose()
  $SourceBitmap.Dispose()

  $TempPath = "$Path.tmp.png"
  $Cropped.Save($TempPath, [System.Drawing.Imaging.ImageFormat]::Png)
  $Cropped.Dispose()
  if (Test-Path -LiteralPath $Path) {
    Remove-Item -LiteralPath $Path -Force
  }
  Move-Item -LiteralPath $TempPath -Destination $Path -Force
}

function New-PhotoPlaceholder($Path, $Title, $Subtitle, $BackgroundHex, $AccentHex) {
  $Width = 1600
  $Height = 1067
  $Bitmap = [System.Drawing.Bitmap]::new($Width, $Height)
  $Graphics = [System.Drawing.Graphics]::FromImage($Bitmap)
  $Graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $Graphics.Clear((Convert-HexColor $BackgroundHex))

  $White = New-BrandBrush "#FFFFFF"
  $Navy = New-BrandBrush $Colors.Navy
  $Sage = New-BrandBrush $Colors.Sage
  $Gold = New-BrandBrush $Colors.Gold
  $Muted = New-BrandBrush $Colors.Muted
  $Accent = New-BrandBrush $AccentHex

  $Graphics.FillRectangle($White, 120, 105, 1360, 760)
  $Graphics.FillEllipse($Gold, 1140, 175, 210, 210)

  $Hill = [System.Drawing.Drawing2D.GraphicsPath]::new()
  $Hill.AddBezier(180, 660, 420, 490, 660, 790, 910, 610)
  $Hill.AddBezier(910, 610, 1080, 500, 1310, 620, 1450, 685)
  $Hill.AddLine(1450, 865, 180, 865)
  $Hill.CloseFigure()
  $Graphics.FillPath($Accent, $Hill)

  $WavePen = [System.Drawing.Pen]::new((Convert-HexColor $Colors.Navy), 16)
  $WavePen.Color = [System.Drawing.Color]::FromArgb(65, $WavePen.Color)
  $Graphics.DrawBezier($WavePen, 170, 735, 430, 590, 630, 760, 860, 665)
  $Graphics.DrawBezier($WavePen, 860, 665, 1030, 590, 1230, 650, 1450, 750)

  $TitleFont = [System.Drawing.Font]::new("Georgia", 52, [System.Drawing.FontStyle]::Bold)
  $SubFont = [System.Drawing.Font]::new("Arial", 28, [System.Drawing.FontStyle]::Bold)
  $SmallFont = [System.Drawing.Font]::new("Arial", 27, [System.Drawing.FontStyle]::Regular)
  $Graphics.DrawString($Title, $TitleFont, $Navy, 145, 170)
  $Graphics.DrawString($Subtitle.ToUpperInvariant(), $SubFont, $Sage, 150, 285)
  $Graphics.DrawString("Placeholder image - replace with real photography", $SmallFont, $Muted, 145, 935)

  foreach ($Item in @($White, $Navy, $Sage, $Gold, $Muted, $Accent, $WavePen, $TitleFont, $SubFont, $SmallFont, $Hill, $Graphics)) {
    $Item.Dispose()
  }

  Save-Image $Bitmap $Path ([System.Drawing.Imaging.ImageFormat]::Jpeg)
  $Bitmap.Dispose()
}

function New-BrandBoard($Path) {
  $Width = 1400
  $Height = 1000
  $Bitmap = [System.Drawing.Bitmap]::new($Width, $Height)
  $Graphics = [System.Drawing.Graphics]::FromImage($Bitmap)
  $Graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $Graphics.Clear((Convert-HexColor $Colors.Cream))

  $White = New-BrandBrush "#FFFFFF"
  $Navy = New-BrandBrush $Colors.Navy
  $Sage = New-BrandBrush $Colors.Sage
  $Gold = New-BrandBrush $Colors.Gold
  $Muted = New-BrandBrush $Colors.Muted

  $Graphics.FillRectangle($White, 70, 70, 1260, 860)
  $Graphics.FillEllipse($Gold, 1100, 160, 215, 215)

  $TitleFont = [System.Drawing.Font]::new("Georgia", 70, [System.Drawing.FontStyle]::Bold)
  $CapsFont = [System.Drawing.Font]::new("Arial", 28, [System.Drawing.FontStyle]::Bold)
  $ItalicFont = [System.Drawing.Font]::new("Georgia", 38, [System.Drawing.FontStyle]::Italic)
  $LabelFont = [System.Drawing.Font]::new("Arial", 27, [System.Drawing.FontStyle]::Bold)
  $BodyFont = [System.Drawing.Font]::new("Arial", 25, [System.Drawing.FontStyle]::Regular)
  $SwatchFont = [System.Drawing.Font]::new("Arial", 22, [System.Drawing.FontStyle]::Bold)

  $Graphics.DrawString("Life Worth Living", $TitleFont, $Navy, 110, 120)
  $Graphics.DrawString("ADULT FAMILY HOME", $CapsFont, $Sage, 113, 205)
  $Graphics.DrawString("Where Every Day Is Worth Living.", $ItalicFont, $Gold, 113, 265)
  $Graphics.DrawString("Brand Direction", $LabelFont, $Navy, 110, 390)
  $Graphics.DrawString("Modern premium healthcare / senior care", $BodyFont, $Muted, 110, 445)
  $Graphics.DrawString("Typography", $LabelFont, $Navy, 110, 525)
  $Graphics.DrawString("Playfair Display-inspired headings", [System.Drawing.Font]::new("Georgia", 40), $Navy, 110, 575)
  $Graphics.DrawString("Inter-inspired body and UI copy", [System.Drawing.Font]::new("Arial", 30), $Muted, 110, 635)

  $Palette = @(
    @("Navy", $Colors.Navy),
    @("Sage", $Colors.Sage),
    @("Gold", $Colors.Gold),
    @("Cream", $Colors.Cream),
    @("Teal", $Colors.Teal),
    @("Orange", $Colors.Orange)
  )
  for ($i = 0; $i -lt $Palette.Count; $i++) {
    $x = 95 + ($i * 178)
    $Brush = New-BrandBrush $Palette[$i][1]
    $Graphics.FillRectangle($Brush, $x, 735, 128, 128)
    $Graphics.DrawString($Palette[$i][0], $SwatchFont, $Navy, $x, 882)
    $Graphics.DrawString($Palette[$i][1], [System.Drawing.Font]::new("Arial", 20), $Muted, $x, 914)
    $Brush.Dispose()
  }

  foreach ($Item in @($White, $Navy, $Sage, $Gold, $Muted, $TitleFont, $CapsFont, $ItalicFont, $LabelFont, $BodyFont, $SwatchFont, $Graphics)) {
    $Item.Dispose()
  }

  Save-Image $Bitmap $Path ([System.Drawing.Imaging.ImageFormat]::Png)
  $Bitmap.Dispose()
}

foreach ($AssetRoot in $AssetRoots) {
  New-Item -ItemType Directory -Force -Path (Join-Path $AssetRoot "brand"), (Join-Path $AssetRoot "images") | Out-Null
  Copy-LogoFiles $AssetRoot
  New-BrandBoard (Join-Path $AssetRoot "brand\brand-board.png")

  New-PhotoPlaceholder (Join-Path $AssetRoot "images\hero-home.jpg") "RN-Led Adult Family Home" "Warm senior care setting" $Colors.Cream $Colors.Teal
  New-PhotoPlaceholder (Join-Path $AssetRoot "images\exterior.jpg") "Home Exterior" "Residential Burien adult family home" "#EEF5F0" $Colors.Sage
  New-PhotoPlaceholder (Join-Path $AssetRoot "images\living-room.jpg") "Living Room" "Comfortable shared gathering space" "#F6FAFA" $Colors.Teal
  New-PhotoPlaceholder (Join-Path $AssetRoot "images\bedroom.jpg") "Bedroom" "Peaceful private resident room" $Colors.Cream $Colors.Sage
  New-PhotoPlaceholder (Join-Path $AssetRoot "images\dining-area.jpg") "Dining Area" "Nutritious home-cooked meals" "#FFF7E8" $Colors.Orange
  New-PhotoPlaceholder (Join-Path $AssetRoot "images\outdoor-space.jpg") "Outdoor Space" "Safe fresh-air area and garden" "#EEF7EF" $Colors.Sage
}

Write-Host "Generated real PNG/JPG brand assets under public/assets and mirrored /assets for static serving."
