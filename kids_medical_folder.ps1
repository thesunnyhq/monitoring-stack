# ------------------------------------------------------------------
# PowerShell Script to Create Medical Records Folder Structure
# ------------------------------------------------------------------

# --- Configuration ---
# Set the name of the main directory where the records will be stored.
$MainFolderName = "Medical_Records_Archive"

# Define the children and their primary folders
$Children = @(
    "REHAN_DOB_2012-08-01",
    "RUSHDA_DOB_2015-12-25"
)

# Define the standard sub-folders for each child
$SubFolders = @(
    "01_Immunizations",
    "02_General_Peds_Visits",
    "03_Specialist_Reports",
    "04_Lab_&_Test_Results",
    "05_Medication_&_Allergies",
    "06_Hospital_&_ER_Summaries"
)
# ------------------------------------------------------------------

Write-Host "Starting folder creation for medical records..."

# Create the main root folder
Write-Host "Creating main directory: $MainFolderName"
New-Item -ItemType Directory -Path $MainFolderName -Force | Out-Null

# Change the current location to the new main folder
Set-Location -Path $MainFolderName

# Loop through each child to create their folder and sub-folders
foreach ($Child in $Children) {
    Write-Host "  -> Creating records folder for $Child"
    
    # Create the child's main folder
    New-Item -ItemType Directory -Name $Child -Force | Out-Null
    
    # Create the standard sub-folders inside the child's folder
    foreach ($SubFolder in $SubFolders) {
        $Path = Join-Path -Path $Child -ChildPath $SubFolder
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-Host "     - Created: $SubFolder" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Folder structure created successfully in: (Get-Location)\$MainFolderName"
Write-Host "------------------------------------------------------------------"
