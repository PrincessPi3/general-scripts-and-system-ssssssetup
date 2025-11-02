param(
    # powershell is factually gay idkl why its such a shit
    [Parameter(Mandatory=$True, Position=0)]
    [string]$Filename
)
# apng is far hjigher quality and also preserves transparancy :activated:
ffmpeg -i "$Filename" -plays 0 -f apng -lavfi split[v],palettegen,[v]paletteuse "$Filename.apng"