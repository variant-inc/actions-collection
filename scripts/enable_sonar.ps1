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

function Register-SonarProject {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $SONAR_PROJECT_KEY,
        [Parameter()]
        [string]
        $SONAR_PROJECT_NAME
    )
    Write-Output "Fetching Repo id"
    $githubRepoUrl = "https://api.github.com/repos/$env:GITHUB_REPOSITORY"
    $headers = @{
        'Authorization' = 'Bearer ' + $env:GITHUB_TOKEN
        'Accept'        = 'application/json'
    }
    $gitResponse = Invoke-RestMethod -Uri $githubRepoUrl `
        -Headers $headers -Method GET
    $gitResponse | ConvertTo-Json
    $repo_id = $gitResponse.id

    Write-Output "Creating for sonar project key $SONAR_PROJECT_KEY"
    $sonarCreateUrl = "https://sonarcloud.io/api/alm_integration/provision_monorepo_projects"
    $headers = @{
        'Authorization' = 'Bearer ' + $env:SONAR_TOKEN
        'Accept'        = 'application/json'
    }


    $list = New-Object System.Collections.ArrayList
    $list.add(@{
            projectKey      = $SONAR_PROJECT_KEY
            projectName     = $SONAR_PROJECT_NAME
            installationKey = $env:GITHUB_REPOSITORY + '|' + $repo_id

        })
    $body = @{
        organization = $env:SONAR_ORG
        projects     = $list
    }
    Write-Output "Create Sonar project post url:$sonarCreateUrl"
    Write-Output "Create Sonar project post body:"
    $body | ConvertTo-Json
    $Response = Invoke-RestMethod -Uri $sonarCreateUrl `
        -Headers $headers -Method post -Body ($body | ConvertTo-Json -Depth 5)
    Write-Output "Create sonar project response:"
    $Response | ConvertTo-Json
}

function Get-SonarProjectOrCreate {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $SONAR_PROJECT_KEY,
        [Parameter()]
        [string]
        $SONAR_PROJECT_NAME
    )
    $sonarCheckUrl = "https://sonarcloud.io/api/components/show?component=$SONAR_PROJECT_KEY"
    $headers = @{
        'Authorization' = 'Bearer ' + $env:SONAR_TOKEN
        'Accept'        = 'application/json'
    }
    Write-Output "Sonar project key check url $sonarCheckUrl"
    try {
        $Response = Invoke-RestMethod -Uri $sonarCheckUrl `
            -Headers $headers -Method GET
        $Response | ConvertTo-Json
        if (($Response.component | Select-Object -ExpandProperty key) -eq $SONAR_PROJECT_KEY) {
            Write-Output "Sonar project key exists in sonar console"
        }

    }
    catch {
        Write-Output $_.ErrorDetails.Message
        if ($_.ErrorDetails.Message -match "not found") {
            Write-Information "Sonar project key $SONAR_PROJECT_KEY not found"
            Write-Information "Creating sonar project key: $SONAR_PROJECT_KEY"
            Register-SonarProject -SONAR_PROJECT_KEY $SONAR_PROJECT_KEY -SONAR_PROJECT_NAME $SONAR_PROJECT_NAME
        }
        else {
            throw "Some Unexpected Exception Occured"
        }
    }

}


if (![string]::IsNullOrEmpty($SONAR_PROJECT_KEY_INPUT)) {
    Write-Output "Checking for sonar project key input: $SONAR_PROJECT_KEY_INPUT"
    Get-SonarProjectOrCreate -SONAR_PROJECT_KEY $SONAR_PROJECT_KEY_INPUT -SONAR_PROJECT_NAME $SONAR_PROJECT_KEY_INPUT
} else {
    Write-Output "No sonar project key input given using devops convention:$env:SONAR_PROJECT_KEY"
    Get-SonarProjectOrCreate -SONAR_PROJECT_KEY $env:SONAR_PROJECT_KEY -SONAR_PROJECT_NAME $env:SONAR_PROJECT_KEY
}


