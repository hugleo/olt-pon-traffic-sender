#!/bin/bash

IP=$1
HOSTNAME=$2
BUFFERSIZE=32
TIMESTAMP=`date +%s`

# OBTEM OS INDEX OIDS DE TODAS AS PONS
PONINDEXES=`snmpbulkwalk -t 60 -m +GEPON-OLT-COMMON-MIB -Osq -c adsl -v2c $IP .1.3.6.1.4.1.5875.800.3.9.3.4.1.2 | sed -e 's/.*\.\(.*\) ".*/\1/'`

format_snmp_get_Key_values () {
    local BUF=$1
    snmpget -t 60 -Osq -c adsl -v2c $IP $BUF | sed -e "s/ /] $TIMESTAMP /g" | sed -e "s/\./[/g" | sed -e "s/^/$HOSTNAME /" | sed -e "s/ /\" \"/g" | sed 's/\(.*\)/"\1"/g'
    sleep 1
}

format_buffer_snmp_Key_values () {
    local i=0
    local BUFFER=""

    while IFS= read -r line; do

        ((i++))

        BUFFER+=" ifHCInOctets.$line ifHCOutOctets.$line"

        if ! ((i % $BUFFERSIZE)); then
            format_snmp_get_Key_values "$BUFFER"
            BUFFER=""
        fi

    done <<< "$PONINDEXES"

    if ((i % $BUFFERSIZE)); then   
        format_snmp_get_Key_values "$BUFFER"
    fi    

}

format_buffer_snmp_Key_values
