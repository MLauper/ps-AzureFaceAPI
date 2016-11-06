function Set-FaceList
{
    [CmdletBinding(DefaultParameterSetName="ByName")]
    param(
        [parameter(
            Mandatory=$true,
            Position=1,
            ParameterSetName='ByName'
            )]
        [string] $name
        ,
        [parameter(
            Mandatory=$true,
            ParameterSetName='ById'
        )]
        [string] $faceListId
        ,
        [parameter(Mandatory=$false)]
        [string] $newName
        ,
        [parameter(Mandatory=$false)]
        [string] $userData
        ,
        [parameter(Mandatory=$false)]
        [Switch] $Force
    )

    try {
        $currentFaceLists = Get-FaceList -name $name
    } catch [System.Exception] {
        throw "FaceList with name $name couldn't being retrieved" + $_.Exception.Message
    }

    if (($currentFaceLists | measure).count -ne 1 -and $Force -ne $true){
        throw "Multiple face lists with name $name found `nUse -Force to enable modification of multiple face lists with the same name"
    }

    foreach ($currentFaceList in $currentFaceLists){
        if ($newName -eq "") {$setName = $currentFaceList.name} 
        else {$setName = $newName}
        if ($userData -eq "") {$setUserData = $currentFaceList.userData}
        else {$setUserData = $userData} 
        if($faceListId -eq "") {$setId = $currentFaceList.faceListId}
        else {$setId = $faceListId}

        $Request = "https://api.projectoxford.ai/face/v1.0/facelists/$setId"
        $Body = "{`"name`":`"$setName`", `"userData`":`"$setUserData`" }"
        $Response = Invoke-MSCognitiveServiceRequest -Method 'PATCH' -Uri $Request -Body $Body
    }
}