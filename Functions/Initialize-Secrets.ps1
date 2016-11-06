function Initialize-Secrets
{
    param(
        [parameter(Mandatory=$false)]
        [string]$SecretJSON = "./secrets.json"
    )

    try {
        $secrets = Get-Content $SecretJSON
        $objSecrets = $secrets | ConvertFrom-Json
    } catch [System.Exception] {
        throw "Error loading secrets `n" + $_.Exception.Message
    }

    try {
        $Script:ApiKey = $objSecrets.APIKey
        if($Script:ApiKey -eq $null){
            throw "ApiKey not set"
         }
    } catch [System.Exception] {
        throw "Missing or Invalid secrets property`n" + $_.Exception.Message
    }
}