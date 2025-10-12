#!/bin/bash
# ------------------------------------------------------------------
# Bash Script to Create Medical Records Folder Structure (Mac/Linux)
# ------------------------------------------------------------------

# --- Configuration ---
# Set the name of the main directory where the records will be stored.
MAIN_FOLDER="Medical_Records_Archive"

# Define the children's main folders
CHILDREN=(
    "REHAN_DOB_2012-08-01"
    "RUSHDA_DOB_2015-12-25"
)

# Define the standard sub-folders for each child
SUB_FOLDERS=(
    "01_Immunizations"
    "02_General_Peds_Visits"
    "03_Specialist_Reports"
    "04_Lab_&_Test_Results"
    "05_Medication_&_Allergies"
    "06_Hospital_&_ER_Summaries"
)
# ------------------------------------------------------------------

echo "Starting folder creation for medical records..."

# Create the main root folder, including parent directories if needed (-p)
mkdir -p "$MAIN_FOLDER"
echo "Creating main directory: $MAIN_FOLDER"

# Change the current location to the new main folder
cd "$MAIN_FOLDER" || exit # Exit if cd fails

# Loop through each child to create their folder and sub-folders
for CHILD in "${CHILDREN[@]}"; do
    echo "  -> Creating records folder for $CHILD"
    
    # Create the child's main folder
    mkdir -p "$CHILD"
    
    # Create the standard sub-folders inside the child's folder
    for SUB in "${SUB_FOLDERS[@]}"; do
        # Use -p to ensure parent folder exists and suppress errors if sub-folder exists
        mkdir -p "$CHILD/$SUB"
        echo "     - Created: $SUB"
    done
done

echo ""
echo "Folder structure created successfully in: $(pwd)"
echo "------------------------------------------------------------------"
