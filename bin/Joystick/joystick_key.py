import threading
import time
import paho.mqtt.client as mqtt
from magick_joystick.Topics import *
from click import getchar

ARR_U = '\x1b[A'
ARR_D = '\x1b[B'
ARR_R = '\x1b[C'
ARR_L = '\x1b[D'



x = 0
y = 0

def get_kbd_arrows():
    global x
    global y
    while True:
        key = getchar()
        if (key == ARR_U):
            #print("Move UP")
            y = 127
        elif (key == ARR_D):
            #print("Move DOWN")
            y = 128
        elif (key == ARR_L):
            #print("Move LEFT")
            x = 128
        elif (key == ARR_R):
            #print("Move RIGHT")
            x = 127
        elif( key == ' '):
            x = 0
            y = 0


client = mqtt.Client()
client.connect("localhost", 1883, 60)
client.loop_start()

print("Mqtt connection opened")
time.sleep(1)

#On envoit le fait que l'on souhaite piloter
msg = action_drive(True)
client.publish(msg.TOPIC_NAME, msg.serialize())

time.sleep(1)
print("Action drive sended, starting loop...")

d = threading.Thread(target=get_kbd_arrows, daemon=True)
d.start()

while True:
    button = 0
    long_click = 0

    #print("(X=%d,Y=%d)" % (x,y))

    joy_data = joystick_state(button, x, y, long_click)
    client.publish(joy_data.TOPIC_NAME, joy_data.serialize())
    time.sleep(1 / 30)

