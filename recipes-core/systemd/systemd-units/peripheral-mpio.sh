#!/bin/dash

NAME=gpio
DESC="Configures the multipurpose-interface for i2c usage"

# MPIO1_DIR
echo 18 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio18/direction

# MPIO2_DIR
echo 19 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio19/direction

# I2C4_PU
echo 51 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio51/direction
echo 1 > /sys/class/gpio/gpio51/value

# I2C4_ON
echo 114 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio114/direction
echo 1 > /sys/class/gpio/gpio114/value
