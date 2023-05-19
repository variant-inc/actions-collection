$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"
$WarningPreference = "SilentlyContinue"

Trap
{
  Write-Error $_.InvocationInfo.ScriptName -ErrorAction Continue
  $line = "$($_.InvocationInfo.ScriptLineNumber): $($_.InvocationInfo.Line)"
  Write-Error $line -ErrorAction Continue
  Write-Error $_
}

$SonarUrl = "https://sonarcloud.io"
$SonarHeaders = @{
  'Authorization' = 'Bearer ' + $env:SONAR_TOKEN
  'Accept'        = 'application/json'
}

$SonarCheckUrl = "$SonarUrl/api/components/show?component=$env:SONAR_PROJECT_KEY"
Write-Output "::debug::Sonar URI for project-exist-check $sonarCheckUrl"
$SonarProjectExists = $False
try
{
  $Response = Invoke-RestMethod -Uri $sonarCheckUrl `
    -Headers $SonarHeaders -Method GET
  Write-Output "::debug::$($Response | ConvertTo-Json -Compress)"
  if (($Response.component | Select-Object -ExpandProperty key) -eq $env:SONAR_PROJECT_KEY)
  {
    Write-Output "::notice::Sonar Project with Key $env:SONAR_PROJECT_KEY exists."
    $SonarProjectExists = $True
  }
}
catch
{
  Write-Output $_.ErrorDetails.Message
  if ($_.ErrorDetails.Message -match "not found")
  {
    Write-Information "::notice::Sonar project key $env:SONAR_PROJECT_KEY not found."
    Register-SonarProject -SONAR_PROJECT_KEY $env:SONAR_PROJECT_KEY -SONAR_PROJECT_NAME $env:SONAR_PROJECT_NAME
  }
  else
  {
    throw "Some unexpected Exception Occured"
  }
}

if (!$SonarProjectExists)
{
  Write-Output "Creating sonar project for key $env:SONAR_PROJECT_KEY."
  $sonarCreateUrl = "https://sonarcloud.io/api/alm_integration/provision_monorepo_projects"

  $body = @{
    organization = $env:SONAR_ORG
    projects     = @(
      @{
        projectKey      = $env:SONAR_PROJECT_KEY
        projectName     = $env:SONAR_PROJECT_NAME
        installationKey = $env:GITHUB_REPOSITORY + '|' + $env:GITHUB_REPOSITORY_ID
      }
    )
  }
  Write-Output "::debug::URI for sonar-project-create: $sonarCreateUrl"
  Write-Output "::debug::Create Sonar project post body: $($body | ConvertTo-Json)"
  $Response = Invoke-RestMethod -Uri $sonarCreateUrl `
    -Headers $SonarHeaders -Method post -Body ($body | ConvertTo-Json -Depth 5)
  Write-Output "::notice::Create sonar project response: $($Response | ConvertTo-Json)"
}
