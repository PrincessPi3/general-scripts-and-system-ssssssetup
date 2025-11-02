param(
    # powershell is factually gay idkl why its such a shit
    [Parameter(Mandatory=$True, Position=0)]
    [string]$Filename
)
# clean up any older pallasz
rm palette.png
# first pass
ffmpeg -y -i "$Filename" -vf "palettegen=stats_mode=full" palette.png
# second pass
ffmpeg -i "$Filename" -i palette.png -lavfi "paletteuse=dither=none" -f gif -loop 0 "$Filename.gif"