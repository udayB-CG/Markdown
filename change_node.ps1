# Function to get user input for Node.js version
function Get-NodeVersion {
    $versions = @("nodejs14", "nodejs16", "nodejs18")  # Add your available versions here
    Write-Host "Available Node.js versions:"
    $versions | ForEach-Object { Write-Host "$($_)" }

    $selectedVersion = Read-Host "Please enter the Node.js version (e.g., nodejs14)"
    
    if ($versions -contains $selectedVersion) {
        return $selectedVersion
    } else {
        Write-Host "Invalid version selected. Please choose a valid version from the list."
        exit
    }
}

# Function to copy the chosen version to Program Files
function Update-NodeJs {
    $selectedVersion = Get-NodeVersion
    $sourceFolder = "C:\Users\UBANIK\source\nodeSource\$selectedVersion\*" # "C:\path\to\nodejs\$selectedVersion"  # Replace with the actual path to your Node.js version folders
    $targetFolder = "C:\Users\UBANIK\source\new\nodejs" 

    # Check if the source folder exists
    if (Test-Path $sourceFolder) {
        # Ensure that the target folder exists
        if (Test-Path $targetFolder) {
            Write-Host "Stopping any running Node.js processes..."

            # Stop Node.js processes if running (Optional, but useful)
            Get-Process -Name "node" -ErrorAction SilentlyContinue | Stop-Process

            Write-Host "Backing up current Node.js installation..."

            # Backup existing nodejs folder
            $backupFolder = "C:\Users\UBANIK\source\ProgramSink\nodejs-backup-" + (Get-Date -Format "yyyyMMddHHmmss")
            Copy-Item -Path $targetFolder -Destination $backupFolder -Recurse -Force
            Write-Host "Backup completed at $backupFolder"

            # Remove the current Node.js folder
            Write-Host "Removing existing Node.js installation..."
            Remove-Item -Path $targetFolder -Recurse -Force

            # Copy the selected Node.js version into Program Files
            Write-Host "Copying $selectedVersion to Program Files..."
            Copy-Item -Path "$sourceFolder\*" -Destination $targetFolder -Recurse -Force

            Write-Host "Node.js version $selectedVersion has been installed successfully."
        } else {
            Write-Host "Target folder C:\Program Files\nodejs does not exist."
            exit
        }
    } else {
        Write-Host "The selected Node.js version folder does not exist: $sourceFolder"
        exit
    }
}

# Start the update process
Update-NodeJs
