# TODO: check for updates at
# https://zlib.net
# if the version changes, also update the include path in .vcxproj and .props files
$version = '1.2.11'
$version_without_dots = '1211'

# Source file location
$source_url = "https://zlib.net/zlib$version_without_dots.zip"
# Destination to save the file
$zlib_folder = "../../../zlib"
$zlib_zipped = "$zlib_folder/zlib$version_without_dots.zip"

if(!(test-path $zlib_folder))
{
    New-Item -ItemType Directory -Force -Path $zlib_folder
}

if (-not(Test-Path -Path "$zlib_folder/zlib-$version/README" -PathType Leaf)) {
    if (-not(Test-Path -Path $zlib_zipped -PathType Leaf)) {
        # Download the file
        "downloading $source_url"
        Invoke-WebRequest -Uri $source_url -OutFile $zlib_zipped
    }
    else {
        "$zlib_zipped already exists"
    }
    
    # Extract zlib
    & "C:/Program Files/7-Zip/7z.exe" x $zlib_zipped "-o$zlib_folder"

    "An additional step is required: right click on zlibstat, select 'Retarget projects', retarget to newest version"
}
else {
    "$zlib_zipped is already extracted"
}
