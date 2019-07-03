param(
    # Adding argument to command line
    [string]$target,
    [int]$port,
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
    $udpSocket.Send($bytes, $bytes.Length) | Out-Null
    
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

function checkArgs($arguments) {
# Function to check command line args

<#
The parameter of the function take $PsBoundParameters which contains arguments
The $arguments variable begin a classic dictionnary (Key and associated Value)
#>
    # Get value of keys with a simple parsing
    $target = $arguments['target']
    $port = $arguments['port']
    $mode = $arguments['mode']

    # Write somes examples in case of wrong command line
    $example = '
    Examples : 
    - TCP check : PScat.ps1 -target server.company.com -mode tcp -port 80
    - UDP check : PScat.ps1 -target server.company.com -mode udp -port 161
    '

    # If $target is empty
    if (-not($target)) {
        Write-Host "[!] Please specify a host destination with -target argument" -ForegroundColor Yellow
        $example
        Exit
    }
    # Else if $port is empty
    elseif (-not($port)) {
        Write-Host "[!] Please specify a port with -port argument" -ForegroundColor Yellow
        $example
        Exit
    }
    # Else if port is lower than 1 or greater than 65535 (min & max in network port range)
    elseif ($port -lt 1 -or $port -gt 65535) {
        Write-Host "[!] Please specify a port between 1 and 65535" -ForegroundColor Yellow
        $example
        Exit
    }
    # Else if the $mode variable get wrong string
    elseif ($mode -ne 'tcp' -and $mode -ne 'udp') {
        Write-Host "[!] Please specify mode with [udp] or [tcp]" -ForegroundColor Yellow
        $example
        Exit
    }

    return
}


# ------------------------------------------------------
# ------------------- Begin of PScat -------------------
# ------------------------------------------------------

# Display funny banner with Freddy cat ! 
displayBanner

# Check arguments gived in command line
checkArgs $PsBoundParameters


# Get value from $PSBoundParameters dictionnary 
$target = $PSBoundParameters['target']
$port = $PSBoundParameters['port']
$mode = $PSBoundParameters['mode']

# Switch between mode
switch ($mode) {
	'tcp' {checkTcp $target $port}
	'udp' {checkUdp $target $port}
}



