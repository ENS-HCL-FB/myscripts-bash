#!/bin/bash
# Get location and relevant data.


serf get name=$1 --fields name,location,make,model,fbpn,asset_id,asset_tag,parent_asset_tag,serial_number,eth0.mac,eth0.ip_addr,eth0.ipv6_addr,console_server,console_port

serf get network_name=$1 --fields name,location,make,model,fbpn,asset_id,asset_tag,parent_asset_tag,serial_number,eth0.mac,eth0.ip_addr,eth0.ipv6_addr,console_server,console_port
