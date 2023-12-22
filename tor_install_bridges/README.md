---Install and configure Tor and Proxychains automatically in most Linux distros. Add bridges from "bridges.txt" file automatically. Run with sudo---

1. put Tor bridges (you can acquire them at "bridges.torproject.org") in the bridges.txt file in the following format:
   obfs4 255.255.255.255:9043 RRRRRRRRRRRRRRRRRRRRRRRRRRRRR cert=RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
   iat-mode=0
   You can just paste them as they appear on "bridges.torproject.org" website directly into the file.
2. save bridges.txt file
3. run "sudo ./tor_install_bridges.sh"
4. use "proxychains firefox" or any other program name to route all traffic of such program through Tor 

To remove changed settings and packages, run the script with "-d" option.
