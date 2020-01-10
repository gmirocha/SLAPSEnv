#######################################################################################
# SLA-GetSQLServerHosts
#######################################################################################
function SLA-GetOracleHosts{
<#
    .SYNOPSIS
        This function access the DBMAP catalog via RestMethod and returns the sqlserver Hosts list.
    .DESCRIPTION
		This function accept 4 parameters which have already default values and are limited to a list on validade set. 
	.PARAMETER
	.OUTPUTS 
		Oracle Database Hosts List
		
#>
param(
	[parameter(mandatory=$false)][string][ValidateSet("ALL","ACCEPTANCE","DEVELOPMENT","LABORATORY","PRODUCTION")]$ENVIRONMENT='ALL',
	[parameter(mandatory=$false)][string][ValidateSet("N","Y")]$DMZ='N',
	[parameter(mandatory=$false)][string][ValidateSet("ALL","LAB","READY","PHASE OUT","UNDER CONSTRUCTION","IN DECOMMISSION")]$STATUS='READY',
	[parameter(mandatory=$false)][string][ValidateSet("SEU","SLA")]$SITE='SLA'
)
if ($ENVIRONMENT -eq "ALL") {
	(Invoke-RestMethod -Method Post -Uri "http://l3064t.br.scania.com:8080/DbMap/listDatabaseMap" -Body "technology=Oracle&site=$($SITE)&dmz=$($DMZ.REPLACE('Y','S'))&status=$($STATUS)").hostname|sort -u
} else {
	(Invoke-RestMethod -Method Post -Uri "http://l3064t.br.scania.com:8080/DbMap/listDatabaseMap" -Body "technology=Oracle&site=$($SITE)&environment=$($ENVIRONMENT)&dmz=$($DMZ.REPLACE('Y','S'))&status=$($STATUS)").hostname|sort -u
}
}
