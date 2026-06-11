Add-Type -AssemblyName System.Drawing

$Root = (Get-Location).Path
$ImageRoot = Join-Path $Root "assets\images"
$PublicImageRoot = Join-Path $Root "public\assets\images"
$Widths = @(480, 960, 1440)
$JpegQuality = 82L

$Assignments = @(
  @{ Source = "driveway.jpeg"; Output = "hero-home.jpg" },
  @{ Source = "ramp-entrance.jpeg"; Output = "exterior.jpg" },
  @{ Source = "living-room.jpeg"; Output = "living-room.jpg" },
  @{ Source = "hallway-1.jpeg"; Output = "hallway-1.jpg" },
  @{ Source = "hallway-2.jpeg"; Output = "hallway-2.jpg" },
  @{ Source = "hallway-3.jpeg"; Output = "hallway-3.jpg" },
  @{ Source = "accessible-=bathroom.jpeg"; Output = "accessible-bathroom.jpg" },
  @{ Source = "bedroom.jpeg"; Output = "bedroom.jpg" },
  @{ Source = "deck-patio.jpeg"; Output = "deck-patio.jpg" }
)

function Get-JpegCodec {
  return [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
    Where-Object { $_.MimeType -eq "image/jpeg" } |
    Select-Object -First 1
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

function Save-Jpeg($Bitmap, $Path, $Codec, $Quality) {
  $TempPath = "$Path.tmp"
  if (Test-Path -LiteralPath $TempPath) {
    Remove-Item -Force -LiteralPath $TempPath
  }
  $EncoderParams = [System.Drawing.Imaging.EncoderParameters]::new(1)
  $EncoderParams.Param[0] = [System.Drawing.Imaging.EncoderParameter]::new(
    [System.Drawing.Imaging.Encoder]::Quality,
    $Quality
  )
  $Bitmap.Save($TempPath, $Codec, $EncoderParams)
  $EncoderParams.Dispose()
  if (Test-Path -LiteralPath $Path) {
    Remove-Item -Force -LiteralPath $Path
  }
  Move-Item -LiteralPath $TempPath -Destination $Path -Force
}

function Resize-Jpeg($SourcePath, $OutputPath, $MaxWidth, $Codec, $Quality) {
  $Source = Open-ImageUnlocked $SourcePath
  $Scale = [Math]::Min(1.0, [double]$MaxWidth / [double]$Source.Width)
  $Width = [Math]::Max(1, [int][Math]::Round($Source.Width * $Scale))
  $Height = [Math]::Max(1, [int][Math]::Round($Source.Height * $Scale))
  $Output = [System.Drawing.Bitmap]::new($Width, $Height, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
  $Graphics = [System.Drawing.Graphics]::FromImage($Output)
  $Graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
  $Graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $Graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $Graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $Graphics.DrawImage($Source, 0, 0, $Width, $Height)
  $Graphics.Dispose()
  Save-Jpeg $Output $OutputPath $Codec $Quality
  $Output.Dispose()
  $Source.Dispose()
}

function Copy-ToPublic($SourcePath, $DestinationRoot) {
  if (-not (Test-Path -LiteralPath $DestinationRoot)) {
    New-Item -ItemType Directory -Force -Path $DestinationRoot | Out-Null
  }
  $DestinationPath = Join-Path $DestinationRoot (Split-Path $SourcePath -Leaf)
  if (Test-Path -LiteralPath $DestinationPath) {
    Remove-Item -Force -LiteralPath $DestinationPath
  }
  Copy-Item -LiteralPath $SourcePath -Destination $DestinationPath -Force
}

$Codec = Get-JpegCodec
$Report = @()

foreach ($Assignment in $Assignments) {
  $SourcePath = Join-Path $ImageRoot $Assignment.Source
  $OutputPath = Join-Path $ImageRoot $Assignment.Output
  $BaseName = [System.IO.Path]::GetFileNameWithoutExtension($Assignment.Output)

  if (-not (Test-Path -LiteralPath $SourcePath)) {
    throw "Missing source image: $SourcePath"
  }

  $OriginalBytes = (Get-Item -LiteralPath $SourcePath).Length
  $SourceImage = Open-ImageUnlocked $SourcePath
  $OriginalDimensions = "$($SourceImage.Width)x$($SourceImage.Height)"
  $SourceImage.Dispose()

  Resize-Jpeg $SourcePath $OutputPath 1600 $Codec $JpegQuality
  Copy-ToPublic $OutputPath $PublicImageRoot

  $ResponsiveFiles = @()
  foreach ($Width in $Widths) {
    $ResponsivePath = Join-Path $ImageRoot "$BaseName-$Width.jpg"
    Resize-Jpeg $SourcePath $ResponsivePath $Width $Codec $JpegQuality
    Copy-ToPublic $ResponsivePath $PublicImageRoot
    $ResponsiveFiles += "$BaseName-$Width.jpg"
  }

  $OptimizedBytes = (Get-Item -LiteralPath $OutputPath).Length
  $Report += [pscustomobject]@{
    Source = $Assignment.Source
    Output = $Assignment.Output
    OriginalDimensions = $OriginalDimensions
    OriginalKB = [Math]::Round($OriginalBytes / 1KB, 1)
    OptimizedKB = [Math]::Round($OptimizedBytes / 1KB, 1)
    ResponsiveFiles = ($ResponsiveFiles -join ", ")
  }
}

$Report | Format-Table -AutoSize
