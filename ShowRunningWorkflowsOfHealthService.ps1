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

    $obj = [PSCustomObject]@{
        InstanceID = $instance.id
        InstanceDisplayName = $instance.DisplayName
        InstanceFullName = $instance.FullName
        InstanceName = $instance.Name
        WorkflowName = $customobj.WorkflowName       
    }

    $objs += $obj
}

$objs | Sort-Object WorkflowName,InstanceName | Out-GridView
