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

# A-END
echo ""
echo "    HOSTNAME / PORT : $HOST1:$PORT1"
echo ""

if [[ "${HOST1}" == *"ma"* ]] ; then
  sshpass -f sshpass.txt ssh "${HOST1}" << EOF
    conf t
    int ${PORT1}
    shutdown
    no shutdown
    end
    exit
EOF

elif [[ "${HOST1}:${PORT1}" == *"Ethernet"* ]] && [[ "${HOST1}:${PORT1}" == *"/"* ]] ; then
  sshpass -f sshpass.txt ssh "${HOST1}" << EOF
    conf t
    int ${PORT1}
    shutdown
    no shutdown
    end
    exit
EOF

elif [[ "${HOST1}:${PORT1}" == *"Ethernet"* ]] ; then
  sshpass -f sshpass.txt ssh "${HOST1}" << EOF
    conf t
    int ${PORT1}
    shutdown
    no shutdown
    end
    exit
EOF

elif [[ "${HOST1}:" == *"fsw"* ]] && [[ "${GPORT1[0]:3}" -ge 100 ]] ; then
  ssh netops@"${GNODE1[0]}-lc${GPORT1[0]:3}.${GNODE1[1]}.${GNODE1[2]}.${GNODE1[3]}" << EOF
    bounce '${GPORT1[0]}/${GPORT1[1]}/${GPORT1[2]}'
    exit
EOF



elif [[ "$HOST1" == *"fa"* ]] || [[ "${HOST1}" == *"rsw"* ]] || [[ "${HOST1}" == *"ssw"* ]] || [[ "${HOST1}" == *"fsw"* ]] ; then
  ssh netops@"${HOST1}" << EOF
    bounce ${PORT1}
    exit
EOF
fi


########################################################################

echo ""
echo ""
echo ""

# Z-END
echo "    HOSTNAME / PORT : $HOST2:$PORT2"
echo ""

if [[ "${HOST2}:${PORT2}" == *"ma"* ]] ; then
  sshpass -f sshpass.txt ssh "${HOST2}" << EOF
    conf t
    int ${PORT2}
    shutdown
    no shutdown
    end
    exit
EOF

elif [[ "${HOST2}:${PORT2}" == *"Ethernet"* ]] && [[ "${HOST2}:${PORT2}" == *"/"* ]] ; then
  sshpass -f sshpass.txt ssh "${HOST2}" << EOF
    conf t
    int ${PORT2}
    shutdown
    no shutdown
    end
    exit
EOF

elif [[ "${HOST2}:${PORT2}" == *"Ethernet"* ]] ; then
  sshpass -f sshpass.txt ssh "${HOST2}" << EOF
    conf t
    int ${PORT2}
    shutdown
    no shutdown
    end
    exit
EOF

elif [[ "${HOST2}" == *"fsw"* ]] && [[ "${GPORT2[0]:3}" -ge 100 ]] ; then
  ssh netops@"${GNODE2[0]}-lc${GPORT2[0]:3}.${GNODE2[1]}.${GNODE2[2]}.${GNODE2[3]}" << EOF
    bounce '${GPORT2[0]}/${GPORT2[1]}/${GPORT2[2]}'
    exit
EOF



elif [[ "$HOST2" == *"fa"* ]] || [[ "${HOST2}" == *"rsw"* ]] || [[ "${HOST2}" == *"ssw"* ]] || [[ "${HOST2}" == *"fsw"* ]] ; then
  ssh netops@"${HOST2}" << EOF
    bounce ${PORT2}
    exit
EOF
fi
