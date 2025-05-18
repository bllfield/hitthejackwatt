# Script to add FAQ link to navigation menu on all HTML pages

$htmlFiles = Get-ChildItem -Path . -Filter "*.html" | Where-Object { $_.Name -ne "index.html" }

foreach ($file in $htmlFiles) {
    Write-Host "Processing file: $($file.Name)"
    $content = Get-Content -Path $file.FullName -Raw
    
    # Check if the file already has FAQ link in the nav-links section
    if ($content -match '<a href="HitTheJackWatt_FAQ\.html">FAQs</a>') {
        Write-Host "File already has FAQ link: $($file.Name)"
        continue
    }
    
    # Find the nav-links div and insert the FAQ link after Testimonials
    $navLinksPattern = '(<a href="HitTheJackWatt_Testimonials\.html">Testimonials</a>)(\s+)(<a href="index\.html#signup">Sign Up</a>)'
    if ($content -match $navLinksPattern) {
        $updatedContent = $content -replace $navLinksPattern, '$1$2<a href="HitTheJackWatt_FAQ.html">FAQs</a>$2$3'
        
        # Save the changes back to the file
        Set-Content -Path $file.FullName -Value $updatedContent
        Write-Host "Added FAQ link to: $($file.Name)"
    } else {
        # Try an alternative approach if the first pattern doesn't match
        $testimonialLinkPattern = '<a href="HitTheJackWatt_Testimonials\.html">Testimonials</a>'
        
        if ($content -match $testimonialLinkPattern) {
            $updatedContent = $content -replace $testimonialLinkPattern, '$0
            <a href="HitTheJackWatt_FAQ.html">FAQs</a>'
            
            # Save the changes back to the file
            Set-Content -Path $file.FullName -Value $updatedContent
            Write-Host "Added FAQ link using alternative method to: $($file.Name)"
        } else {
            Write-Host "Could not locate the right pattern in: $($file.Name)"
        }
    }
}

Write-Host "Process completed." 