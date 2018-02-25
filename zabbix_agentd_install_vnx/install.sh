#!/bin/sh
./installer/install_zabbixagentvnx.sh
echo " "
echo "Zabbix agent insallation on VNX completed"
echo " "
echo "Try to discover this VNX from the Zabbix server via the IP of the Control Station"
echo " "
echo "Running the  /zabbix_operations/collect_nas_data.sh force for the first time to establish initial data"
echo "for the Zabbix Agent.d to pick up"
echo " "
/zabbix_operations/collect_nas_data.sh force

