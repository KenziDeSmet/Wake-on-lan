function Send-WakeOnLan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$MacAddress,

        [string]$BroadcastAddress = "192.168.0.255", # Change to use your own broadcast address
        [int]$Port = 9
    )

    $MacBytes = $MacAddress -split '[\-:]' | ForEach-Object { [byte]('0x' + $_) }
    $MagicPacket = (,[byte]0xFF * 6) + ($MacBytes * 16)
    
    $UdpClient = New-Object System.Net.Sockets.UdpClient
    $UdpClient.Connect($BroadcastAddress, $Port)
    $UdpClient.Send($MagicPacket, $MagicPacket.Length)
    $UdpClient.Close()

    Write-Host ("Wake On LAN signal sent to {0} via {1} on port {2}" -f $MacAddress, $BroadcastAddress, $Port)
}

$devices = @(
    @{ Name = "Device Name"; MAC = "XX:XX:XX:XX:XX:XX" } # Change to use your own mac address and device name
)

function Show-Menu {
    param(
        [int]$selectedIndex = 0
    )
    
    Clear-Host
    Write-Host "Select a device to wake up:" -ForegroundColor Cyan
    for ($i = 0; $i -lt $devices.Count; $i++) {
        if ($i -eq $selectedIndex) {
            Write-Host " > $($devices[$i].Name) - $($devices[$i].MAC)" -ForegroundColor Blue
        } else {
            Write-Host "   $($devices[$i].Name) - $($devices[$i].MAC)"
        }
    }
}

$selectedIndex = 0
$done = $false

while (-not $done) {
    Show-Menu -selectedIndex $selectedIndex
    $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
    
    if ($key -eq 38 -and $selectedIndex -gt 0) { $selectedIndex-- }
    elseif ($key -eq 40 -and $selectedIndex -lt ($devices.Count - 1)) { $selectedIndex++ }
    elseif ($key -eq 13) { $done = $true }
}

$selectedDevice = $devices[$selectedIndex]
Send-WakeOnLan -MacAddress $selectedDevice.MAC
