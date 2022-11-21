### MONITORING ###

### INFO ###
architecture=$(uname -a)
adressip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')
cotcp=$(ss -s | grep 'TCP' | grep 'estab' | awk '{print $4}' | cut -d, -f1)
sudocountcmd=$(journalctl -q _COMM=sudo | grep COMMAND | wc -l)
user_log=$(who | wc -l)
lastboot=$(who -b | awk '{print $3 " " $4}')

### PROCESSOR ###
pCPU=$(lscpu | grep "CPU(s):" | awk 'NR==1{print $2}')
vCPU=$(cat /proc/cpuinfo | grep processor | wc -l)
cpu_load=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')

### MEMORY ###
total_mem=$(free -m | awk '{print $2}' | sed -n '2p')
used_mem=$(free -m | awk '{print $3}' | sed -n '2p')
available_mem=$(($used_mem*100/$total_mem))

### DISK ###
total_disk=$(df -Bm | grep '^/dev' | awk '{s += $2} END { printf "%.0f", s }')
used_disk=$(df -Bm | grep '^/dev' | awk '{s += $3} END { printf "%.0f", s }')
available_disk=$(($used_disk*100/$total_disk))
lvmuse=$(if [ $(lsblk | grep "lvm" | wc -l) -eq 0 ]; then echo no; else echo yes; fi)


wall "     
	#Architecture: $architecture
	#CPU physical: $pCPU
	#vCPU: $vCPU
	#Memory Usage: $used_mem/${total_mem}MB ($available_mem%)
	#Disk Usage: $used_disk/${total_disk}MB ($available_disk%)
	#CPU load: $cpu_load
	#Last boot: $lastboot
	#LVM use: $lvmuse
	#Connexions TCP: $cotcp ESTABLISHED
	#User log: $user_log
	#Network: IP $adressip($mac)
	#Sudo : $sudocountcmd cmd"
