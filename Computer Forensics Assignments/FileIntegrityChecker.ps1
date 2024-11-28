# Combined File Integrity Checker Script
# Includes Hash Comparison and File Signature Check

# Define the file to check
# $filePath = "C:\Users\User\Desktop\SampleFile.txt"
# $filePath = "C:\Users\User\Desktop\test.docx"
$filePath = "D:\test.jpg"

# Define the hash algorithm (e.g., SHA256, MD5)
$hashAlgorithm = "SHA256"

# Define known file signatures
$fileSignatures = @{
    '25504446' = 'PDF';      # PDF files
    '89504E47' = 'PNG';      # PNG images
    '47494638' = 'GIF';      # GIF images
    'FFD8FFE0' = 'JPG';      # JPEG images
    'FFD8FFE1' = 'JPG';      # JPEG images
    '504B0304' = 'ZIP';      # ZIP archives
    '4D5A'     = 'EXE';      # Executable files (Windows)
    '494433'   = 'MP3';      # MP3 audio files
    '1F8B'     = 'GZIP';     # GZIP compressed files
    '3C3F786D6C' = 'XML';    # XML files
    '52617221' = 'RAR';      # RAR compressed files
    '57415645' = 'WAV';      # WAV audio files
}


# Function to compute the hash of a file
function Compute-FileHash {
    param (
        [string]$filePath,
        [string]$algorithm
    )

    if (!(Test-Path -Path $filePath)) {
        Write-Host "Error: File not found at $filePath" -ForegroundColor Red
        return $null
    }

    $hash = Get-FileHash -Path $filePath -Algorithm $algorithm
    return $hash.Hash
}

# Function to read file signature
function Get-FileSignature {
    param (
        [string]$filePath
    )

    if (!(Test-Path -Path $filePath)) {
        Write-Host "Error: File not found at $filePath" -ForegroundColor Red
        return $null
    }

    $fileStream = New-Object IO.FileStream($filePath, 'Open', 'Read')
    $binaryReader = New-Object System.IO.BinaryReader($fileStream)
    $signatureBytes = $binaryReader.ReadBytes(4)
    $binaryReader.Close()
    $fileStream.Close()

    $signatureHex = ($signatureBytes | ForEach-Object { $_.ToString("X2") }) -join ''
    return $signatureHex
}

# Step 1: Compute Initial Hash
$initialHash = Compute-FileHash -filePath $filePath -algorithm $hashAlgorithm
if ($null -eq $initialHash) { exit }
Write-Host "Initial $hashAlgorithm hash: $initialHash"

# Step 2: File Signature Check
$fileSignature = Get-FileSignature -filePath $filePath
if ($null -eq $fileSignature) { exit }

Write-Host "File Signature: $fileSignature"
if ($fileSignatures.ContainsKey($fileSignature)) {
    Write-Host "File signature matches known type: $($fileSignatures[$fileSignature])" -ForegroundColor Green
} else {
    Write-Host "Warning: File signature does not match known types. Possible tampering or unknown file type." -ForegroundColor Red
}

# Step 3: Prompt for Operation
Write-Host "Perform the desired operation on the file, then press Enter to continue."
Read-Host

# Step 4: Compute Final Hash
$finalHash = Compute-FileHash -filePath $filePath -algorithm $hashAlgorithm
if ($null -eq $finalHash) { exit }
Write-Host "Final $hashAlgorithm hash: $finalHash"

# Step 5: Compare Hashes
if ($initialHash -eq $finalHash) {
    Write-Host "File integrity verified. No changes detected." -ForegroundColor Green
} else {
    Write-Host "Warning: File integrity compromised. Changes detected!" -ForegroundColor Red
}
