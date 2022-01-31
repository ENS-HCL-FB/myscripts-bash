#!/bin/bash

circuit="$1"

HOST1=`echo $circuit | cut -d : -f 1`
host1=`echo $circuit | cut -d : -f 2-`
PORT1=`echo $host1 | cut -d - -f 1`
port1=`echo $host1 | cut -d - -f 2-`
HOST2=`echo $port1 | cut -d : -f 1`
PORT2=`echo $port1 | cut -d : -f 2-`

########################################################################

  # GALAXY

IFS='.'     # period (.) is set as delimiter
read -ra GNODE1 <<< "$HOST1" # host is read into an array as tokens separated by IFS
IFS=' '     # reset to default value after usage

IFS='.'     # period (.) is set as delimiter
read -ra GNODE2 <<< "$HOST2" # host is read into an array as tokens separated by IFS
IFS=' '     # reset to default value after usage

IFS='/'     # forward-slash (/) is set as delimiter
read -ra GPORT1 <<< "$PORT1" # port is read into an array as tokens separated by IFS
IFS=' '     # reset to default value after usage

IFS='/'     # forward-slash (/) is set as delimiter
read -ra GPORT2 <<< "$PORT2" # port is read into an array as tokens separated by IFS
IFS=' '     # reset to default value after usage

########################################################################

if [[ "${HOST1}" == *"ma"* ]] || [[ "${HOST1}" == *"eb"* ]]; then
  sshpass -f sshpass.txt ssh "${HOST1}" << EOF
    sh lldp neighbors ${PORT1}
EOF

elif [[ "${HOST1}:${PORT1}" == *"dr"* ]]; then # && [[ "${HOST1}:${PORT1}" == *"/"* ]] ; then
  sshpass -f sshpass.txt ssh "${HOST1}" << EOF
    show lldp neighbors interface ${host1} | match "System name|Port ID" | except "Local|Info"
EOF

elif [[ "${HOST1}:${PORT1}" == *"Ethernet"* ]] && [[ "${HOST1}:${PORT1}" == *"/"* ]] ; then
  sshpass -f sshpass.txt ssh "${HOST1}" << EOF
    sh lldp neighbor ${PORT1}
EOF

elif [[ "${HOST1}:${PORT1}" == *"Ethernet"* ]] ; then
  sshpass -f sshpass.txt ssh "${HOST1}" << EOF
    sh lldp neighbor ${PORT1}
EOF

elif [[ "${HOST1}:" == *"fsw"* ]] && [[ "${GPORT1[0]:3}" -ge 100 ]] ; then
  fboss -H ${GNODE1[0]}-lc${GPORT1[0]:3}.${GNODE1[1]}.${GNODE1[2]}.${GNODE1[3]} lldp | grep ${GPORT1[0]}/${GPORT1[1]}/${GPORT1[2]}

elif [[ "$HOST1" == *"fa"* ]] || [[ "${HOST1}" == *"rsw"* ]] || [[ "${HOST1}" == *"ssw"* ]] || [[ "${HOST1}" == *"fsw"* ]] ; then
  fboss -H ${HOST1} lldp | grep ${PORT1}

else
  fboss -H ${HOST1} lldp | grep ${PORT1}
fi
