$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"
$WarningPreference = "SilentlyContinue"

Trap {
    Write-Error $_.InvocationInfo.ScriptName -ErrorAction Continue
    $line = "$($_.InvocationInfo.ScriptLineNumber): $($_.InvocationInfo.Line)"
    Write-Error $line -ErrorAction Continue
    Write-Error $_
}

$AwsAccountId = $(aws sts get-caller-identity --output text --query Account)
$EcrRegistry = "$AwsAccountId.dkr.ecr.$env:AWS_DEFAULT_REGION.amazonaws.com"
$Image = "$EcrRegistry/$env:INPUT_ECR_REPOSITORY" + ":" + "$env:IMAGE_VERSION"
$DockerfilePath = "$env:INPUT_DOCKERFILE_DIR_PATH"

try
{
  $ImageTags = aws ecr describe-images --repository-name $env:INPUT_ECR_REPOSITORY --no-paginate --query 'imageDetails[*].imageTags[0]'
  Write-Output "Start: Image Tags"
  Write-Output $ImageTags
  Write-Output $env:IMAGE_VERSION
  if ($ImageTags -Contains $env:IMAGE_VERSION) {
    Write-Output "Image already pushed. Skipping docker push"
    exit 0
  }else{
    Write-Output "Not pushed yet"
  }

  # docker login --username drivevariant -p "$env:DOCKER_PASSWORD"
  Write-Output "Connecting to AWS account."
  (aws ecr get-login-password) | docker login -u AWS --password-stdin "$EcrRegistry"

  New-Item -ItemType Directory -Force -Path /publish

  $BuildArgs = ""
  Get-ChildItem env:* | Sort-Object name | ForEach-Object {
    $BuildArgs += "--build-arg '$($_.Name)'='$($_.Value)'"
  }

  Write-Output "Start: Printing Image"
  Write-Output $Image
  Write-Output "Start: Build args"

  Invoke-Expression "docker build -t $Image $DockerfilePath"

  # Write-Output "Start: Trivy Scan"
  # sh -c "./actions-collection/scripts/trivy_scan.sh"
  # Write-Output "End: Trivy Scan"

  # docker push "$IMAGE"

  # Write-Output "Setting image name to environment variables"
  # Write-Output "IMAGE_NAME=$IMAGE" >>"$GITHUB_ENV"
}
finally
{
  # Remove-Item -Recurse -Force publish
  # docker logout "$EcrRegistry"
  # docker image rm "$Image"
}