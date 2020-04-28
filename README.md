# olt-pon-traffic-sender
Script OLT Fiberhome para obter tráfego da PONS - Formato zabbix-sender

Exemplo de saída:

```
"OLT-TESTE" "ifHCInOctets[544210944]" "1587831896" "571623163207"
"OLT-TESTE" "ifHCOutOctets[544210944]" "1587831896" "6062140932573"
"OLT-TESTE" "ifHCInOctets[544735232]" "1587831896" "118320132552"
"OLT-TESTE" "ifHCOutOctets[544735232]" "1587831896" "2461625404137"
```

O script é chamado da seguinte forma:

```
/bin/bash -c '/usr/bin/zabbix_sender -z localhost -p 10051 -T -i <(/usr/share/zabbix/externalscripts/olt-pon-traffic-sender.sh 192.168.0.1 OLT-TESTE) || true'
```

No seu template zabbix você pode usar o seguinte OID para descoberta das PONs:

```
discovery[{#SNMPVALUE},.1.3.6.1.4.1.5875.800.3.9.3.4.1.2]
```

O tipo de protótipo do item é Zabbix trapper com as chaves ```ifHCInOctets[{#SNMPVALUE}]``` e ```ifHCOutOctets[{#SNMPVALUE}]```

Dessa forma a consulta fica muito rápida e você consegue monitorar a cada 5 minutos, obtendo assim uma visibilidade melhor do tráfego.

Para ativar função na OLT:

```
cd maintenance 
cd performance
set mib performance switch enable
set pon_traffic_sts switch traffic enable 5 0
```


