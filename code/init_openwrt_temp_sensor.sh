# Put your custom commands here that should be executed once
# the system init finished. By default this file does nothing.

rmmod gpio_button_hotplug
#rmmod w1-gpio
sleep 1
insmod w1-gpio-custom bus0=0,18,0
insmod w1_therm

#The behaviour of this driver can be altered by setting some parameters
#from the insmod command line.
#
#The following parameters are adjustable:
#
#    bus0    These four arguments must be arrays of
#    bus1    3 unsigned integers as follows:
#    bus2
#    bus3    <id>,<pin>,<od>
#
#where:
#
#<id>        ID to used as device_id for the corresponding bus (required)
#<sda>       GPIO pin ID of data pin (required)
#<od>        Pin is configured as open drain.
#
#See include/w1-gpio.h for more information about the parameters.



echo 7 > /sys/class/gpio/export
#echo 18 > /sys/class/gpio/export
echo 20 > /sys/class/gpio/export
echo 29 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio7/direction
#echo out > /sys/class/gpio/gpio18/direction
echo out > /sys/class/gpio/gpio20/direction
echo out > /sys/class/gpio/gpio29/direction
echo 1 > /sys/class/gpio/gpio7/value
#sleep 1
echo 1 > /sys/class/gpio/gpio29/value
#sleep 1
echo 1 > /sys/class/gpio/gpio20/value
#iptables -I FORWARD -s 192.168.3.50  -p udp \! --dport 53 -j REJECT
#iptables -I FORWARD -d 192.168.3.50  -p udp \! --sport 53 -j REJECT
exit 0
