# Find NVIDIA GPU and get InstanceId
$devName = $null
Get-PnpDevice | ForEach-Object {
    if($_ -match 'NVIDIA') {
        $devName = $_ | Select-Object -ExpandProperty InstanceId
        Write-Output $devName
    }
} | Select-Object -First 1

# If we don't have an NVIDIA GPU installed, quit the script.
if ($null -eq $devName) {
    break
}

# Set registry path based on InstanceId found above.
$RegistryPath = 'HKLM:\SYSTEM\CurrentControlSet\Enum\' + $devName + '\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties'
$Name         = 'MSISupported'
$Value        = '1'

# Create the MessageSignaledInterruptProperties key if it does not exist (which is probable if MSI hasn't been enabled in the past)
if (-NOT (Test-Path $RegistryPath)) {
  New-Item -Path $RegistryPath -Force | Out-Null
}

#Set MSISupported to 1
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force
