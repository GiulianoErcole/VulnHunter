VulnHunter - Network Scanner & Vulnerability Hunter

VulnHunter is a powerful network scanning script built with nmap, designed to scan multiple targets, detect vulnerabilities, and provide detailed post-scan analysis. It integrates NSE scripts (Nmap Scripting Engine) for enhanced scanning and vulnerability detection.

Features

Multi-target scanning (single IP, IP range, or subnet).

Customizable scan modes: intense, quick, stealth, udp, and all.

Built-in support for NSE scripts (default, vuln, discovery, ssl, and more).

Real-time progress output during scans.

Post-scan analysis for open ports, services, OS detection, and vulnerabilities.

Save results in plain text or JSON format.

Backup scan results and perform custom analysis with grep.



Prerequisites

Before using this script, you need to have the following:

Nmap: Make sure nmap is installed. You can install it with the following:

Debian/Ubuntu: sudo apt-get install nmap

RedHat/CentOS: sudo yum install nmap

macOS: brew install nmap

xml2json: Required for converting Nmap XML outputs to JSON format:

Debian/Ubuntu: sudo apt-get install xml2json

macOS: brew install xml2json

Usage
Running the Script
./vulnhunter.sh <target_ip_or_range> [options]


Options:

<target_ip_or_range>: The target IP address or range (e.g., 192.168.1.1, 192.168.1.0/24).

-m <scan_mode>: Specify the scan mode. Available options:

intense – Full scan with aggressive options (default).

quick – Fast scan with fewer options.

stealth – Stealth SYN scan (recommended for evading detection).

udp – UDP port scan.

all – Combined TCP & UDP scan with service discovery and vulnerability checks.

-p <port_range>: Specify the port range (default: 1-65535). Example: 1-1024, 80,443, etc.

-t <timeout>: Set the timeout for each scan (default: 30 seconds).

-j: Output results in JSON format. This will generate a vulnhunter_scan.json file.

-n: Enable NSE scripts during the scan. Includes default, vuln, discovery, and ssl scripts.

-h: Show the help message.


Example Commands
Basic Scan:

./vulnhunter.sh 192.168.1.1 -m intense -p 1-65535 -t 30

This command will:

Scan the target 192.168.1.1 with the intense scan mode.

Scan all ports from 1 to 65535.

Set a timeout of 30 seconds for each scan.


Scan with NSE Scripts:
./vulnhunter.sh 192.168.1.1 -n -m intense -p 1-65535 -t 30 -j

This command will:

Enable NSE scripts to run during the scan (-n flag).

Output the results in JSON format (-j flag).


Quick Scan for a Range of IPs
./vulnhunter.sh 192.168.1.0/24 -n -m quick -p 1-1024 -t 20

This command will:

Scan the entire subnet 192.168.1.0/24.

Use the quick scan mode.

Scan ports 1-1024 and set the timeout to 20 seconds.


Post-Scan Analysis

After the scan completes, you will have the option to perform additional post-scan analysis. You will be prompted with the following options:

List open ports: Display all open ports from the scan results.

Identify running services: Show services detected on the open ports.

Detect OS and Version: Extract operating system and version information.

Show detailed vulnerabilities: Display vulnerabilities detected in the scan.

Run additional NSE scripts: Run additional NSE scripts (e.g., vuln, discovery).

Save results to backup: Create a timestamped backup of the scan results.

Custom Analysis (grep-based): Enter a custom grep search pattern to analyze the results.


Example Post-Scan NSE Script Execution

After the scan is completed, you can choose option 5 to run additional NSE scripts for vulnerability scanning or service discovery.

The script will automatically run NSE scripts such as:
nmap -T4 -A -sS -p 1-65535 --script vuln,discovery 192.168.1.1 -oN additional_nse_results.txt

This will execute the vuln and discovery NSE scripts and save the output to additional_nse_results.txt.


Files Generated

Scan Output (vulnhunter_scan_<timestamp>.txt): A detailed log of the scan, including open ports, services, and detected vulnerabilities.

JSON Output (vulnhunter_scan.json): Scan results in JSON format (if the -j flag is used).

Backup Files: Scan results can be backed up and compressed as .gz files.



Backup and Restore
Backup Scan Results

To create a backup of your scan results:
cp vulnhunter_scan_<timestamp>.txt vulnhunter_backup_<timestamp>.txt
gzip vulnhunter_backup_<timestamp>.txt



Restore Scan Results

If you need to restore a backup:
gunzip vulnhunter_backup_<timestamp>.txt.gz
cat vulnhunter_backup_<timestamp>.txt



Advanced Customization

You can modify the script to include additional NSE scripts or categories. For example, change the NSE_SCRIPTS_OPTIONS line in the script to include other NSE categories like brute, exploit, etc.

NSE_SCRIPTS_OPTIONS="--script vuln,discovery,brute,exploit"



Notes

NSE Scripts: The nmap scripting engine allows you to extend nmap's capabilities by using a variety of scripts for different tasks. The default scripts (default, vuln, discovery, ssl) are preconfigured to cover a wide range of vulnerabilities and service discovery tasks.

Permissions: Depending on your system and the ports being scanned, you may need to run the script with elevated privileges (e.g., sudo).

sudo ./vulnhunter.sh 192.168.1.1 -n -m intense -p 1-65535 -t 30


License

This script is provided under the MIT License. You are free to use, modify, and distribute the script as long as you include the original license.









































































































