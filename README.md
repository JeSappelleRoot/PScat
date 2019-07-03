# PScat

Because of the lack of native tools in Windows to check open ports on remote host, unlike Unix system, I created a PowerShell script.

---

PScat allow you to check TCP and UDP ports with simple command line, and support FQDN hostname or ip address.

## TCP ports 

You can invoke script with the following syntax : 
```
PScat.ps1 -mode tcp -target www.google.com -port 443
```

![TCP](https://user-images.githubusercontent.com/52102633/60630273-c3dd7980-9df9-11e9-89db-e81474701ec4.png)

## UDP ports

You can invoke script with the following syntax : 
```
PScat.ps1 -mode udp -target 192.168.0.254 -port 53
```

![UDP](https://user-images.githubusercontent.com/52102633/60630279-c63fd380-9df9-11e9-8529-ae19de7f853c.png)

# Nota Bene about checking UDP ports

UDP transport is a stateless transport protocol. You can send data but you can't know if your datagram has been received well.  
So, PScat can says a UDP port as closed like a false positive. In this case, you need other tools to check this port. 