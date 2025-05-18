# PowerShell script to fix the social media icons centering in all HTML files

Write-Host "Starting social media icon centering fix..."

# Get all HTML files in the current directory
$htmlFiles = Get-ChildItem -Path . -Filter "*.html"

foreach ($file in $htmlFiles) {
    Write-Host "Processing file: $($file.Name)"
    $content = Get-Content -Path $file.FullName -Raw
    
    # Replace the justify-content property in footer-social a class from flex-start to center
    $updatedContent = $content -replace '(\.footer-social\s+a\s*\{[\s\S]*?justify-content:\s*)flex-start', '$1center'
    
    # Check if any changes were made
    if ($content -ne $updatedContent) {
        # Save the changes back to the file
        Set-Content -Path $file.FullName -Value $updatedContent
        Write-Host " - Updated: Social media icons centered in $($file.Name)" -ForegroundColor Green
    } else {
        Write-Host " - No changes needed in $($file.Name) (icons may already be centered)" -ForegroundColor Yellow
    }
}

Write-Host "Social media icon centering fix completed!" -ForegroundColor Cyan 