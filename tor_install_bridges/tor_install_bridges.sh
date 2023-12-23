#!/bin/bash


# Create variables
c="\e[96m"
r="\e[0m"
obfs3="ClientTransportPlugin obfs3 exec /usr/bin/obfsproxy managed"
obfs4="ClientTransportPlugin obfs4 exec /usr/bin/obfs4proxy managed"
torrc="/etc/tor/torrc"
torconf="/etc/torrc.d"
p4="/etc/proxychains4.conf"
declare -A bridge_array

# Check for -d option to remove the installed packages

while getopts "d" opt; do
	echo "Removing associated configuration files..."
	! [[ -f "$torconf/bridges.conf" ]] || rm "$torconf/bridges.conf"
	if [[ -f /etc/tor/torrc.old ]]; then
		mv /etc/tor/torrc.old /etc/tor/torrc
	else
		rm /etc/tor/torrc
	fi
	echo "Uninstalling packages..."
	source /etc/os-release
 	case "$ID" in
	      debian|ubuntu|mint)
		apt purge -y tor torbrowser-launcher proxychains4;;
      		fedora|rhel|centos)
 		dnf remove -y tor proxychains-ng;;
		arch)
		pacman -Rsn --noconfirm tor torbrowser-launcher proxychains4;;
		\?)
	        echo -n "unsupported linux distro";;
	esac
	echo "all done!"
	exit 0

done
# Read bridges from bridges.txt and iterate through them, adding them to an array 
i=1
while read LINE
do
	read -r	bridge_array[bridge$i] <<< "$LINE"
	i=$(($i+1))	
done < bridges.txt

# Set system date manually (Kali doesn't use NTP by default)
echo -e "${c}enter date (YYYYMMDD HH:MM)${r}"
read dateinput
echo -e "${c}setting system time...${r}"
date --set="$dateinput"

# Install Tor and Proxychains with desired Package Manager
echo -e "${c}installing Tor and proxychains4...${r}"
OS=$(uname -s | tr A-Z a-z)
case "$OS" in
  linux)
    source /etc/os-release
    case "$ID" in
      debian|ubuntu|mint)
 	apt update
	apt install -y tor torbrowser-launcher proxychains4;;
      fedora|rhel|centos)
	dnf update -y --allowerasing --nobest --skip-broken
 	dnf install -y tor proxychains-ng;;
	arch)
	pacman -Syu --noconfirm tor torbrowser-launcher proxychains4;;
	*)
        echo -n "unsupported linux distro";;
    esac;;
  \?)
    echo -n "unsupported OS";;
esac

# Back up torrc file
echo -e "${c}backing up torrc"
cp /etc/tor/torrc /etc/tor/torrc.old

# Add include line to torrc file
if [[ $( grep -x "%include $torconf/bridges.conf" < "$torrc" ) == "" ]] ; then
	echo "%include $torconf/bridges.conf" >> "$torrc"
fi

# Create bridges.conf config file in /etc/torrc.d
echo -e "${c}making config file...${r}"
if [[ -d /etc/torrc.d ]] ; then
	if ! [[ -f /etc/torrc.d/bridges.conf ]] ; then
		touch /etc/torrc.d/bridges.conf
	fi
else
	mkdir /etc/torrc.d
	touch /etc/torrc.d/bridges.conf
fi

# Add bridges from bridges.txt and other needed lines to /etc/torrc.d/bridges.conf
echo -e "${c}adding bridges to Tor...${r}"
if [[ $( grep "UseBridges 1" < "$torconf/bridges.conf" )  == "" ]]
then
	echo 'UseBridges 1' >> "$torconf/bridges.conf"
fi

if [[ $( grep "$obfs3" < "$torconf/bridges.conf" )  == "" ]]
then
	echo "$obfs3" >> "$torconf/bridges.conf"
fi

if [[ $( grep "$obfs4" < "$torconf/bridges.conf" ) == "" ]]
then
	echo "$obfs4" >> "$torconf/bridges.conf"
fi

for b in "${bridge_array[@]}"
do
	if [[ $( grep -x "bridge $b" < "$torconf/bridges.conf" )  == "" ]]
	then
		echo "bridge $b" >> "$torconf/bridges.conf"
		echo -e "${c}${b}  added!${r}"
	else
		echo -e "${c}${b}  already exists, skipping...!${r}"
	fi
done

# Add Socks5 proxy pointing to Tor listener to Proxychains config
echo -e "${c}editing proxychains4.conf file${r}"

#if [[ $( cat ${p4} | grep -x "strict_chain") == "" ]]
#then 
#	sed -i "s/strict_chain/dynamic_chain/" $p4
#fi

if [[ $( grep -x "socks5  127.0.0.1 9050" < "$p4" ) == "" ]]
then 
	echo "socks5  127.0.0.1 9050" >> "$p4"
fi

# Check for, enable and start Tor service 
echo -e "${c}starting services...${r}"
if [[ $( systemctl is-enabled tor ) == "disabled" ]] ; then
	systemctl enable tor
fi
if [[ ! $( systemctl status tor ) == "active (running)" ]] ; then
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

exit 0
