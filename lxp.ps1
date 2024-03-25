# Define the base directory and the executable name
$BASE_DIR = Split-Path -Parent $MyInvocation.MyCommand.Definition
$EXE_ = "loclx.exe"

# Function to download and extract files
function Get-Files {
    $zipFile = Join-Path -Path $BASE_DIR -ChildPath "loclx.zip"
    $url = "https://loclx-client.s3.amazonaws.com/loclx-windows-amd64.zip"
    Invoke-WebRequest -Uri $url -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath $BASE_DIR -Force
}

# Function to expose
function Expose {
    $configFile = Join-Path -Path $BASE_DIR -ChildPath "config.yml"
    & (Join-Path -Path $BASE_DIR -ChildPath $EXE_) tunnel config -f $configFile
}

# Check if the executable exists, if not, download files
if (-not (Test-Path (Join-Path -Path $BASE_DIR -ChildPath $EXE_))) {
    Get-Files
}

# Expose
Expose
