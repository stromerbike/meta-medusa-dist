#!/bin/dash

NAME=peripheral-mpio
DESC="Configures the multipurpose-interface for i2c usage"

# MPIO1_DIR
test -e /sys/class/gpio/gpio18 || echo 18 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio18/direction
echo 0 > /sys/class/gpio/gpio18/value

# MPIO2_DIR
test -e /sys/class/gpio/gpio19 || echo 19 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio19/direction
echo 0 > /sys/class/gpio/gpio19/value

# I2C4_PU
test -e /sys/class/gpio/gpio51 || echo 51 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio51/direction
echo 1 > /sys/class/gpio/gpio51/value

# I2C4_ON
test -e /sys/class/gpio/gpio114 || echo 114 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio114/direction
echo 1 > /sys/class/gpio/gpio114/value
