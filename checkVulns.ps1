. ./variable.ps1

########################
#    
#   Check dependencies from a project in Dependency track.
#
#   Change $url to Dependency track root URL. 
#   Change $uuid to the project unique identifier.
#
#   This file uses another file called variable.ps1 as a secrets file,
#   it contains the API token used to access the Dep track API.
#   This can be manually added into the file under a $token variable. 
#   Or a new file called variable.ps1 can be created in this directory
#   with the code $token = <token>
#
#########################

[int]$awsCheck = 1
$packageArray = @()
$url = "http://localhost:8081"
$uuid = "04444305-bac9-4a07-8b12-b83aa4e4523e"

$Params = @{
    "URI"       = "$url/api/v1/component/project/$uuid"
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