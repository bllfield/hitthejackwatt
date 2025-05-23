# Script to update all HTML pages with mobile menu

$htmlFiles = Get-ChildItem -Path . -Filter "*.html" | Where-Object { $_.Name -ne "index.html" }

foreach ($file in $htmlFiles) {
    Write-Host "Processing file: $($file.Name)"
    $content = Get-Content -Path $file.FullName -Raw
    
    # 1. Add hamburger menu toggle
    $hamburgerMenu = @'
    <!-- Hamburger menu icon for mobile -->
    <div class="mobile-menu-toggle">
        <div class="hamburger">
            <span></span>
            <span></span>
            <span></span>
        </div>
    </div>
    
'@
    
    $closeButton = @'
        <div class="mobile-close-btn">&times;</div>
'@
    
    # Update navigation container and links
    $content = $content -replace '(<div class="nav-container">[\s\S]*?)(<div class="nav-links">)', "`$1$hamburgerMenu`$2$closeButton"
    
    # 2. Add mobile menu styles
    $mobileStyles = @'
    /* Mobile menu styles */
    .mobile-menu-toggle {
      display: none;
      cursor: pointer;
      z-index: 1000;
    }
    
    .hamburger {
      width: 30px;
      height: 20px;
      position: relative;
      margin: 0;
      transform: rotate(0deg);
      transition: .5s ease-in-out;
    }
    
    .hamburger span {
      display: block;
      position: absolute;
      height: 3px;
      width: 100%;
      background: var(--neon-green);
      border-radius: 9px;
      opacity: 1;
      left: 0;
      transform: rotate(0deg);
      transition: .25s ease-in-out;
      box-shadow: 0 0 8px var(--neon-green);
    }
    
    .hamburger span:nth-child(1) {
      top: 0px;
    }
    
    .hamburger span:nth-child(2) {
      top: 8px;
    }
    
    .hamburger span:nth-child(3) {
      top: 16px;
    }
    
    .hamburger.open span:nth-child(1) {
      top: 8px;
      transform: rotate(135deg);
    }
    
    .hamburger.open span:nth-child(2) {
      opacity: 0;
      left: -60px;
    }
    
    .hamburger.open span:nth-child(3) {
      top: 8px;
      transform: rotate(-135deg);
    }
    
    body.menu-open { overflow: hidden; }
    
    .mobile-close-btn {
      position: absolute;
      top: 15px;
      right: 15px;
      font-size: 30px;
      color: var(--neon-green);
      cursor: pointer;
      width: 40px;
      height: 40px;
      display: none; /* Hide by default */
      align-items: center;
      justify-content: center;
      border-radius: 50%;
      background: rgba(0, 0, 0, 0.3);
      transition: all 0.3s ease;
      box-shadow: 0 0 10px var(--neon-green);
    }
    
    .mobile-close-btn:hover {
      transform: scale(1.1);
      background: rgba(0, 0, 0, 0.5);
    }
    
    @media (max-width: 768px) {
      .mobile-menu-toggle {
        display: flex;
        align-items: center;
        justify-content: flex-start;
      }
      
      .nav-links {
        position: fixed;
        top: 0;
        right: -120%;
        width: 200px; max-width: 80%;
        height: 100vh;
        background: rgba(18, 0, 56, 0.98);
        backdrop-filter: blur(15px);
        flex-direction: column;
        align-items: center;
        justify-content: flex-start;
        gap: 1rem;
        transition: right 0.3s ease;
        z-index: 9999;
        padding: 5rem 1rem 2rem;
        box-shadow: -5px 0 30px rgba(0, 0, 0, 0.7);
        visibility: hidden;
        opacity: 0;
      }
      
      .nav-links.active {
        right: 0;
        visibility: visible;
        opacity: 1;
      }
      
      .nav-links a {
        font-size: 1.1rem;
        padding: 0.8rem 0;
        width: 100%;
        text-align: center;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      }
      
      .nav-links a:last-child {
        border-bottom: none;
      }
      
      .mobile-close-btn {
        display: flex; /* Only show on mobile */
      }
    }
'@
    
    # Add mobile styles before the end of the style tag
    $content = $content -replace '</style>', "$mobileStyles`n    </style>"
    
    # 3. Add JavaScript for mobile menu
    $mobileScript = @'
<script>
    // Mobile menu toggle
    document.addEventListener('DOMContentLoaded', function() {
      const mobileMenuToggle = document.querySelector('.mobile-menu-toggle');
      const hamburger = document.querySelector('.hamburger');
      const navLinks = document.querySelector('.nav-links');
      const body = document.body;
      
      // Toggle menu when hamburger is clicked
      mobileMenuToggle.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        // If the menu is currently closed, show it first
        if (!navLinks.classList.contains('active')) {
          navLinks.style.display = 'flex';
        }
        
        hamburger.classList.toggle('open');
        navLinks.classList.toggle('active');
        body.classList.toggle('menu-open');
        
        // If we're closing the menu, hide it after animation
        if (!navLinks.classList.contains('active')) {
          setTimeout(function() {
            navLinks.style.display = 'none';
          }, 300);
        }
      });
      
      // Close menu when a link is clicked
      const navLinksItems = document.querySelectorAll('.nav-links a');
      navLinksItems.forEach(item => {
        item.addEventListener('click', function() {
          hamburger.classList.remove('open');
          navLinks.classList.remove('active');
          body.classList.remove('menu-open');
        });
      });
      
      // Close button functionality
      const closeBtn = document.querySelector('.mobile-close-btn');
      if (closeBtn) {
        closeBtn.addEventListener('click', function() {
          hamburger.classList.remove('open');
          navLinks.classList.remove('active');
          body.classList.remove('menu-open');
          
          // Force menu to be invisible after animation completes
          setTimeout(function() {
            if (!navLinks.classList.contains('active')) {
              navLinks.style.display = 'none';
            }
          }, 300);
        });
      }
    });
</script>
'@
    
    # Add mobile script before the end of the body tag
    $content = $content -replace '</body>', "$mobileScript`n</body>"
    
    # Save the changes back to the file
    Set-Content -Path $file.FullName -Value $content
    
    Write-Host "Updated file: $($file.Name)"
}

Write-Host "All HTML files have been updated successfully."
