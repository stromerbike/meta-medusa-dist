#!/bin/dash

NAME=gpio
DESC="Initialization of external gpio expander"

case $1 in
start)
    # load external gpio expander driver
    modprobe gpio_pca953x_external
;;

stop)
    # unload external gpio expander driver
    modprobe -r gpio_pca953x_external
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
