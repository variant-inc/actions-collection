
[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $SONAR_PROJECT_KEY_INPUT = $env:SONAR_PROJECT_KEY
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
    $Project = $Response.branches | Where-Object { $_.name -in $env:GITHUB_REF_NAME }

    if ($Project.commit.length -eq 0 -or $Project.status.qualityGateStatus -ne "OK") # no commit found or last scan did not pass
    {
        return $false
    }
    return ($env:GITHUB_SHA -eq $Project.commit.sha)
}

CheckSonarRun -SONAR_PROJECT_KEY $SONAR_PROJECT_KEY_INPUT
