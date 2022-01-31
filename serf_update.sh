#!/bin/bash

# script to update serf information when unconfigure fails

# USE serf_verify.sh TO VERIFY THAT THE <asset_id> IS A VIRTUAL ASSET <fbpn=VIRTUAL>

serf set asset_id=$1 name='',serial_number=$RANDOM,asset_tag=$RANDOM,parent_asset_tag='',suite='',row='',rack='',rack_position='',status=DECOMMISSIONED,eth0.mac='',eth0.ip_addr='',eth0.ipv6_addr='' -m $2
