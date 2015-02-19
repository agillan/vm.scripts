!#/bin/bash/
clear
echo 'Stopping/Starting required services'
service iptables stop
chkconfig iptables off
sleep 1
clear
#Setup any additional repos required
printf "\n#######################################\n"
printf "#Getting any additional required repos#\n"
printf "#######################################\n\n"
yum -y -q install wget
wget -q http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
rpm -Uh --quiet rpmforge-release*.rf.x86_64.rpm
rm -rf rpmforge-release*.rf.x86_64.rpm
sleep 2
clear
echo "#######################################"
echo "# AMBARI REPO INSTALL                 #"
echo "#######################################"
echo
echo
#GET THE AMBARI REPOS
echo ""
echo "Which version should I download?"
echo "----------------------------------"
echo ""
echo "Ambari 1.6.1 [1]"
echo "Ambari 1.6.0 [2]"
echo "Ambari 1.5.1 [3]"
echo "     "
echo -n     "Enter you option and press [ENTER]:"
read stack
if [ $stack == 1 ]; then
#AMBARI 1.6.1
printf "\nAdding Ambari-1.6.1 repo to /etc/yum.repos.d/\n"
echo ""
wget -q http://public-repo-1.hortonworks.com/ambari/centos6/1.x/updates/1.6.1/ambari.repo -O /etc/yum.repos.d/ambari.repo
elif [ $stack == 2 ]; then
#AMBARI 1.6.0
printf "\nAdding Ambari-1.6.0 repo to /etc/yum.repos.d/\n"
echo ""
wget -q http://public-repo-1.hortonworks.com/ambari/centos6/1.x/updates/1.6.0/ambari.repo -O /etc/yum.repos.d/ambari.repo
elif [ $stack == 3 ]; then
#AMBARI 1.5.1
printf "\nAdding Ambari-1.5.1 repo to /etc/yum.repos.d/\n"
echo ""
wget -q http://public-repo-1.hortonworks.com/ambari/centos6/1.x/updates/1.5.1/ambari.repo -O /etc/yum.repos.d/ambari.repo
fi

#DEVELOPMENT TOOLS?
echo ""
echo "Do you want to install Linux Development Tools? (y/n)"
echo ""
read devtools
if [ $devtools == "y" ]; then
     yum -y groupinstall 'Development Tools'
     echo ""
     echo ""
     echo "Done!"
     sleep 2
     clear
elif [ $devtools == "n" ]; then
     printf "\nSkipping Development Tools…\n"
     sleep 2
     clear
fi

printf "\n#######################################\n"
printf "# EXTRA PACKAGE INSTALL               #\n"
printf "#######################################\n"
echo “installing packages”
yum -y -q update
yum -y -q install htop perl nano curl ntp mysql-server phpmyadmin expect screen
sleep 2
clear

echo "#######################################"
echo "# AMBARI SERVER INSTALL               #"
echo "#######################################"
#SCRIPT: Ask if want Ambari
echo "Ambari Install"
yum -y -q install ambari-server
echo "All set!"
sleep 2
clear
echo "#######################################"
echo "# AMBARI SERVER SETUP               #"
echo "#######################################"

/usr/bin/expect -c '
set timeout -1
spawn $env(SHELL)
match_max 100000
expect -exact "#"
send -- "ambari-server setup\r"
expect -exact "(y)? "
send -- "y\r"
expect -exact "y\r
Customize user account for ambari-server daemon \[y/n\] (n)? "
send -- "y\r"
expect -exact "y\r
Enter user account for ambari-server daemon (root):"
send -- "\r"
expect -exact "Enter choice (1):"
send -- "1\r"
expect -exact "(y)? "
send -- "y\r"
expect -exact "(n)? "
send -- "\r"
expect -exact "successfully."
send -- "exit\r" '

ambari-server start
printf "\nAmbari Installed!\n"
sleep 2
clear
echo "#######################################"
echo "# AMBARI AGENT INSTALL               #"
echo "#######################################"
yum -y -q install ambari-agent
ambari-agent start
printf "\nAmbari Agent Installed!\n"
sleep 2
clear

echo "###############################################################"
echo "# Ambari is ready to install HDP stack: http://localhost:8080 #"
echo "###############################################################" 