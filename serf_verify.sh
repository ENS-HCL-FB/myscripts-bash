#!/bin/bash

# script to verify serf information when unconfigure fails

serf get asset_id=$1 --fields name,serial_number,asset_tag,parent_asset_tag,suite,row,rack,rack_position,status,eth0.mac,eth0.ip_addr,eth0.ipv6_addr,fbpn
