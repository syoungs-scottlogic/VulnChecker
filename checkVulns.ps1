. ./variable.ps1

[int]$awsCheck = 1
$packageArray = @()

$Params = @{
    "URI"       = 'http://localhost:8081/api/v1/component/project/04444305-bac9-4a07-8b12-b83aa4e4523e'
    "Method"    = 'GET'
    "Headers"   = @{
        "accept"    = "application/json"
        "X-Api-Key" = $token
    }
}

$request = Invoke-RestMethod @Params
$packages = $request | ConvertTo-Json | ConvertFrom-Json

foreach ($item in $packages)
{
    if ($item -like "*aws*")
    {
        # add AWS logic once.
        if($awsCheck -ne 0)
        {
            $item.name = "AWS Python package"
            $packageArray += $item
            $awsCheck = 0
        }

    }
    else {
        $packageArray += $item
    }
}

$format = $packageArray | Select-Object -Property name, version, purl, @{Name="latestVersion"; Expression={$_.repositoryMeta.latestVersion}}
$format | Export-Csv -path .\result.csv -NoTypeInformation