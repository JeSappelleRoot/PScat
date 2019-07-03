param(
    [string]$target,
    [string]$port,
    [string]$mode
)



function displayBanner() {
# A cool banner with fluffy Freddy !

    Clear-Host

    '
     _____   _____           _   
    |  __ \ / ____|         | |  
    | |__) | (___   ___ __ _| |_     |\=/|
    |  ___/ \___ \ / __/ _` | __|    /6 6\   _  
    | |     ____) | (_| (_| | |_    =\_Y_/= ((
    |_|    |_____/ \___\__,_|\__|    / ^ \   ))
                                    /| | |\ //
                                    ( | | | )/
                                    `"" ""`
                                                                
    '

    return
}


function checkTcp($ip,$port) {
# Function to check TCP connection

    # Initialize a TCP socket via Net object
    $tcpSocket = New-Object Net.Sockets.TcpClient

    # Basic try/catch
    try {$tcpSocket.Connect($target,$port)}
    catch {}
    # If TCP connection is established display success message and close socket
    if ($tcpSocket.Connected) {
        Write-Host "[+] TCP connection to $ip on port $port successfull" -ForegroundColor Green
        $tcpSocket.Close()
    }
    # Else not, display a failure message
    else {Write-Host "[!] Can't established an TCP connection to $ip on port $port" -ForegroundColor Yellow}
    
    return
}

function checkUdp($ip,$port) {
# Function to check UDP connection

    # Initialize a UDP socket via Net object
    $udpSocket = New-Object Net.Sockets.UdpClient
    #Set UDP client timeout
    $udpSocket.client.ReceiveTimeout = 2000
    #Launch UDP connection
    $udpSocket.Connect($ip,$port)

    # Initialize an ASCII encoder to convert String <---> Bytes
    $asciiEncoder = New-Object System.Text.AsciiEncoding
    #Get bytes from string
    $bytes = $asciiEncoder.GetBytes("Knock Knock Neo...follow the white rabbit")
    #Send bytes through UDP socket
    $udpSocket.Send($bytes, $bytes.Length)
    
    # Initialize a listener to get the answer of remote target
    $remoteEndpoint = New-Object system.net.ipendpoint([system.net.ipaddress]::Any,0)
    
    # Basic try/catch
    try {
        # Receive bytes by remote target ?
        $receiveBytes = $udpSocket.Receive([ref]$remoteEndpoint)
        # Decode bytes to string
        $returnData = $asciiEncoder.GetString($receiveBytes)
    }
    catch {}

    # If data are returned by udpSocket display success message and close socket
    if ($returnData) {
        Write-Host "[+] UDP connection to $ip on port $port seems to be successfull" -ForegroundColor Green
        $udpSocket.Close()     
    }
    # Else not, display a failure message
    else {Write-Host "[!] Can't established an UDP connection to $ip on port $port" -ForegroundColor Yellow}


    return
}


# ------------------------------------------------------
# ------------------- Begin of PScat -------------------
# ------------------------------------------------------

# Display funny banner with Freddy cat ! 
displayBanner



$target = '192.168.8.24'
$port = 24
$mode = 'tcp'

switch ($mode) {
    'tcp' {checkTcp $target $port}
    'udp' {checkUdp $target $port}
}



