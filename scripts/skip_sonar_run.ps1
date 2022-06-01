
[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $SONAR_PROJECT_KEY_INPUT
)

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"
$WarningPreference = "SilentlyContinue"

Trap {
    Write-Error $_.InvocationInfo.ScriptName -ErrorAction Continue
    $line = "$($_.InvocationInfo.ScriptLineNumber): $($_.InvocationInfo.Line)"
    Write-Error $line -ErrorAction Continue
    Write-Error $_
}
function CheckSonarRun {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $SONAR_PROJECT_KEY
    )
    $sonarCheckUrl = "https://sonarcloud.io/api/project_branches/list?project=$SONAR_PROJECT_KEY"
    $headers = @{
        'Authorization' = 'Bearer ' + $env:SONAR_TOKEN
        'Accept'        = 'application/json'
    }
    $Response = Invoke-RestMethod -Uri $sonarCheckUrl `
        -Headers $headers -Method GET
    $CommitSha = $Response.branches | Where-Object {
        $_.name -in @($env:GITHUB_REF_NAME)
    }  | Select-Object -First 1 -ExpandProperty commit

    return ($env:GITHUB_SHA -eq $CommitSha.sha)
}

if (![string]::IsNullOrEmpty($SONAR_PROJECT_KEY_INPUT)) {
    CheckSonarRun -SONAR_PROJECT_KEY $SONAR_PROJECT_KEY_INPUT
}
else {
    CheckSonarRun -SONAR_PROJECT_KEY $env:SONAR_PROJECT_KEY
}
