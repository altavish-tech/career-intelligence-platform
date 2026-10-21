# PowerShell script to apply theme classes to all TSX files
Write-Host "🎨 Applying theme support to all pages..." -ForegroundColor Cyan

$replacements = @(
    # Background replacements
    @{
        Find = 'style=\{\{ background: ''rgba\(8,12,20,0\.7\)'', borderColor: ''rgba\(255,255,255,0\.06\)'' \}\}'
        Replace = 'className="bg-white dark:bg-[rgba(8,12,20,0.7)] border-slate-200 dark:border-[rgba(255,255,255,0.06)]"'
    },
    @{
        Find = 'style=\{\{ background: ''rgba\(8,12,20,0\.85\)'''
        Replace = 'className="bg-white/90 dark:bg-[rgba(8,12,20,0.85)]"'
    },
    @{
        Find = 'style=\{\{ background: ''rgba\(15,23,42,0\.6\)'''
        Replace = 'className="bg-slate-50 dark:bg-[rgba(15,23,42,0.6)]"'
    },
    
    # Text color replacements
    @{
        Find = 'className="([^"]*?)text-white([^"]*?)"'
        Replace = 'className="$1text-slate-900 dark:text-white$2"'
    },
    @{
        Find = 'className="([^"]*?)text-slate-400([^"]*?)"'
        Replace = 'className="$1text-slate-600 dark:text-slate-400$2"'
    },
    @{
        Find = 'className="([^"]*?)text-slate-300([^"]*?)"'
        Replace = 'className="$1text-slate-700 dark:text-slate-300$2"'
    }
)

$files = Get-ChildItem -Path "cip-web/app/(app)" -Filter "*.tsx" -Recurse
$totalFiles = $files.Count
$updatedFiles = 0

Write-Host "Found $totalFiles files to process" -ForegroundColor Yellow

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    $changed = $false
    
    foreach ($replacement in $replacements) {
        if ($content -match $replacement.Find) {
            $content = $content -replace $replacement.Find, $replacement.Replace
            $changed = $true
        }
    }
    
    if ($changed) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        $updatedFiles++
        Write-Host "✅ Updated: $($file.Name)" -ForegroundColor Green
    }
}

Write-Host "`n🎉 Complete! Updated $updatedFiles out of $totalFiles files" -ForegroundColor Cyan
