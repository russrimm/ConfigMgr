
<# 
This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment.  
THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED AS IS WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  
We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, 
provided that You agree: (i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; (ii) to include a 
valid copyright notice on Your software product in which the Sample Code is embedded; and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from 
and against any claims or lawsuits, including attorneys’ fees, that arise or result from the use or distribution of the Sample Code.
#>

Param (
    $Priority = 100,
    $DPName = "fs01.contoso.com",
    $SiteCode = "PRI"
)

function Get-ProprityValue {

    $dpClass = Get-WmiObject -Namespace root\sms\site_$SiteCode -Query $query

    foreach ($dpInstance in $dpClass) {
        # Using the __PATH property, obtain a direct reference to the instance
        $wmiPath = [wmi]"$($dpInstance.__PATH)"

        foreach ($item in $wmiPath) {
     
            $props = $item.Props
            $prop = $props | Where-Object { $_.PropertyName -eq 'Priority' }

            Write-Host ("Priority value is: {0} " -f $prop.value)
        }
    }
}

$query = "Select * From SMS_SCI_SysResUse where RoleName='SMS Distribution Point' and NetworkOsPath='\\\\{0}'" -f $DPName
$dpClass = Get-WmiObject -Namespace root\sms\site_$SiteCode -Query $query

foreach ($dpInstance in $dpClass) {
    # Using the __PATH property, obtain a direct reference to the instance
    $wmiPath = [wmi]"$($dpInstance.__PATH)"

   
    foreach ($item in $wmiPath) {
    
        $props = $item.Props
        $prop = $props | Where-Object { $_.PropertyName -eq 'Priority' }

        Get-PriorityValue

        $prop.Value = $Priority
        $item.Props = $props
        $item.Put()

        Get-PriorityValue 

    }
}
