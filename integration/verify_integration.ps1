# =============================================================================
# University Attendance System - Master Integration Verification Script
# Designed for Project Leader: Qahtan Alshagea
# =============================================================================

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "MASTER INTEGRATION VERIFICATION - UNIVERSITY ATTENDANCE SYSTEM" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan

$root = (Get-Location).Path
$hasErrors = $false

# 1. Verify Backend Build & Tests
Write-Host "`n[1/4] Verifying Backend (NestJS + Prisma + PostgreSQL)..." -ForegroundColor Magenta
Push-Location "$root\backend"
try {
    Write-Host "  -> Running NestJS build..." -ForegroundColor Gray
    npm run build
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  [FAIL] Backend build failed!" -ForegroundColor Red
        $hasErrors = $true
    } else {
        Write-Host "  [PASS] Backend build SUCCESS" -ForegroundColor Green
    }

    Write-Host "  -> Running Unit Tests (Jest)..." -ForegroundColor Gray
    npm run test
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  [FAIL] Backend tests failed!" -ForegroundColor Red
        $hasErrors = $true
    } else {
        Write-Host "  [PASS] Backend tests SUCCESS" -ForegroundColor Green
    }
} finally {
    Pop-Location
}

# 2. Verify Member Delivery Packages Completeness
Write-Host "`n[2/4] Verifying Team Delivery Packages Structure..." -ForegroundColor Magenta
$members = @(
    "00_LEADER_QAHTAN_BACKEND",
    "01_OWAB_MOBILE",
    "02_MOHAMMED_ALAWADI_BIOMETRIC",
    "03_MOHAMMED_ALAYDAROUS_LOCAL",
    "04_MISHAL_ADMIN_WEB"
)

foreach ($m in $members) {
    $mPath = "$root\team_delivery\$m"
    if (Test-Path $mPath) {
        $foundationCount = (Get-ChildItem "$mPath\COMMON_FOUNDATION" -Directory -ErrorAction SilentlyContinue).Count
        $tasksCount = (Get-ChildItem "$mPath\tasks" -Directory -ErrorAction SilentlyContinue).Count
        Write-Host "  [OK] $m -> Foundation Steps: $foundationCount | Tasks: $tasksCount" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Missing delivery folder: $m" -ForegroundColor Red
        $hasErrors = $true
    }
}

# 3. Verify Database Container Status
Write-Host "`n[3/4] Verifying PostgreSQL Docker Container..." -ForegroundColor Magenta
$pgStatus = docker ps --filter "name=university_attendance_postgres" --format "{{.Status}}"
if ($pgStatus -match "Up") {
    Write-Host "  [OK] PostgreSQL container is healthy and running: $pgStatus" -ForegroundColor Green
} else {
    Write-Host "  [WARNING] PostgreSQL container is not currently running." -ForegroundColor Yellow
}

# 4. Summary & Decision
Write-Host "`n============================================================" -ForegroundColor Cyan
if ($hasErrors) {
    Write-Host "INTEGRATION AUDIT FAILED - Please resolve errors before merging." -ForegroundColor Red
    exit 1
} else {
    Write-Host "ALL INTEGRATION CHECKS PASSED - READY FOR STABLE OPERATION!" -ForegroundColor Green
    Write-Host "============================================================" -ForegroundColor Cyan
    exit 0
}
