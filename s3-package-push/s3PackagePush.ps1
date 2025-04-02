param (
    [string]$BranchName
)

# Exit on any error
$ErrorActionPreference = "Stop"

$SourcePackage = $env:PACKAGE_PATH
$ZipPackage = "$env:PACKAGE_PATH.zip"

$S3Bucket = $env:S3_BUCKET

$Version = $env:IMAGE_VERSION
if (-not $Version) {
    Write-Error "Error: IMAGE_VERSION environment variable is not set."
    exit 1
}

# main is stable, else pre-release and append version
$S3Key = "$env:PACKAGE_NAME/$env:PACKAGE_NAME.$Version.zip"

if (!(Test-Path -Path $SourcePackage)) {
    Write-Error "Error: $SourcePackage does not exist."
    exit 1
}

if (Test-Path -Path $ZipPackage) {
    Remove-Item -Path $ZipPackage -Force
}
Write-Host "Compressing $SourcePackage to $ZipPackage"
Compress-Archive -Path $SourcePackage -DestinationPath $ZipPackage

Write-Host "Uploading $ZipPackage to s3://$S3Bucket/$S3Key"
aws s3 cp $ZipPackage "s3://$S3Bucket/$S3Key"

Write-Host "Upload complete to s3://$S3Bucket/$S3Key"

$ReleaseType = "pre-release"
if ([string]::IsNullOrEmpty($env:GitVersion_PreReleaseLabel)) {
    $ReleaseType = "stable"
}

$tags = @{
    TagSet = @(
        @{ Key = "release"; Value = $ReleaseType },
        @{ Key = "packageType"; Value = "system" }
    )
} | ConvertTo-Json -Compress

aws s3api put-object-tagging \
    --bucket $S3Bucket \
    --key $S3Key \
    --tagging $tags

Write-Host "Add tag $tags to s3://$S3Bucket/$S3Key"

Add-Content -Path ${env:GITHUB_STEP_SUMMARY} `
  -Encoding utf8 `
  -Value "## Uploaded Package"
Add-Content -Path ${env:GITHUB_STEP_SUMMARY} `
  -Encoding utf8 `
  -Value "s3://$S3Bucket/$S3Key"
