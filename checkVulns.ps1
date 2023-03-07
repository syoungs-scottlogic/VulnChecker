. ./variable.ps1
<#
v1/component/project
contains RepositoryMeta which has the newer version.

or just select object api call and filter what I need there.
then add aws stuff array and bring 1 back. 

https://stackoverflow.com/questions/37705139/psobject-array-in-powershell

array
    name
    version
    purl
    repositorymeta
        repositoryname
        latestVersion

#>

#Invoke-WebRequest -Uri 'http://localhost:8081/api/v1/component/project/04444305-bac9-4a07-8b12-b83aa4e4523e' -token $token

$Params = @{
    "URI"       = 'http://localhost:8081/api/v1/component/project/04444305-bac9-4a07-8b12-b83aa4e4523e'
    "Method"    = 'GET'
    "Headers"   = @{
        "accept"    = "application/json"
        "X-Api-Key" = $token
    }
}


[int]$awsCheck = 1

$request = Invoke-RestMethod @Params

$packages = $request | ConvertTo-Json | ConvertFrom-Json

#$format = $packages | ft -Property name, version, purl, @{Name="latestVersion"; Expression={$_.repositoryMeta.latestVersion}}

$packageArray = @()


foreach ($item in $packages)
{
    if ($item -like "*aws*")
    {
        # add aws stuff
        if($awsCheck -ne 0)
        {
            $item.name = "AWS Python package"
            $packageArray += $item
            $awsCheck = 0
        }

    }
    else {
        $packageArray += $item
        #echo "hello! -- $item"
    }
}


$format = $packageArray | Select-Object -Property name, version, purl, @{Name="latestVersion"; Expression={$_.repositoryMeta.latestVersion}}
#$packageArray
$format | Export-Csv -path .\result.csv -NoTypeInformation
#$format