#=================================================================================
# 
# This is a workaround script which can be used to get the running workflows
# in SCOM Health Service when the number of workflows are high and the default
# task in SCOM times out aftr 30 minutes
# 
# The script has a pre-requisites to get the workflow from the edb database                   
# using Stealth software.        
# 
# Below are the instructions:
# 1. Stop the MMA on the server.
# 2. Copy the HealthServiceStore.edb file from the installation directory. Like
#    Management Server : C:\Program Files\Microsoft System Center\Operations Manager\Server\Health Service State\Health Service Store
#    or Agent C:\Program Files\Microsoft Monitoring Agent\Agent\Health Service State\Health Service Store
# 3. Open the edb file in Stealth.
# 4. Navigate to the end on the left panel and expand WORKFLOW
# 5. Click on Records. Note the number in parenthesis.
# 6. Click on View -> Options -> Set the Mex Records to a number that you see under Records.
# 7. Click on Edit -> Select All.
# 8. Click on Edit -> Copy.
# 9. Paste the clipboard in Excel Sheet.
# 10. Delete all columns except D, L
# 11. Inset a new row at the top. Add the name of the columns as InstanceID and WorkflowName.
# 12. Save the file as .csv format.
# 13. Copy the file full path and run the script with that as parameter.
#
#Author:  Udishman Mudiar
# v 1.0
#
#=================================================================================

param(
    [Parameter(Mandatory=$True)]
           [String[]]$stealthcsvpath   
)

Write-Host "Getting running workflows of the health service. It might take several minutes depending on the number of workflows......" -ForegroundColor Yellow

Import-Module OperationsManager
$customobjs = Import-Csv -Path $stealthcsvpath
$InstanceIDs = $objs = @()
foreach($customobj in $customobjs){
    $workflow = $customobj.InstanceID.replace(' ','')
    $workflow = [System.Guid]::Parse($workflow).Guid
    $arrworkflow = $workflow.Split('-')
    $tmparrworkflow = $2bytes1 = $2bytes = @()
    #doing 3 iterations as only 3 octet needs to be reversred
    for($i = 0; $i -lt 3; $i++){
        for($j = 0; $j -lt $arrworkflow[$i].Length; $j+=2){
            $2bytes = $arrworkflow[$i].Substring($j,2)
            $2bytes1 = $2bytes + $2bytes1
        }
        $tmparrworkflow += $2bytes1 
        $2bytes1 = @()
    }
    $tmparrworkflow += $arrworkflow[3]
    $tmparrworkflow += $arrworkflow[4]

    $InstanceID = $tmparrworkflow[0] + "-" +  $tmparrworkflow[1] + "-" +  $tmparrworkflow[2] + "-" +  $tmparrworkflow[3] + "-" +  $tmparrworkflow[4]

    $instance = Get-SCOMClassInstance -Id $InstanceID

    $workflow = Get-SCOMRule -Name $customobj.WorkflowName -ErrorAction SilentlyContinue
    if(!$workflow){
        $workflow = Get-SCOMMonitor -Name $customobj.WorkflowName
        if(!$workflow){
            $workflow = Get-SCOMDiscovery -Name $customobj.WorkflowName
        }
    }

    $obj = [PSCustomObject]@{
        InstanceID = $instance.id
        InstanceDisplayName = $instance.DisplayName
        InstanceFullName = $instance.FullName
        InstanceName = $instance.Name
        WorkflowDisplayNameName = $workflow.DisplayName 
        WorkflowName = $workflow.Name
              
    }
    $objs += $obj
}

$objs | Sort-Object WorkflowDisplayNameName,InstanceName | Out-GridView
