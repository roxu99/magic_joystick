
import threading
import sys
from magick_joystick.can2RNET import can2RNET


def rnet_daemon(listensock, sendsock, daemonID):
    print("Deamon", daemonID, "started!")
    while(True):
        rnetFrame = can2RNET.canrecv(listensock)
        can2RNET.cansendraw(sendsock, rnetFrame)
    print("Deamon", daemonID, "ended!")



print("RnetListener Opening socketcan...")
try:
    cansocket0 = can2RNET.opencansocket(0)
except:
    print("RnetListener socketcan can0 cannot be opened! Check connectivity")
    sys.exit(1)
try:
    cansocket1 = can2RNET.opencansocket(1)
except:
    print("RnetListener socketcan can1 cannot be opened! Check connectivity")
    sys.exit(1)

print("All of the socket succesfully openned!")


daemon0 = threading.Thread(target=rnet_daemon, args=[cansocket0, cansocket1, 0], daemon=True)
daemon0.start()
daemon1 = threading.Thread(target=rnet_daemon, args=[cansocket1, cansocket0, 1], daemon=True)
daemon1.start()

daemon0.join()
daemon1.join()

print("All of daemon succesfully joined")
