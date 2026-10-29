<#
    Regenerates the downloadable CV PDFs from index.html.

    Uses headless Chrome, so the output comes from the very same rendering
    engine and @media print styles the page already uses - the text stays
    vectorial and selectable (ATS friendly), unlike a canvas/raster export.

    Run it after any edit to index.html:
        powershell -ExecutionPolicy Bypass -File scripts\build-pdf.ps1
#>

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$page = Join-Path $root 'index.html'
$outDir = Join-Path $root 'pdf'

if (-not (Test-Path $page)) { throw "index.html not found at $page" }
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory $outDir | Out-Null }

$chrome = @(
    "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
    "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
    "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe",
    "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $chrome) { throw 'Could not find Chrome or Edge. Install Chrome or edit this script.' }

$targets = @(
    @{ Lang = 'es'; Out = 'Bryan-Bocio-CV-ES.pdf' },
    @{ Lang = 'en'; Out = 'Bryan-Bocio-CV-EN.pdf' }
)

foreach ($t in $targets) {
    $url = 'file:///' + $page.Replace([char]92, '/')
    if ($t.Lang -ne 'es') { $url += '?lang=' + $t.Lang }
    $out = Join-Path $outDir $t.Out

    & $chrome --headless --disable-gpu --no-first-run --no-margins `
        --no-pdf-header-footer --virtual-time-budget=4000 `
        "--print-to-pdf=$out" $url | Out-Null

    if (-not (Test-Path $out)) { throw "Chrome did not produce $out" }
    $kb = [math]::Round((Get-Item $out).Length / 1KB, 1)
    Write-Output "  $($t.Out)  ($kb KB)"
}

Write-Output 'PDFs regenerated in pdf\'
