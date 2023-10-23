#!/bin/bash

c="\e[96m"
r="\e[0m"
obfs3="ClientTransportPlugin obfs3 exec /usr/bin/obfsproxy managed"
obfs4="ClientTransportPlugin obfs4 exec /usr/bin/obfs4proxy managed"
torrc="/etc/tor/torrc"
torconf="/etc/torrc.d"
p4="/etc/proxychains4.conf"
declare -A bridge_array

i=1
while read LINE
do
	read -r	bridge_array[bridge$i] <<< "$LINE"
	i=$(($i+1))	
done < bridges.txt

echo -e "${c}enter date (YYYYMMDD HH:MM)${r}"
read dateinput

echo -e "${c}setting system time...${r}"
date --set="$dateinput"

echo -e "${c}installing Tor and proxychains4...${r}"

OS=$(uname -s | tr A-Z a-z)

case $OS in
  linux)
    source /etc/os-release
    case $ID in
      debian|ubuntu|mint)
 	apt update
	apt install -y tor torbrowser-launcher proxychains4
        ;;

      fedora|rhel|centos)
	dnf update -y --allowerasing --nobest --skip-broken
 	dnf install -y tor proxychains-ng
        ;;

	arch)
	pacman -Syu --noconfirm tor torbrowser-launcher proxychains4
	;;
	*)
        echo -n "unsupported linux distro"
        ;;
    esac
  ;;
  *)
    echo -n "unsupported OS"
    ;;
esac



echo -e "${c}backing up torrc"

cp /etc/tor/torrc /etc/tor/torrc.old

if [[ $( cat ${torrc} | grep -x "%include ${torconf}/bridges.conf" ) == "" ]] ; then
	sudo echo "%include ${torconf}/bridges.conf" >> $torrc
fi

echo -e "${c}making config file...${r}"

if test -d /etc/torrc.d ; then
	if test ! -f /etc/torrc.d/bridges.conf ; then
		touch /etc/torrc.d/bridges.conf
	fi
else
	mkdir /etc/torrc.d
	touch /etc/torrc.d/bridges.conf
fi


echo -e "${c}adding bridges to Tor...${r}"

if [[ $( cat ${torconf}/bridges.conf | grep "UseBridges 1")  == "" ]]
then
	echo 'UseBridges 1' >> $torconf/bridges.conf
fi

if [[ $( cat ${torconf}/bridges.conf | grep "${obfs3}") == "" ]]
then
	echo "${obfs3}" >> $torconf/bridges.conf
fi

if [[ $( cat ${torconf}/bridges.conf | grep "${obfs4}") == "" ]]
then
	echo "${obfs4}" >> $torconf/bridges.conf
fi

for b in "${bridge_array[@]}"
do
	if [[ $( cat ${torconf}/bridges.conf | grep -x "bridge ${b}") == "" ]]
	then
		echo "bridge ${b}" >> $torconf/bridges.conf
		echo -e "${c}${b}  added!${r}"
	else
		echo -e "${c}${b}  already exists, skipping...!${r}"
	fi
done

echo -e "${c}editing proxychains4.conf file${r}"

#if [[ $( cat ${p4} | grep -x "strict_chain") == "" ]]
#then 
#	sed -i "s/strict_chain/dynamic_chain/" $p4
#fi

if [[ $( cat ${p4} | grep -x "socks5  127.0.0.1 9050") == "" ]]
then 
	echo "socks5  127.0.0.1 9050" >> $p4
fi

echo -e "${c}starting services...${r}"

if [[ $( systemctl is-enabled tor ) == "disabled" ]] ; then
	systemctl enable tor
fi
if [[ $( systemctl status tor | grep "active (running)" ) == "" ]] ; then
	systemctl start tor
fi

echo -e "${c}DONE${r}"
for i in {1..3}
do
	echo '.'
	sleep 1
done
echo "all done!"
echo -e "${c}enter 'proxychains firefox' to use Tor with Firefox${r}"
