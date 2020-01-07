
## Variables
$SLAPSEnv_PATH='c:\users\public\SLAPSEnv'
$SLAPSEnv_SleepTime=0.3

##

function DownloadFilesFromRepo {
Param(
    [string]$Owner,
    [string]$Repository,
    [string]$Path,
    [string]$DestinationPath
    )
    [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
    $baseUri = "https://api.github.com/"
    $args = "repos/$Owner/$Repository/contents/$Path"
    $wr = Invoke-WebRequest -Uri $($baseuri+$args)
    $objects = $wr.Content | ConvertFrom-Json
    $files = $objects | where {$_.type -eq "file"} | Select -exp download_url
    $directories = $objects | where {$_.type -eq "dir"}
    
    $directories | ForEach-Object { 
        DownloadFilesFromRepo -Owner $Owner -Repository $Repository -Path $_.path -DestinationPath $($DestinationPath+$_.name)
    }

    
    if (-not (Test-Path $DestinationPath)) {
        # Destination path does not exist, let's create it
        try {
            New-Item -Path $DestinationPath -ItemType Directory -ErrorAction Stop
        } catch {
            throw "Could not create path '$DestinationPath'!"
        }
    }

    foreach ($file in $files) {
        $fileDestination = Join-Path $DestinationPath (Split-Path $file -Leaf)
        try {
            Invoke-WebRequest -Uri $file -OutFile $fileDestination -ErrorAction Stop -Verbose
            "Grabbed '$($file)' to '$fileDestination'"
        } catch {
            throw "Unable to download '$($file.path)'"
        }
    }

}


if (test-path $SLAPSEnv_PATH ) {
    Get-ChildItem $SLAPSEnv_PATH  | ForEach-Object {
        ## If contains UNIX line endings, replace with Windows line endings
    if (Get-Content $_.FullName -Delimiter "`0" | Select-String "[^`r]`n")
        {
            Write-Host -ForegroundColor Blue "Converting $($_) to Windows format..."
            $content = Get-Content $_.FullName
            $content | Set-Content $_.FullName
        }
    }
    foreach ($File2Set in Get-ChildItem $SLAPSEnv_PATH -Name -Filter 'SLA-FORMAT*.PS1') {
    Write-Host -ForegroundColor Green "Setting $($File2Set)"
    sleep $SLAPSEnv_SleepTime
    . $SLAPSEnv_PATH/$File2Set
    }
    foreach ($File2Set in Get-ChildItem $SLAPSEnv_PATH -Name -Filter 'SLA-WIN*.PS1') {
    Write-Host -ForegroundColor Green "Setting $($File2Set)"
    sleep $SLAPSEnv_SleepTime
    . $SLAPSEnv_PATH/$File2Set
    }
    foreach ($File2Set in Get-ChildItem $SLAPSEnv_PATH -Name -Filter 'SLA-SQL*.PS1') {
    Write-Host -ForegroundColor Green "Setting $($File2Set)"
    sleep $SLAPSEnv_SleepTime
    . $SLAPSEnv_PATH/$File2Set
    }
}
 
