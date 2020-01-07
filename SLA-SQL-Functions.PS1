

function SQLLogPurge {
param(
        [parameter(mandatory=$true)][string]$SCOPE="ALL"
)
if ($SCOPE -eq "ALL") {
foreach ($Instance in $SQLServers|%{$_[3]}) {
rdb "exec SP_MSforeachDB '
use [?];
dbcc shrinkfile(2,1)'" $Instance
}} else {
rdb "exec SP_MSforeachDB '
use [?];
dbcc shrinkfile(2,1)'" $SCOPE
}
}

function CheckSQLAgents() {
foreach($Instance in $SQLServers) {
if((Get-Service -cn $Instance[0] SQL*Agent*).status -eq 'Running' ) {
echo "Agent ok on $($Instance[0])..." } else {
Write-Host -ForegroundColor Red "PAU NO AGENT DO $($Instance[0])..." }
}
}


function DoSQLDBSvc{
param(
	[parameter(mandatory=$true)][string]$CN,
	[parameter(mandatory=$false)][string][ValidateSet("STATUS","STOP","START")]$ServiceACTION='STATUS',
	[parameter(mandatory=$false)][string][ValidateSet("Y","N")]$isVerbose='Y',
	[parameter(mandatory=$false)][string][ValidateSet("Y","N")]$Confirm='Y',
	[parameter(mandatory=$false)][string][ValidateSet("ALL","SQLBrowser","SQLWriter","SQLAgent","MSSQLServer")]$Service='ALL'
)
switch ($Service){
	"ALL"
		{ $SQLServicesNames=@("SQLBrowser","SQLWriter","SQLAgent`$*","MSSQL`$*") }
	"SQLBrowser"
		{ $SQLServicesNames=$Service }
	"SQLWriter"	
		{ $SQLServicesNames=$Service }
	"SQLAgent"	
		{ $SQLServicesNames="SQLAgent`$*" }	
	"MSSQLServer"
		{ $SQLServicesNames="MSSQL`$*" }
	default { $SQLServicesNames=@("SQLBrowser","SQLWriter","SQLAgent`$*","MSSQL`$*")}
}
### Function Write Error Message
function showmsg($msg) {
	if($isVerbose -eq 'Y') {
		Write-Host -ForegroundColor Red "$($msg)"
	}
}
function ConfirmAction {
	if($Confirm -eq 'Y') {
		$title    = "You are try to $($ServiceACTION) services on $($CN)"
		$question = 'Are you sure you want to proceed?'
		$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
		$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
		$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
		$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
		if ($decision -ne 0) {
			showmsg "Action Aborted!" ; Break;
		}
	}
}
switch($ServiceACTION){
	"STATUS" { 
		foreach($ServiceName in $SQLServicesNames) {
			try{ 
				get-service -cn $CN $ServiceName 
			} CATCH {
				showmsg "Error to show the $($CN) services status"
			}	
		}
	}
	"STOP" { 
		ConfirmAction;
		foreach($ServiceName in $SQLServicesNames) {
			try{ 
				get-service -cn $CN $ServiceName 
				get-service -cn $CN $ServiceName | stop-service
				get-service -cn $CN $ServiceName 
			} CATCH {
				showmsg "Error to show the $($CN) services status"
			}	
		}
	}
	"START" { 
		foreach($ServiceName in $SQLServicesNames) {
			try{ 
				get-service -cn $CN $ServiceName 
				get-service -cn $CN $ServiceName | start-service
				get-service -cn $CN $ServiceName 
			} CATCH {
				showmsg "Error to show the $($CN) services status"
			}	
		}
	}
	default { echo "Ilegal $(ServiceACTION) parameter value"; break}
}
}



function GetSQLServerHosts{
<#
    .SYNOPSIS
        This function access the DBMAP catalog via RestMethod and returns the sqlserver Hosts list.
    .DESCRIPTION
		This function accept 3 parameters which have already default values and are limited to a list on validade set. 
	.PARAMETER

	.OUTPUTS 
		SQLServer Database Hosts List
		
#>
param(
	[parameter(mandatory=$false)][string][ValidateSet("ALL","ACCEPTANCE","DEVELOPMENT","LABORATORY","PRODUCTION")]$ENVIRONMENT='ALL',
	[parameter(mandatory=$false)][string][ValidateSet("N","Y")]$DMZ='N',
	[parameter(mandatory=$false)][string][ValidateSet("ALL","LAB","READY","PHASE OUT","UNDER CONSTRUCTION","IN DECOMMISSION")]$STATUS='READY'
)
if ($ENVIRONMENT -eq "ALL") {
	(Invoke-RestMethod -Method Post -Uri "http://l3064t.br.scania.com:8080/DbMap/listDatabaseMap" -Body "technology=SQL SERVER&dmz=$($DMZ.REPLACE('Y','S'))&status=$($STATUS)").hostname|sort -u
} else {
	(Invoke-RestMethod -Method Post -Uri "http://l3064t.br.scania.com:8080/DbMap/listDatabaseMap" -Body "technology=SQL SERVER&environment=$($ENVIRONMENT)&dmz=$($DMZ.REPLACE('Y','S'))&status=$($STATUS)").hostname|sort -u
}
}




function CheckSQLAgents() {
foreach($Instance in $SQLServers) {
if((Get-Service -cn $Instance[0] SQL*Agent*).status -eq 'Running' ) {
echo "Agent ok on $($Instance[0])..." } else {
Write-Host -ForegroundColor Red "PAU NO AGENT DO $($Instance[0])..." }
}
}


Function ShowSQLInstUptime ($Instance) {
rdb 'SELECT sqlserver_start_time FROM sys.dm_os_sys_info;' $Instance
}