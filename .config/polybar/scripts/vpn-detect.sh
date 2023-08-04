#!/bin/bash

if [[ "$(ps aux | grep openconnect | wc -l)" -gt 1 ]]; then
    echo "on"
else
    echo "off"
fi


