. ./variable.ps1
<#
v1/component/project
contains RepositoryMeta which has the newer version.

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
    "URI" = 'http://localhost:8081/api/v1/component/project/04444305-bac9-4a07-8b12-b83aa4e4523e'
    "Method" = 'GET'
    "Headers" = @{
        "accept" = "application/json"
        "X-Api-Key" = $token
    }
}

$request = Invoke-RestMethod @Params 

$packages = $request | ConvertTo-Json | ConvertFrom-Json

$packages | ft

$packageArray = @()

foreach ($item in $packages)
{
    if ($item.name -contains "aws")
    {
        # put the aws package into the array ONCE.
    }

    else {
        # put packages into array.
    }
}