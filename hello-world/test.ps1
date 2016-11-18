
$logloc = "C:\Cloud\Dropbox\0Comp\Storage_Spaces\Logs\sslog.txt"

# Check for existance of log file
if ($query -eq "False"){
new-item -path "C:\Cloud\Dropbox\UniversalComputerSTuff\Storage_Spaces\Logs" -name sslog.txt -type "file"
}

Function Get-Health

#Function to get disk health information

{

$Pdisk= Get-PhysicalDisk
$healthstats = @()
ECHO "----------------------------------------------------------------------------"|Add-Content $logloc
Start-Sleep -s 1
Get-Date |Add-Content $logloc
Start-Sleep -s 1
ECHO "----------------------------------------------------------------------------"|Add-Content $logloc
Get-PhysicalDisk | Out-File -FilePath $logloc -Append
Start-Sleep -s 5
ECHO "----------------------------------------------------------------------------"|Add-Content $logloc
ECHO "Statistics"|Add-Content $logloc
ECHO "----------------------------------------------------------------------------"|Add-Content $logloc

Start-Sleep -s 1

ForEach ( $LDisk in $PDisk )

                {

                $healthstats += $LDisk.FriendlyName

                $healthstats += $LDisk.HealthStatus

                $healthstats += $CurrentDisk = $LDisk | Get-StorageReliabilityCounter | Select-Object DeviceID, PowerOnHours, Temperature, ReadErrorsTotal, WriteErrorsTotal, ReadErrorsUncorrected, WriteErrorsUncorrected, ReadLatencyMax, WriteLatencyMax, FlushLatencyMax, LoadUnloadCycleCount, Wear

                $healthstats += "======================="

                If ($CurrentDisk.Temperature -GT 35 -OR $CurrentDisk.ReadErrorsTotal -GT 0 -OR $_.CurrentDisk -GT 0){

                                $LDisk.FriendlyName

                                $LDisk.HealthStatus

                                $LDisk | Get-StorageReliabilityCounter | Select-Object DeviceID, PowerOnHours, Temperature, ReadErrorsTotal, WriteErrorsTotal, ReadErrorsUncorrected, WriteErrorsUncorrected, ReadLatencyMax, WriteLatencyMax, FlushLatencyMax, LoadUnloadCycleCount, Wear | FL

                                Write-Host ================== }

                                $Body1 = ‘A disk health problem has been detected on disk ‘

                                $Body2 = $LDisk.FriendlyName

                                $Body3 = ‘. The health status is: ‘

                                $Body4 = $LDisk.HealthStatus

                                $Body = $Body1 + $Body2 + $Body3 + $Body4

                                #Send-Notice($Body)
                }

                $healthstats | Out-String | Add-Content $logloc
                

}



Function Get-Smart

#Function to get disk SMART information

{

$Smart = Get-WmiObject -namespace root\wmi –class MSStorageDriver_FailurePredictStatus -ComputerName $Input

If ($Smart.PredictFailure -EQ $True) {

               
                $Smart | Select-Object PSComputerName, InstanceName, PredictFailure, Reason

                $Body='SMART has predicted a failure. '

                $Body2 = $Smart.PSComputerName

                $Body3 = $Smart.InstanceName

                $Body4 = $Smart.PredictFailure

                $Body5 = $Smart.Reason

                $Body = $Body + $Body2 + $Body3 + $Body4 + $Body5

                #Send-Notice($Body)
}

}


Function Send-Notice($Body)

#Function to send E-mail notification of a problem

{

$EmailTo = "Administrator@poseydemo.com"

$EmailFrom = "Administrator@poseydemo.com"

$Subject = "Test"

$SMTPServer = "E2K13.poseydemo.com"

 

$Username = "poseydemo\Administrator"

$Password = Get-Content c:\scripts\cred.txt | ConvertTo-SecureString

$Cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password

 

Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $Subject -Body $Body -Credential $Cred -SMTPServer $smtpserver

}

$Servers = "."

#ForEach ($Server in $Servers) {

#Enter-PSSession -ComputerName $Servers

Get-Health

#Exit-PSSession

$Servers | Get-Smart



#}
