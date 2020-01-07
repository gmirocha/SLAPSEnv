# SLAPSEnv
SLA Power Shell Environment 
These functions will help-us to adm all our databases and environment.

## To Setup:

Download the *Main.PS1* file and set it on Powershell (as adm account).

```
> . ./Main.PS1
```
Run the function bellow to download all files and packages.
```
> DownloadFilesFromRepo -Owner gmirocha -Repository SLAPSEnv  -DestinationPath c:\users\public\SLAPSEnv
```

## Update your $PROFILE 
```
>> ". c:\users\public\SLAPSEnv\Main.PS1" >> $PROFILE
```



