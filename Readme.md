# ps-AzureFaceAPI
This is a full implementation of the Microsoft Azure Face API version 1.0 in Microsoft PowerShell.
This module was tested with PowerShell 5.0 on Windows 10, but should work on any plattform with PowerShell version 3.0 and higher.

## API Documentation
You find the complete API documentation under https://dev.projectoxford.ai/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236.
In the Documentation folder you will find the whole API documentation in Swagger format.
Every API call was implemented in PowerShell as a cmdlet. All parameters are available in PowerShell as well.

If you are not sure on how to use this module, have a look in the Tests files. They will illustrate how to call the Cmdlets.

## Installation
You can install this module as every other PowerShell module or import it directly from the cloned git repository.
To use this module, you will have to provide your API key to the Azure Face API. 
If you are new to Microsoft Azure or Microsoft Cognitive Services, you can sign-up for a free account here: https://www.microsoft.com/cognitive-services/en-us/sign-up.
To load your API key, you have to create a secrets.json file which looks like this:
``` 
{
    "APIKey": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}
```
You can use the following sequence from a PowerShell prompt to clone this module, initialize your own secrets.json file and load the module:
```
$yourAPIKey = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
git clone https://github.com/MLauper/ps-AzureFaceAPI.git
New-Item -Type File -Name .\ps-AzureFaceAPI\secrets.json -Value "{`"APIKey`":`"$yourAPIKey`"}"
Import-Module .\ps-AzureFaceAPI
```

## Testing
This module was tested with Pester-Tests (https://github.com/pester/Pester).

**All tests in this module are Integrationtests, that will connect to and modify data on your Azure Face API account.**

You can run all tests by invoking the following command. Depending on your PowerShell version, you might have to install Pester first. See the Pester GitHub page for more information about Pester.
```
Invoke-Pester .\ps-AzureFaceAPI
```

## Example usages
After loading this PowerShell module, you can use this module as described by the API documentation.
These examples assume that you have initialized your API key as described above.

Here are some example usages:

```powershell
# Create a person group
New-PersonGroup -personGroupId "persongroup-1"

# Add a person to the person group
New-Person "person-1" -personGroupId "persongroup-1"

# Add local pictures to the person
New-PersonFace -personName "person-1" -personGroupId "persongroup-1" -LocalImagePath "C:\MyPictures\Face_01.JPG"
New-PersonFace -personName "person-1" -personGroupId "persongroup-1" -LocalImagePath "C:\MyPictures\Face_02.JPG"
New-PersonFace -personName "person-1" -personGroupId "persongroup-1" -LocalImagePath "C:\MyPictures\Face_03.JPG"

# Start the training of the faces of the person group 
Start-PersonGroupTraining -personGroupId "persongroup-1"
# Wait for the training to be finished
While ($true) {
    $trainingStatus = Get-PersonGroupTrainingStatus "persongroup-1" | select -Last 1
    if ($trainingStatus.status -ne "notstarted" -and $trainingStatus.status -ne "running"){
        break
    } else {
        sleep 1
    }
}

# Detect the face on an image you would like to query
$unknownFace = Invoke-FaceDetection -localImagePath "C:\MyPictures\UnknownFace.JPG"

# Try to identify the face on a person in your person group
Invoke-IdentifyFaces -faceIds $unknownFace.faceId -personGroup "persongroup-1"
```