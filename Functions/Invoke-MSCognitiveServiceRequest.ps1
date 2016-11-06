function Invoke-MSCognitiveServiceRequest 
{
    param(
        [parameter(Mandatory=$false)]
        [string] $APIKey
        ,
        [parameter(Mandatory=$true)]
        [string] $Method
        ,
        [parameter(Mandatory=$true)]
        [string] $Uri
        ,
        [parameter(Mandatory=$false)]
        [string] $Body
        ,
        [parameter(Mandatory=$false)]
        [ValidateScript({Test-Path $_ -PathType Leaf})]
        [string] $inFile
        ,
        [parameter(Mandatory=$false)]
        [string] $ContentType = 'application/json'
    )

    if ($Script:ApiKey -eq $Null){
        Write-Verbose "No API Key is initialized, load secrets..."
        Initialize-Secrets
    }

    if($inFile -ne "" -and $Body -ne ""){
        throw "Combination of -inFile and -Body is not supported."
    }

    try {
        if ($Method -like 'GET'){
            $response = Invoke-RestMethod -Method $Method -Headers @{'Ocp-Apim-Subscription-Key' = $Script:ApiKey} -ContentType $contentType -Uri $Uri
        } else {
            if ($inFile -ne ""){
                $response = Invoke-RestMethod -Method $Method -Headers @{'Ocp-Apim-Subscription-Key' = $Script:ApiKey} -ContentType $contentType -Uri $Uri -inFile $inFile
            } else {
                $response = Invoke-RestMethod -Method $Method -Headers @{'Ocp-Apim-Subscription-Key' = $Script:ApiKey} -ContentType $contentType -Uri $Uri -Body $Body
            }
        }
    }
    catch [System.Exception] {
        $errorObj = $_ | ConvertFrom-Json
        throw "API Request failed `nMethod: $Method `nAPIKey: $Script:ApiKey `nContent-Type: $ContentType `nUri: $Uri `nBody: $Body `n" + "Error Code: $($errorObj.error.code) `nError Message: $($errorObj.error.message)`n" + $_.Exception.Message

    }

    return $response
}