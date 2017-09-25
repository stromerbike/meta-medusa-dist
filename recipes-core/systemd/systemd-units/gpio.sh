#!/bin/bash

NAME=gpio
DESC="Initialization of internal and external (if present) gpio expander"

case $1 in
start)
    modprobe gpio_pca953x
;;

stop)
    modprobe -r gpio_pca953x
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
