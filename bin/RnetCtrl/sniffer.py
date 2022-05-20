"""
This file implements a Sniffer in order to listen all frames on CanBus.
The result is placed in a log file
"""


import threading
import time
import sys
import os.path
import queue

from click import getchar 
from magick_joystick.can2RNET import can2RNET



"""
This function wait for a key to stop all running daemon (from sniffer.py) using the global variable 'running'
"""
def sniffer_daemon_stopRunning(daemonID):
    global running
    print("Deamon", daemonID, "-> started, executing 'sniffer_daemon_stopRunning'")
    time.sleep(1)   
    print("Press any key to stop sniffing:")
    getchar()
    running = False
    return


"""
Daemon that just pass all the frame from 'listensock' to 'sendsock'
"""
def sniffer_daemon_pass(daemonID, listensock, sendsock):
    global running
    print("Deamon", daemonID, "-> started, executing 'sniffer_daemon_stock'")
    while(running):
        rnetFrame = can2RNET.canrecv(listensock)
        can2RNET.cansendraw(sendsock, rnetFrame)
    print("Deamon", daemonID, "-> ended!")


"""
Daemon that pass all frames from 'listensock' to 'sendsock'
It stack also all frames in the 'stockingQueue' globale queue
"""
def sniffer_daemon_stock(daemonID, listensock, sendsock):
    global running 
    global stockingQueue
    print("Deamon", daemonID, "-> started, executing 'sniffer_daemon_stock'")
    while(running):
        rnetFrame = can2RNET.canrecv(listensock)
        can2RNET.cansendraw(sendsock, rnetFrame)
        stockingQueue.put(rnetFrame)
    print("Deamon", daemonID, "-> ended!")


"""
This daemon reads the stockingQueue' globale queue to place frames in a log file.
"""
def sniffer_daemon_logger(daemonID, fd):
    global running 
    global stockingQueue
    i=0
    print("Deamon", daemonID, "-> started, executing 'sniffer_daemon_logger'")
    while(running or not stockingQueue.empty()): #Tant que pile pas vide ou en execution
        frame = stockingQueue.get()
        frame += b'\n'
        fd.write(frame)
        #fd.write('\n')
        i += 1
    print("Captured",i+1, "frames")
    print("Deamon", daemonID, "-> ended!")




# ================================================= MAIN =================================================


logFileName="/tmp/sniffer_log.txt"
print("Sniffer Opening log file \"",logFileName,"\" ...", sep='')
c = 'y'
if (os.path.exists(logFileName)):
    print("WARINING :", logFileName, "already exist. Overwrite it? [y,n]", end='', flush=True)
    c = getchar(echo=True)
    print()
if (c != 'y'):
    sys.exit(0)


try:
    fd = open(logFileName, 'wb')
except:
    print("Error during oppening of", logFileName)
    sys.exit(1)



print("Sniffer Opening socketcan...")
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


# Par défaut thread-safe (Cf doc)
stockingQueue = queue.Queue()
running = True

daemon0 = threading.Thread(target=sniffer_daemon_stock, args=[0, cansocket0, cansocket1], daemon=True)
daemon1 = threading.Thread(target=sniffer_daemon_stock, args=[1, cansocket1, cansocket0], daemon=True)
daemonLogger = threading.Thread(target=sniffer_daemon_logger, args=[2, fd], daemon=True)
daemonStopper = threading.Thread(target=sniffer_daemon_stopRunning, args=[3], daemon=True)

daemon0.start()
daemon1.start()
daemonLogger.start()
daemonStopper.start()

print("All daemon started!")

daemon0.join()
daemon1.join()
daemonLogger.join()
daemonStopper.join()
print("All of daemon succesfully joined")


fd.close()

