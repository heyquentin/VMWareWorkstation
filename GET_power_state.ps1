# Authentication and other API stuff
$Username = "yourusername"
$apiURL = "http://127.0.0.1:8697/api"
$Password = "yourpassword"

$authInfo = ("{0}:{1}" -f $Username,$Password)
$authInfo = [System.Text.Encoding]::UTF8.GetBytes($authInfo)
$authInfo = [System.Convert]::ToBase64String($authInfo)
$headers = @{Authorization=("Basic {0}" -f $authInfo)}

$contentStyle = "application/vnd.vmware.vmw.rest-v1+json"

# This gets the VM IDs and paths
$response = Invoke-RestMethod -Uri $apiURL/vms -Method Get -Headers $headers

# This puts the VM IDs to an array
$uuid = $response.id

# Counter for iterating over the $response.path array down below
$counter = 0

foreach ($vmid in $response.id) {
	Write-Host "Virtual Machine"
	# Concatenates the URL for getting the power state
	$entireurl = $apiURL + '/vms/' + $vmid + '/power'
	# Actually makes the API call for power state
	$powerstate = Invoke-RestMethod -Uri $entireurl -Method Get -Headers $headers
	# Writes out the path for the VM. Starts at array location 0 then increments the counter
	Write-Host "VM Path:" $response.path[$counter]
	$counter = $counter + 1
	# Writes out the VM ID
	Write-Host "VM ID:" $vmid
	# Writes out the power state of the VM
	Write-Host "Power State:" $powerstate.power_state
	Write-Host ""
}
