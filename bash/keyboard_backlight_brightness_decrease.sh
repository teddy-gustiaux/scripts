#!/bin/bash

brightness_val=$(cat /sys/class/leds/asus::kbd_backlight/brightness)
if [ 0 -lt $brightness_val ]
  then 
    brightness_val=$(($brightness_val - 1))
    echo $brightness_val | tee /sys/class/leds/asus::kbd_backlight/brightness
fi