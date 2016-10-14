#!/bin/bash

readonly LOAD=$(sysctl -n vm.loadavg | awk '{ print $2 }')
readonly NCPU=$(sysctl -n hw.ncpu)

echo $LOAD/$NCPU
