$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"
$WarningPreference = "SilentlyContinue"

Trap {
    Write-Error $_.InvocationInfo.ScriptName -ErrorAction Continue
    $line = "$($_.InvocationInfo.ScriptLineNumber): $($_.InvocationInfo.Line)"
    Write-Error $line -ErrorAction Continue
    Write-Error $_
}

function CommandAliasFunction {
    Write-Information ""
    Write-Information "$args"
    $cmd, $args = $args
    & "$cmd" $args
    if ($LASTEXITCODE) {
        throw "Exception Occured"
    }
    Write-Information ""
}

Set-Alias -Name ce -Value CommandAliasFunction -Scope script

$AwsAccountId = $(aws sts get-caller-identity --output text --query Account)
$EcrRegistry = "$AwsAccountId.dkr.ecr.$env:AWS_DEFAULT_REGION.amazonaws.com"
$Image = "$EcrRegistry/$env:INPUT_ECR_REPOSITORY" + ":" + "$env:IMAGE_VERSION"
$DockerfilePath = "$env:INPUT_DOCKERFILE_DIR_PATH"
$removeImage = $true

Write-Output "Setting image name to environment variables"
Write-Output "IMAGE_NAME=$Image" | Out-File -FilePath $Env:GITHUB_ENV -Encoding utf8 -Append

try {
    $ImageCount = aws ecr list-images --repository-name $env:INPUT_ECR_REPOSITORY | jq '.imageIds | unique_by(.imageDigest) | length'
    $ImageTags = aws ecr describe-images --repository-name $env:INPUT_ECR_REPOSITORY --max-items $ImageCount --query 'imageDetails[*].imageTags[0]'
    if ($ImageTags -like "*$env:IMAGE_VERSION*") {
        Write-Output "Image already pushed. Skipping docker push"
        $removeImage = $false
        exit 0
    }
    else {
        Write-Output "New image, proceeding to docker push"
    }

    ce docker login --username drivevariant -p "$env:DOCKER_PASSWORD"
    Write-Output "Connecting to AWS account."
  (aws ecr get-login-password) | docker login -u AWS --password-stdin "$EcrRegistry"

    $BuildArgs = ""
    Get-ChildItem env:* | Sort-Object name  | ForEach-Object {
        $BuildArgs += "--build-arg $($_.Name)='$($_.Value)' "
    }

    $expression = "ce docker build $BuildArgs -t $Image $DockerfilePath"
    Invoke-Expression $expression

    Write-Output "Start: Trivy Scan"
    sh -c "./actions-collection/scripts/trivy_scan.sh"
    Write-Output "End: Trivy Scan"

    ce docker push "$Image"
}
catch {
    $local_error_message = @("`e[31m----------------------------------------------------------------`e[0m"
                            ,"`e[31m Error occurred in build and publishing image`e[0m"
                            ,"`e[31m----------------------------------------------------------------`e[0m"
    );
    Write-Output "`e[31m Error occurred in build and publishing image`e[0m"
}
finally {
    if ($local_error_message)
    {
        Write-Error "`r`n$($local_error_message -join "`r`n")"
    }
    ce docker logout "$EcrRegistry"
    if ($true -eq $removeImage) {
        Write-Output "Removing image"
        ce docker image rm "$Image"
    }
}