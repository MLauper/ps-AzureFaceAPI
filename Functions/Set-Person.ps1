function Set-Person
{
    param(
        [parameter(
            Mandatory=$true,
            Position=1
            )]
        [string] $name
        ,
        [parameter(Mandatory=$true)]
        [string] $personGroupId
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
        $currentPersons = Get-Person -name $name -personGroupId $personGroupId
    } catch [System.Exception] {
        throw "Person with name $name in group $personGroupId couldn't being retrieved" + $_.Exception.Message
    }

    if (($currentPersons | measure).count -ne 1 -and $Force -ne $true){
        throw "Multiple persons with name $name found in person group $personGroupId `nUse -Force to enable modification of multiple persons with the same name"
    }

    foreach ($currentPerson in $currentPersons){
        if ($newName -eq "") {$setName = $currentPerson.name} 
        else {$setName = $newName}
        if ($userData -eq "") {$setUserData = $currentPerson.userData}
        else {$setUserData = $userData} 

        $Request = "https://api.projectoxford.ai/face/v1.0/persongroups/$personGroupId/persons/$($currentPerson.personId)"
        $Body = "{`"name`":`"$setName`", `"userData`":`"$setUserData`" }"
        $Response = Invoke-MSCognitiveServiceRequest -Method 'PATCH' -Uri $Request -Body $Body
    }
}