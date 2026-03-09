#!/bin/bash

# Stop Service
systemctl --user stop --now nanobot-gateway

# Install
uv tool install .

# Start Process
# cd ~
# nanobot gateway 

# Start Service 
systemctl --user start nanobot-gateway