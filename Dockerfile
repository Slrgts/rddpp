FROM mcr.microsoft.com/windows

RUN powershell Invoke-WebRequest https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip -OutFile ngrok.zip

RUN powershell Expand-Archive ngrok.zip

ARG ngrokid

RUN powershell $env:NGROK_AUTH_TOKEN="${ngrokid}"

RUN powershell .\ngrok\ngrok.exe authtoken $env:NGROK_AUTH_TOKEN

RUN powershell Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0

RUN powershell Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

RUN powershell Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1

RUN powershell Set-LocalUser -Name "runneradmin" -Password (ConvertTo-SecureString -AsPlainText "P@ssw0rd!" -Force)

EXPOSE 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306 3389

RUN powershell .\ngrok\ngrok.exe tcp 3389