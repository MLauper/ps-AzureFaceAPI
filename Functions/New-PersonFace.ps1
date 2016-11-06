function New-PersonFace
{
    param(
        [parameter(
            Mandatory=$true,
            ParameterSetName='byPersonNameAndLocalImage'
            )]
        [parameter(
            Mandatory=$true,
            ParameterSetName='byPersonNameAndImageUrl'
            )]
        [string] $personName
        ,
        [parameter(
            Mandatory=$true,
            ParameterSetName='byPersonIdAndLocalImage'
            )]
        [parameter(
            Mandatory=$true,
            ParameterSetName='byPersonIdAndImageUrl'
            )]
        [string] $personId
        ,
        [parameter(Mandatory=$true)]
        [string] $personGroupId
        ,
        [parameter(Mandatory=$false)] 
        [string] $userData = ""
        ,
        # Location of the target face (exactly one), give a list with left, top, width, heigth
        [parameter(Mandatory=$false)]
        [System.Collections.ArrayList] $targetFace
        ,
        [parameter(
            Mandatory=$true,
            ParameterSetName='byPersonNameAndLocalImage'
        )]
        [parameter(
            Mandatory=$true,
            ParameterSetName='byPersonIdAndLocalImage'
        )]
        [ValidateScript({Test-Path $_ -PathType Leaf})]
        [string]$localImagePath
        ,
        [parameter(
            Mandatory=$true,
            ParameterSetName='byPersonNameAndImageUrl'
        )]
        [parameter(
            Mandatory=$true,
            ParameterSetName='byPersonIdAndImageUrl'
        )]
        [string]$ImageUrl
    )

    if ($targetFace -ne $null -and $targetFace.count -ne 4){
        throw "Illegal paramter value for targetFace. Please provide a list with left, top, width and height"
    }

    if ($PsCmdlet.ParameterSetName -like 'byPersonName*') {
        $person = Get-Person $personName -personGroupId $personGroupId
    } elseif ($PsCmdlet.ParameterSetName -like 'byPersonId*') {
        $person = Get-Person -id $personId -personGroupId $personGroupId
    }
    
    $Request = "https://api.projectoxford.ai/face/v1.0/persongroups/$personGroupId/persons/$($person.personId)/persistedFaces?userData=$userData"
    if ($targetFace -ne $null) {$Request = $Request + "&$($targetFace[0]),$($targetFace[1]),$($targetFace[2]),$($targetFace[3])"}
    
    if ($PsCmdlet.ParameterSetName -like '*LocalImage') {
        $Response = Invoke-MSCognitiveServiceRequest -Method 'POST' -Uri $Request -inFile $localImagePath -ContentType "application/octet-stream"
    } elseif ($PsCmdlet.ParameterSetName -like '*ImageUrl') {
        $Body = "{ `"url`":`"$ImageUrl`" }"
        $Response = Invoke-MSCognitiveServiceRequest -Method 'POST' -Uri $Request -Body $Body
    }
    
}