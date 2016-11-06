$personGroupId = "cpvr-faces"


# Create Person Group
$Body = "{ `"name`":`"$personGroupId`", `"userData`":`"This is a person group for CPVR`" }"

Invoke-RestMethod -Method 'GET' -Headers @{'Ocp-Apim-Subscription-Key' = $APIKey} -ContentType 'application/json' -Uri "https://api.projectoxford.ai/face/v1.0/persongroups?start=0&top=1000"

$personGroup = Invoke-RestMethod -Method 'GET' -Headers