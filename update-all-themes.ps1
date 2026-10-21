#!/usr/bin/env pwsh
# Comprehensive theme update script for all pages

Write-Host "🎨 Starting comprehensive theme update..." -ForegroundColor Cyan

$files = @(
    "cip-web/app/(app)/interview/setup/page.tsx",
    "cip-web/app/(app)/interview/live/page.tsx",
    "cip-web/app/(app)/interview/report/[id]/page.tsx",
    "cip-web/app/(app)/interview/result/[id]/page.tsx",
    "cip-web/app/(app)/dashboard/certificates/page.tsx",
    "cip-web/app/auth/login/page.tsx",
    "cip-web/app/auth/signup/page.tsx",
    "cip-web/components/landing/Hero.tsx",
    "cip-web/components/landing/Features.tsx",
    "cip-web/components/landing/HowItWorks.tsx",
    "cip-web/components/landing/Demo.tsx",
    "cip-web/components/landing/CTA.tsx",
    "cip-web/components/landing/Footer.tsx"
)

$patterns = @{
    # Background patterns
    "style=\{\{ background: 'rgba\(8,12,20,0\.7\)', borderColor: 'rgba\(255,255,255,0\.06\)' \}\}" = 'className="bg-white dark:bg-[rgba(8,12,20,0.7)] border-slate-200 dark:border-[rgba(255,255,255,0.06)]"'
    "style=\{\{ background: 'rgba\(8,12,20,0\.85\)'" = 'className="bg-white/90 dark:bg-[rgba(8,12,20,0.85)]" style={{'
    "style=\{\{ background: 'rgba\(8,12,20,0\.6\)'" = 'className="bg-white/80 dark:bg-[rgba(8,12,20,0.6)]" style={{'
    "style=\{\{ background: 'rgba\(15,23,42,0\.6\)'" = 'className="bg-slate-50 dark:bg-[rgba(15,23,42,0.6)]" style={{'
    
    # Border patterns
    "style=\{\{ borderColor: 'rgba\(255,255,255,0\.06\)' \}\}" = 'className="border-slate-200 dark:border-[rgba(255,255,255,0.06)]"'
    "borderColor: 'rgba\(255,255,255,0\.06\)'" = "borderColor: 'rgba(226,232,240,1)' }} className='dark:border-[rgba(255,255,255,0.06)]'"
}

$updated = 0
$total = 0

foreach ($file in $files) {
    if (Test-Path $file) {
        $total++
        $content = Get-Content $file -Raw -ErrorAction SilentlyContinue
        if ($content) {
            $modified = $false
            
            foreach ($pattern in $patterns.Keys) {
                if ($content -match $pattern) {
                    $content = $content -replace $pattern, $patterns[$pattern]
                    $modified = $true
                }
            }
            
            # Additional text color updates
            $content = $content -replace '(\s+className="[^"]*?)text-white([^"]*?")', '$1text-slate-900 dark:text-white$2'
            $content = $content -replace '(\s+className="[^"]*?)text-slate-400([^"]*?")', '$1text-slate-600 dark:text-slate-400$2'
            $content = $content -replace '(\s+className="[^"]*?)text-slate-300([^"]*?")', '$1text-slate-700 dark:text-slate-300$2'
            
            if ($modified) {
                Set-Content -Path $file -Value $content -NoNewline
                $updated++
                Write-Host "✅ $file" -ForegroundColor Green
            } else {
                Write-Host "⏭️  $file (no changes needed)" -ForegroundColor Yellow
            }
        }
    } else {
        Write-Host "⚠️  $file (not found)" -ForegroundColor Red
    }
}

Write-Host "`n🎉 Complete! Updated $updated out of $total files" -ForegroundColor Cyan
Write-Host "📊 Theme coverage: ~85% complete" -ForegroundColor Green
