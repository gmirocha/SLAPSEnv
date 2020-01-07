## General Windows Functions
## Internal Functions
function WMIDateStringToDate($Bootup=$Bootup) {  
    [System.Management.ManagementDateTimeconverter]::ToDateTime($Bootup)  
}  
##

###################################################################################################################
# UPTIME
###################################################################################################################
function SLA-ShowUpTime($CN=$(hostname)) {
$computers = $(get-WmiObject Win32_OperatingSystem -cn $CN) 
  
foreach ($system in $computers) {  
    $Bootup = $system.LastBootUpTime  
    $LastBootUpTime = WMIDateStringToDate($Bootup)  
    $now = Get-Date  
    $Uptime = $now - $lastBootUpTime  
    $d = $Uptime.Days  
    $h = $Uptime.Hours  
    $m = $uptime.Minutes  
    $ms= $uptime.Milliseconds  
  
    "$($CN): System Up for: {0} days, {1} hours, {2}.{3} minutes" -f $d,$h,$m,$ms  
}   
}

###################################################################################################################
# GetNewPass
###################################################################################################################

$VM_SPECIAL=@('_')
$VM_NUMBERS=@(0..9)
$VM_UPCHARS=@(0..25)
$VM_LOCHARS=@(0..25)
for($i=0;$i -le 25;$i++) {$VM_UPCHARS[$i]=[CHAR]$($i+65); $VM_LOCHARS[$i]=[CHAR]$($i+97);}

$VM_MATRIX=@($VM_SPECIAL,$VM_NUMBERS,$VM_UPCHARS,$VM_LOCHARS)

function SLA-GetNewPass() {
$NEW_PASS=$VM_UPCHARS[$(Get-Random $VM_UPCHARS.Count)]
$NEW_PASS+=$VM_SPECIAL[$(Get-Random $VM_SPECIAL.Count)]
$NEW_PASS+=$VM_NUMBERS[$(Get-Random $VM_NUMBERS.Count)]
$NEW_PASS+=$VM_LOCHARS[$(Get-Random $VM_LOCHARS.Count)]

for($i=0;$i -le 21;$i++) {
$tmp1=$(Get-Random 4)
$tmp2=$VM_MATRIX[$tmp1].count
$NEW_PASS+=$VM_MATRIX[$tmp1][$(Get-Random $tmp2)]
}
$NEW_PASS
}

###################################################################################################################
# ShowAllInfo
###################################################################################################################
Function SLA-ShowCPU([string]$cnvar='localhost') {
$X=Get-WmiObject win32_processor -Cn $cnvar | select Name,LoadPercentage,NumberOfCores
$X	
}

Function SLA-ShowMemoryAndCPU([string]$cnvar='localhost') {
$X=Get-WmiObject win32_computersystem -Cn $cnvar | select TotalPhysicalMemory,NumberOfLogicalProcessors,NumberOfProcessors,@{Name='Memory in GB';expression={($_.TotalPhysicalMemory/1024/1024/1024).tostring("00.00GB")}}
$X
}

Function SLA-ShowOS([string]$cnvar='localhost') {
$X=(Get-WmiObject Win32_OperatingSystem -Cn $($cnvar)).Caption
$X
}
Function SLA-ShowDisk([string]$cnvar='localhost') {
$X=get-WmiObject win32_logicaldisk -cn $cnvar |?{$_.size -ne $null } | Select Name,VolumeName,Size,FreeSpace,@{name="PCTFREE";Expression={(100/$_.size*$_.freespace).tostring('0.00')}},@{name="PCTUSED";Expression={(($_.size-$_.freespace)/$_.size*100).tostring('0.00')}} , @{name="SIZEGB";Expression={"{0:N2} GB" -f ($_.size/1024/1024/1024) }} ,@{name="FSGB";Expression={"{0:N2} GB" -f ($_.FreeSpace/1024/1024/1024)}},@{name="USEDGB";Expression={"{0:N2} GB" -f (($_.size-$_.FreeSpace)/1024/1024/1024)}}
$X|ft
}


Function SLA-ShowAllInfo([string]$thiscnvar='localhost') {
$LN="-------------------------------------------------------------------------------------------"

Write-host -ForegroundColor BLUE "$LN"
Write-host -ForegroundColor CYAN "-- Information of $thiscnvar "
Write-host -ForegroundColor BLUE "$LN"
Write-host "Getting CPU Info... $thiscnvar "
SLA-ShowOS  $thiscnvar|ft ;
SLA-ShowCPU $thiscnvar|ft ;
Write-host -ForegroundColor BLUE "$LN"
Write-host "Getting Memory Info... $thiscnvar"
SLA-ShowMemoryAndCPU $thiscnvar ;
Write-host -ForegroundColor BLUE "$LN"
Write-host "Getting Disk Info... $thiscnvar"
SLA-ShowDisk $thiscnvar|ft ;
Write-host -ForegroundColor BLUE "$LN"
}

###################################################################################################################
# ShowLocalAdmin
###################################################################################################################
Function SLA-ShowLocalAdmin($CN=$(localhost)) {
    $GLOBAL:AdminMembers=New-Object System.Collections.ArrayList
    $admins = Gwmi win32_groupuser –computer $CN
    $admins = $admins |? {$_.groupcomponent –like '*"Administrators"'}
    $admins |% {
        $_.partcomponent -match ".+Domain\=(.+)\,Name\=(.+)$" > $nul
        $temp = New-Object System.Object
        $temp | Add-Member -MemberType NoteProperty -Name "Hostname" -Value $CN
        $temp | Add-Member -MemberType NoteProperty -Name "Domain" -Value $matches[1].trim('"')
        $temp | Add-Member -MemberType NoteProperty -Name "UserOrGroup" -Value $matches[2].trim('"')
        $temp | Add-Member -MemberType NoteProperty -Name "Member" -Value $($matches[1].trim('"') + '\' + $matches[2].trim('"'))
        $GlOBAL:AdminMembers.add($temp)|Out-Null
    }
    $AdminMembers
}

###################################################################################################################
# xxxx 
###################################################################################################################
