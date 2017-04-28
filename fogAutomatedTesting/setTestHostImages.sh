#!/bin/bash

cwd="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$cwd/settings.sh"


#Get the image ID.
if [[ -z $1 ]]; then
    echo "$(date +%x_%r) No image ID passed for argument 1, exiting." >> $output 
    exit 1
else
    imageID=$1
fi


#Get the host IDs.
if [[ -z $2 ]]; then
    echo "$(date +%x_%r) No host IDs passed for argument 2, exiting." >> $output
    exit 1
else
    hostIDs=$2
fi



#Set all the fog hosts to the same image.
curl -ku "$testServerWebCredentials" --header "content-type: application/json" --header "fog-api-token: $testServerApiToken" http://${testServerIP}/fog/image/${imageID}/edit --data "{\"hosts\": [${hostIDs}]}"



#`/fog/image/<IDOFIMAGE>/edit`
#
#```{
#    "hosts": [1,2,3]
#}```




