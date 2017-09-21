#!/bin/bash

ip route add 10.89.23.0/24 dev ppp0
ip route del default
ip route add default dev ppp1
