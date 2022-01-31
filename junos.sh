#!/bin/bash

circuit="$1"
#echo $circuit

HOST1=`echo $circuit | cut -d : -f 1`
PORT1=`echo $circuit | cut -d : -f 2-`

if [[ "${HOST1}:${PORT1}" == *"dr"* ]] && [[ "${HOST1}:${PORT1}" == *"/"* ]] ; then
  sshpass -f sshpass.txt ssh "${HOST1}" << EOF
    show interfaces ${PORT1} | match "Physical interface"
    show interfaces ${PORT1} | match "rate" | except "FEC"
    show interfaces ${PORT1} | match "error" | except "Link-level"
    show interfaces ${PORT1} | match "flap"
    show interfaces diagnostics optics ${PORT1} | except "Off|threshold|Module"
    show lldp neighbors interface ${PORT1} | match "System name|Port ID" | except "Local|Info"
    show interfaces ${PORT1}
EOF
fi
