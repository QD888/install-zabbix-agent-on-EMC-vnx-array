#/bsh
#
# jeffrey_fall@nasscomm.com
# Script to install a Zabbix 2.2 agent onto a vnx
#
echo " "
echo "Installing Zabbix agent files from this cirectory to standard locations on the vnx"
#
echo " "
echo "zabbix needs to be run as user zabbix"
echo "add the user zabbix to the vnx"
/usr/sbin/useradd zabbix
#
echo " "
echo "all the zabbix scripts go to /zabbix_operations, well of course!"
echo "We then make that directory"
mkdir /zabbix_operations
chown zabbix:zabbix /zabbix_operations
mkdir /zabbix_operations/tmp
chown zabbix:zabbix /zabbix_operations/tmp
mkdir /zabbix_operations/data
chown zabbix:zabbix /zabbix_operations/data

echo " "
echo "copying the vnx data collection script which runs in cron to /zabbix_operations"
cp ./scripts/collect_nas_data.sh /zabbix_operations
echo " "
echo "copying the raw, used and free capacity summing script to /zabbix_operations"
cp ./scripts/sumi.sh /zabbix_operations
echo " "
echo "Copying zabbix_agentd.conf to /usr/local/etc on the vnx..."
cp ./etc/zabbix_agentd.conf /usr/local/etc
#
echo " "
echo "Copying zabbix_agentd executable to /usr/sbin.."
cp ./bin/zabbix_agentd /usr/sbin
echo " "
echo "copying the zabbix-agent start stop script to /etc/init.d"
cp ./scripts/zabbix-agent /etc/init.d
chmod +x /etc/init.d/zabbix-agent
echo " "
echo "setup crontab to use the collection script"
crontab -l > vnxcron.txt
cat ./cron/datacollectioncrons.txt  >> vnxcron.txt
echo " "
echo "Installing this new cron file:"
echo " "
cat vnxcron.txt
echo " "
cat vnxcron.txt | crontab
rm vnxcron.txt
echo " "
echo "Here is a crontab -l of the root crontab:"
crontab -l
echo " "
echo "setup rc0.d, rc3.d, rc6.d  startup and stop scripts for zabbix-agent"
/sbin/chkconfig zabbix-agent on
echo " "
echo "Assure that the log file can be written by user zabbix into /var/log"
touch /var/log/zabbix_agentd.log
chown zabbix:zabbix /var/log/zabbix_agentd.log
echo " "
echo "Starting the zabbix agent on the VNX"
/etc/init.d/zabbix-agent start
echo " "
#echo " "
#echo "Add the firewall rule for Zabbix port 10050"
#/sbin/iptables -A INPUT -m tcp -p tcp --dport 10050 -j ACCEPT
#echo " "
#echo "Force a save of the iptables to make the rules permanent"
#echo " "
#/etc/init.d/iptables save
#echo " "
echo " "
echo "IMPORTANT!"
echo "Edit the /usr/local/etc/zabbix_agentd.conf file and make Server= the IP of the Zabbix server"
echo "If Server= is not changed, then the zabbix_agentd will not respond on port 10050 to requests"
echo " "
echo "Warning - the VNX may not have the gateway configured and could be isolated on one subnet"echo "If the Zabbix server is on a different subnet, then add a gateway to"
echo "/etc/init.d/network file. Add /sbin/route add default gw (your gateway IP)"
echo "to near the end of the start section of /etc/init.d/network"
