import threading
import time
import paho.mqtt.client as mqtt
from magick_joystick.Topics import *
import logging
import sys
import os
import RPi.GPIO as GPIO

# Instanciate logger:
logging.basicConfig(
    level=logging.INFO, #log every message above INFO level (debug, info, warning, error, critical)
    format="%(asctime)s [%(threadName)-12.12s] [%(levelname)-5.5s]  %(message)s",
    handlers=[
        logging.StreamHandler()
    ])
logger = logging.getLogger()
h = logging.StreamHandler(sys.stdout)
h.flush = sys.stdout.flush
logger.addHandler(h)


class IR_TV():
    def __init__(self):
        logger.info("Configuration de la pin 26 (TV) ")
        GPIO.setwarnings(False)
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(26, GPIO.OUT)
        GPIO.output(26, GPIO.HIGH)


    def send_power(self):
        os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/power.txt")


    def send_volume(self, type):
        if(type == "up"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/volume_plus.txt")
        elif (type == "down"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/volume_less.txt")
        elif (type == "mute"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/mute.txt")

    def send_param(self, type):
        if(type == "exit"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/exit.txt")
        elif (type == "home"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/home.txt")
        elif (type == "info"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/info.txt")
        elif (type == "menu"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/menu.txt")
        elif (type == "return"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/return.txt")
        elif (type == "source"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/source.txt")
        elif (type == "tools"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/tools.txt")


    def send_direction(self, type):
        if(type == "ok"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/ok.txt")
        elif (type == "left"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/left.txt")
        elif (type == "down"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/down.txt")
        elif (type == "right"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/right.txt")
        elif (type == "up"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/up.txt")


    def send_number(self, nb):
        print("je suis la")
        if(nb == "0"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/0.txt")
        elif (nb == "1"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/1.txt")
        elif (nb == "2"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/2.txt")
        elif (nb == "3"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/3.txt")
        elif (nb == "4"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/4.txt")
        elif (nb == "5"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/5.txt")
        elif (nb == "6"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/6.txt")
        elif (nb == "7"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/7.txt")
        elif (nb == "8"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/8.txt")
        elif (nb == "9"):
            os.system("sudo ir-ctl -d /dev/lirc0 -s raw_command/9.txt")
        print("j'ai fini")
