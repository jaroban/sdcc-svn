# TODO: check for updates at
# https://www.boost.org
$version = '1_76_0'

$version_with_dots = $version.replace('_', '.')
# Source file location
$source_url = "https://boostorg.jfrog.io/artifactory/main/release/$version_with_dots/source/boost_$version.7z"
# Destination to save the file
$boost_zipped = "../boost/boost_$version.7z"

if(!(test-path "../boost"))
{
    New-Item -ItemType Directory -Force -Path "../boost"
}

if (-not(Test-Path -Path "../boost/boost_$version/boost" -PathType Container)) {
    if (-not(Test-Path -Path $boost_zipped -PathType Leaf)) {
        # Download the file
        "downloading $source_url"
        Invoke-WebRequest -Uri $source_url -OutFile $boost_zipped
    }
    else {
        "$boost_zipped already exists"
    }
    
    # Extract boost
    & "C:/Program Files/7-Zip/7z.exe" x $boost_zipped "-o../boost"
}
else {
    "$boost_zipped is already extracted"
}
