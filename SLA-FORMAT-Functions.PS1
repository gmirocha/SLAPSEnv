
Function MySetTerm() {
param(
    [parameter(Mandatory=$TRUE)]
    [ValidateSet("REGULAR","DEV","QA","PROD","SAVE","RESTORE")]
    $SCHEMA="REGULAR"
)

$Host.UI.RawUI.BackgroundColor = ($bckgrnd = 'BLACK')
$Host.PrivateData.ErrorBackgroundColor = $bckgrnd
$Host.PrivateData.WarningBackgroundColor = $bckgrnd
$Host.PrivateData.DebugBackgroundColor = $bckgrnd
$Host.PrivateData.VerboseBackgroundColor = $bckgrnd
$Host.PrivateData.ProgressBackgroundColor = $bckgrnd

switch ($SCHEMA) {
    "REGULAR" {
        $Host.UI.RawUI.ForegroundColor = 'White'
        $Host.PrivateData.ErrorForegroundColor = 'Red'
        $Host.PrivateData.WarningForegroundColor = 'Magenta'
        $Host.PrivateData.DebugForegroundColor = 'Yellow'
        $Host.PrivateData.VerboseForegroundColor = 'Green'
        $Host.PrivateData.ProgressForegroundColor = 'Cyan'
    } # END REGULAR

    "DEV" {
        $Host.UI.RawUI.ForegroundColor = 'Green'
        $Host.PrivateData.ErrorForegroundColor = 'Red'
        $Host.PrivateData.WarningForegroundColor = 'Magenta'
        $Host.PrivateData.DebugForegroundColor = 'Yellow'
        $Host.PrivateData.VerboseForegroundColor = 'White'
        $Host.PrivateData.ProgressForegroundColor = 'Cyan'
    
    } #END DEV
    
    "QA" {
        $Host.UI.RawUI.ForegroundColor = 'Yellow'
        $Host.PrivateData.ErrorForegroundColor = 'Red'
        $Host.PrivateData.WarningForegroundColor = 'Magenta'
        $Host.PrivateData.DebugForegroundColor = 'White'
        $Host.PrivateData.VerboseForegroundColor = 'Green'
        $Host.PrivateData.ProgressForegroundColor = 'Cyan'
    } #END QA
    
    "PROD" {
        $Host.UI.RawUI.ForegroundColor = 'Red'
        $Host.PrivateData.ErrorForegroundColor = 'White'
        $Host.PrivateData.WarningForegroundColor = 'Magenta'
        $Host.PrivateData.DebugForegroundColor = 'Yellow'
        $Host.PrivateData.VerboseForegroundColor = 'Green'
        $Host.PrivateData.ProgressForegroundColor = 'Cyan'
    } #END PROD
    
    "SAVE" {
        $GLOBAL:MyHost=$Host
    } #END SAVE
    
    "RESTORE" {
        $Host.UI.RawUI.BackgroundColor              =   $GLOBAL:MyHost.UI.RawUI.BackgroundColor           
        $Host.UI.RawUI.ForegroundColor              =   $GLOBAL:MyHost.UI.RawUI.ForegroundColor           
        $Host.PrivateData.ErrorForegroundColor      =   $GLOBAL:MyHost.PrivateData.ErrorForegroundColor   
        $Host.PrivateData.ErrorBackgroundColor      =   $GLOBAL:MyHost.PrivateData.ErrorBackgroundColor   
        $Host.PrivateData.WarningForegroundColor    =   $GLOBAL:MyHost.PrivateData.WarningForegroundColor 
        $Host.PrivateData.WarningBackgroundColor    =   $GLOBAL:MyHost.PrivateData.WarningBackgroundColor 
        $Host.PrivateData.DebugForegroundColor      =   $GLOBAL:MyHost.PrivateData.DebugForegroundColor   
        $Host.PrivateData.DebugBackgroundColor      =   $GLOBAL:MyHost.PrivateData.DebugBackgroundColor   
        $Host.PrivateData.VerboseForegroundColor    =   $GLOBAL:MyHost.PrivateData.VerboseForegroundColor 
        $Host.PrivateData.VerboseBackgroundColor    =   $GLOBAL:MyHost.PrivateData.VerboseBackgroundColor 
        $Host.PrivateData.ProgressForegroundColor   =   $GLOBAL:MyHost.PrivateData.ProgressForegroundColor
        $Host.PrivateData.ProgressBackgroundColor   =   $GLOBAL:MyHost.PrivateData.ProgressBackgroundColor
    }  #END RESTORE
}#end Switch    
}



