#!/bin/zsh
echo bone_pwm_P8_13 > /sys/devices/bone_capemgr.?/slots
echo bspm_P9_41_37 > /sys/devices/bone_capemgr.?/slots
echo bspm_P9_30_37 > /sys/devices/bone_capemgr.?/slots
echo BB-ADC > /sys/devices/bone_capemgr.?/slots
echo 20 > /sys/class/gpio/export
echo 112 > /sys/class/gpio/export
sleep 1
echo in >| /sys/class/gpio/gpio20/direction
echo falling >| /sys/class/gpio/gpio20/edge
echo in >| /sys/class/gpio/gpio112/direction
echo both >| /sys/class/gpio/gpio112/edge
echo 1 >| /sys/class/gpio/gpio112/active_low

while ~/wait_gpio_intterupt /sys/class/gpio/gpio20/value; do ~/tetris.sh; done &
~/watch_moisture.sh &
exit 0
