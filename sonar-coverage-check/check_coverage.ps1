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
  }
  else
  {
    throw "Some unexpected Exception Occured"
  }
}

Write-Output "Checking coverage report for key $env:SONAR_PROJECT_KEY."
$branchName = [System.Web.HttpUtility]::UrlEncode($env:GitVersion_BranchName)
$sonarCheckUrl = "https://sonarcloud.io/api/measures/component?component=$env:SONAR_PROJECT_KEY&branch=$branchName&metricKeys=coverage"


Write-Output "::debug::URI for sonar-coverage-check: $sonarCheckUrl"
$Response = Invoke-RestMethod -Uri $sonarCheckUrl `
  -Headers $SonarHeaders -Method get
Write-Output "::debug::Check sonar coverage response: $($Response | ConvertTo-Json)"
if ($Response.component.measures.Length -eq 0) {
  Write-Output "::error::No coverage results found."
  exit 1
} else {
  Write-Output "::debug::Coverage results exist."
}
