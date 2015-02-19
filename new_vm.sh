!#/bin/bash/

#How to set up virtual cluster 
#http://blog.cloudera.com/blog/2014/01/how-to-create-a-simple-hadoop-cluster-with-virtualbox/

clear
echo '################### Setting up Fresh Installation #######################'
service iptables stop
chkconfig iptables off
sleep 1
clear

#New hostname and IP address
echo ""
echo "Enter New Hostname:"
echo ""
read NEWNAME

sed "s/base/$NEWNAME/g" /etc/sysconfig/network > ~/newname.txt
mv ~/newname.txt /etc/sysconfig/network

echo ""
echo "Enter IP number"
echo ""
read NEWIP

sed "s/192.168.56.2/192.168.56.2$NEWIP/g" /etc/sysconfig/network-scripts/ifcfg-eth1 > ~/newip.txt
mv ~/newip.txt /etc/sysconfig/network-scripts/ifcfg-eth1

hostname=$NEWNAME.anacentos.com

sed "s/base/$NEWNAME/g" /etc/hosts > ~/newhosts.txt.1
sed "s/192.168.56.2/192.168.56.2$NEWIP/g" ~/newhosts.txt.1 > ~/newhosts.txt
mv ~/newhosts.txt /etc/hosts

clear
cat /etc/sysconfig/network
echo ""
cat /etc/sysconfig/network-scripts/ifcfg-eth1
echo ""
cat /etc/hosts
echo ""
sleep 10

service network restart
init 6