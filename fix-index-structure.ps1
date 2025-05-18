# PowerShell script to fix the structure of index.html

# Read the content
$content = Get-Content -Path "index.html" -Raw

# Replace the opening part with fixed structure - removing the hero div wrapper
$content = $content -replace '(?s)<body>\s*<div class="hero">\s*<div class="nav-container">', '<body>
  <div class="nav-container">'

# Remove the extra closing div before the script tag
$content = $content -replace '(?s)    </div>\s*  </div>\s*\s*  <script>', '</div>

<script>'

# Save the changes
Set-Content -Path "index.html" -Value $content

Write-Host "index.html structure fixed successfully." 