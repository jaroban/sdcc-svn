# TODO: check for updates at
# https://github.com/lexxmark/winflexbison
$version = '2.5.24'

# Source file location
$source_url = "https://github.com/lexxmark/winflexbison/releases/download/v$version/win_flex_bison-$version.zip"
# Destination to save the file
$zipped = "../utils/win_flex_bison-$version.zip"

if(!(test-path "../utils"))
{
    New-Item -ItemType Directory -Force -Path "../utils"
}

if (-not(Test-Path -Path "../utils/bison.exe" -PathType Leaf)) {
    if (-not(Test-Path -Path "../utils/win_bison.exe" -PathType Leaf)) {
        if (-not(Test-Path -Path $zipped -PathType Leaf)) {
            # Download the file
            "downloading $source_url"
            Invoke-WebRequest -Uri $source_url -OutFile $zipped
        }
        else {
            "$zipped already exists"
        }

        # Extract
        & "C:/Program Files/7-Zip/7z.exe" x $zipped "-o../utils"
    }
    else {
        "$zipped is already extracted"
    }

    # Rename
    Copy-Item ../utils/win_bison.exe ../utils/bison.exe
    Copy-Item ../utils/win_flex.exe ../utils/flex.exe
}
else {
    "files are already renamed"
}
