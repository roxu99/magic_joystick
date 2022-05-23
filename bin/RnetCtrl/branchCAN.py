
"""
This file is used to just make a link between interfaces Can0 and Can1
All of frame send by one is repeated to the other.

Pass an integer as first arg to set the auto stop, ex :
    python3 branchCAN.py 12 &
If an arg is given, no display will occure, usefull to run it in backgroud.
Use 'kill -9 <PID>' to end it ('ps' to get PID)

If no arg is given, the programm will wait an input to stop. (display will occure)

To capture the trafic between the Joystick and the motor, use tshark WHILE this programm is running :
    sudo tshark -a duration:10 -w /tmp/recordCAN.pcap -i can1
This create a '/tmp/recordCAN.pcap' file recording all trafic on 'can1' interface during 10 seconds.
The .pcap file is openable in Wireshark.
'man tshark' for more info...
"""

import threading
import time
import sys

from click import getchar 
from magick_joystick.can2RNET import can2RNET


runningTime = -1

if(len(sys.argv)==2): # Mute all output
    runningTime = int(sys.argv[1])
    sys.stdout = open("/dev/null",'w')
    sys.stderr = sys.stdout



"""
Daemon that just pass all the frame from 'listensock' to 'sendsock'
"""
def branch_daemon_pass(daemonID, listensock, sendsock):
    print("Deamon", daemonID, "-> started, executing 'branch_daemon_pass'")
    while(True):
        rnetFrame = can2RNET.canrecv(listensock)
        can2RNET.cansendraw(sendsock, rnetFrame)
    print("Deamon", daemonID, "-> ended!")


print("Branch Opening socketcan...")
try:
    cansocket0 = can2RNET.opencansocket(0,False)
except:
    print("RnetListener socketcan can0 cannot be opened! Check connectivity")
    sys.exit(1)
try:
    cansocket1 = can2RNET.opencansocket(1,False)
except:
    print("RnetListener socketcan can1 cannot be opened! Check connectivity")
    sys.exit(1)

print("All of the socket succesfully openned!")


daemon0 = threading.Thread(target=branch_daemon_pass, args=[0, cansocket0, cansocket1], daemon=True)
daemon1 = threading.Thread(target=branch_daemon_pass, args=[1, cansocket1, cansocket0], daemon=True)
daemon0.start()
daemon1.start()
print("All daemon started!",flush=True)


if(runningTime == -1):
    time.sleep(1)
    print("Press any key to stop:")
    getchar()
else:
    time.sleep(runningTime)

print("Programm ended")
exit(0)

