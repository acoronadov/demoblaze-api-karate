$ErrorActionPreference = 'Stop'
$evidencePath = Join-Path $PSScriptRoot 'reports'
New-Item -ItemType Directory -Path $evidencePath -Force | Out-Null
$runs = @(
    @{ Name = 'signup'; Tag = '@signup'; Expected = 2 },
    @{ Name = 'login'; Tag = '@login'; Expected = 2 },
    @{ Name = 'negative'; Tag = '@negative'; Expected = 2 },
    @{ Name = 'smoke'; Tag = '@smoke'; Expected = 2 },
    @{ Name = 'positive'; Tag = '@positive'; Expected = 2 },
    @{ Name = 'api'; Tag = '@api'; Expected = 4 },
    @{ Name = 'completa'; Tag = ''; Expected = 4 }
)
$summaryLines = @('Validación real contra DemoBlaze', 'Java 17 / Karate 1.5.2 / JUnit 5', '')
Push-Location $PSScriptRoot
try {
    foreach ($run in $runs) {
        $mavenArguments = @('clean', 'test')
        if ($run.Tag) {
            $mavenArguments += "-Dkarate.options=--tags $($run.Tag)"
        }
        $logPath = Join-Path $evidencePath "$($run.Name)-maven.log"
        & mvn @mavenArguments > $logPath 2>&1
        $mavenExitCode = $LASTEXITCODE
        $result = Get-Content 'target/karate-reports/karate-summary-json.txt' -Raw | ConvertFrom-Json
        if ($mavenExitCode -ne 0 -or $result.scenariosfailed -ne 0 -or $result.scenariosPassed -ne $run.Expected) {
            throw "Falló la validación de $($run.Name). Revisa $logPath"
        }
        Copy-Item 'target/karate-reports/karate-summary-json.txt' (Join-Path $evidencePath "$($run.Name)-summary.json")
        $line = "mvn $($mavenArguments -join ' ') => BUILD SUCCESS; $($result.scenariosPassed) escenarios aprobados, 0 fallos; $($result.resultDate) (America/Bogota)"
        $summaryLines += $line
        Write-Output $line
        $summaryLines | Set-Content (Join-Path $evidencePath 'evidencias.txt') -Encoding UTF8
    }
    $htmlPath = Join-Path $evidencePath 'completa-html'
    New-Item -ItemType Directory -Path $htmlPath -Force | Out-Null
    Copy-Item 'target/karate-reports/*.html' $htmlPath
    Copy-Item 'target/karate-reports/*.svg' $htmlPath
    Copy-Item 'target/karate-reports/*.png' $htmlPath
    Copy-Item 'target/karate-reports/*.ico' $htmlPath
    Copy-Item 'target/karate-reports/res' $htmlPath -Recurse -Force
    $summaryLines += '', 'Reporte completo: completa-html/karate-summary.html', 'Logs Maven y resumen JSON por cada ejecución.'
    $summaryLines | Set-Content (Join-Path $evidencePath 'evidencias.txt') -Encoding UTF8
} finally {
    Pop-Location
}
