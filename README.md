# BigFoot
This is an attempt at creating a post-exploitation persistence script with comms using Powershell, SchTsk, Windows Subsystem for Linux &amp; Tor Hidden Services

This script needs to be run with Administrator privileges so privilege escalation is required before running this


## Progress has come to a halt because of complications in the last stage, which is the actual SSH connection. 
(This is my first Powershell project so... Just keep that in mind :))

The host (Tor Hidden Service on WSL) can not seem to accept the connection requested by the client, presumably by Windows Firewall even while accepting inbound and outbound connections. That is why I decided to post the script even though it is not complete and working, hoping someone else might figure out how to get it to function properly. If so I hope that the solution will be shared with me so I can complete it as well.

```/etc/ssh/sshd_config``` currently needs to be changed manually:

  PermitRootLogin yes
  PasswordAuthentication yes
 
 I have not yet automated this


### Steps of the script:
**(The READABLE script will not work because of the spacing messing up the script when it goes through Out-File)**

1. enables linux feature if not enabled (**wait for script to finish and restart**)
1. creates scheduled task to run log.ps1 if none exists
1. after restart changes scheduled task to trigger at login to run the script again and install WSL (**wait for script to finish, log out and log back in**)
1. creates bash script in WSL
1. changes log.ps1 to run ```wsl /tmp/bigfoot```
