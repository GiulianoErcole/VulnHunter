#!/bin/bash

# VulnHunter Script v1.0
# Features: Multi-target scans, real-time progress, advanced options, customizable scan modes, enhanced reporting, and NSE scripts

# welcome message
echo "------------------------------------------------------"
echo "  Welcome to VulnHunter! Your Powerful Network Scanner."
echo "------------------------------------------------------"

# Set default scan parameters
DEFAULT_SCAN_MODE="stealth"
DEFAULT_PORT_RANGE="1-65535"
DEFAULT_TIMEOUT="150"
DEFAULT_THREAD_COUNT="4"

# Function to show usage
usage() {
    echo "Usage: $0 <target_ips> [options]"
    echo "Options:"
    echo "  -m <scan_mode>      Set scan mode (intense, quick, stealth, udp, all)"
    echo "  -p <port_range>     Specify custom port range (default: 1-65535)"
    echo "  -t <timeout>        Set scan timeout in seconds (default: 150)"
    echo "  -j                  Output results in JSON format"
    echo "  -h                  Show this help message"
    echo "  -n                  Enable NSE scripts during scan"
    exit 1
}

# Validate the target IP(s) or range, must come before getopts shift
if [ -z "$1" ]; then
    echo "Error: No target IP or range specified."
    usage
fi

TARGET="$1"
shift  # shift so getopts processes the remaining flags correctly

# Parse command-line arguments
while getopts ":m:p:t:jhn" opt; do
    case "$opt" in
        m) SCAN_MODE="$OPTARG" ;;
        p) PORT_RANGE="$OPTARG" ;;
        t) TIMEOUT="$OPTARG" ;;
        j) JSON_OUTPUT=true ;;
        h) usage ;;
        n) NSE_SCRIPTS=true ;;
        *) usage ;;
    esac
done

# Set defaults if not provided
SCAN_MODE=${SCAN_MODE:-$DEFAULT_SCAN_MODE}
PORT_RANGE=${PORT_RANGE:-$DEFAULT_PORT_RANGE}
TIMEOUT=${TIMEOUT:-$DEFAULT_TIMEOUT}

# Define the scan options based on the scan mode
case "$SCAN_MODE" in
    "intense")
        SCAN_OPTIONS="-T4 -A -v --open --max-retries 3 --min-rate 1000"
        ;;
    "quick")
        SCAN_OPTIONS="-T4 -F --open"
        ;;
    "stealth")
        SCAN_OPTIONS="-T4 -sS --open"
        ;;
    "udp")
        SCAN_OPTIONS="-T4 -sU --open"
        ;;
    "all")
        SCAN_OPTIONS="-T4 -A -sS -sU -p $PORT_RANGE --open"
        ;;
    *)
        echo "Invalid scan mode specified. Defaulting to 'intense'."
        SCAN_OPTIONS="-T4 -A -v --open --max-retries 3 --min-rate 1000"
        ;;
esac

# NSE Scripts Integration
if [ "$NSE_SCRIPTS" = true ]; then
    NSE_SCRIPTS_OPTIONS="--script default,vuln,discovery,ssl"
    echo "NSE Scripts will be enabled during scan."
else
    NSE_SCRIPTS_OPTIONS=""
fi

# Show the scan parameters and ask for confirmation
echo "------------------------------------------------------"
echo "Target: $TARGET"
echo "Scan Mode: $SCAN_MODE"
echo "Port Range: $PORT_RANGE"
echo "Timeout: $TIMEOUT seconds"
echo "NSE Scripts: ${NSE_SCRIPTS:-No}"
echo "------------------------------------------------------"
read -p "Do you want to start the scan? (y/n): " start_scan

if [[ "$start_scan" != "y" ]]; then
    echo "Scan aborted."
    exit 0
fi

# Start scan with progress output
OUTPUT_FILE="vulnhunter_scan_$(date +%Y%m%d_%H%M%S).txt"
echo "Starting scan... Results will be saved to $OUTPUT_FILE"
nmap $SCAN_OPTIONS $NSE_SCRIPTS_OPTIONS -p "$PORT_RANGE" --host-timeout "${TIMEOUT}s" "$TARGET" -oN "$OUTPUT_FILE" | tee /dev/tty | tail -n 10

# Output JSON format if requested
if [ "$JSON_OUTPUT" = true ]; then
    echo "Converting output to JSON format..."
    XML_FILE="vulnhunter_scan_$(date +%Y%m%d_%H%M%S).xml"
    nmap $SCAN_OPTIONS $NSE_SCRIPTS_OPTIONS -p "$PORT_RANGE" --host-timeout "${TIMEOUT}s" "$TARGET" -oX "$XML_FILE"
    # xml2json may not be available; use python as a portable fallback
    if command -v xml2json &>/dev/null; then
        xml2json "$XML_FILE" > vulnhunter_scan.json
    elif command -v python3 &>/dev/null; then
        python3 -c "
import xml.etree.ElementTree as ET, json, sys
tree = ET.parse('$XML_FILE')
def elem_to_dict(e):
    d = {'tag': e.tag, 'attrib': e.attrib, 'text': e.text, 'children': [elem_to_dict(c) for c in e]}
    return d
print(json.dumps(elem_to_dict(tree.getroot()), indent=2))
" > vulnhunter_scan.json
    else
        echo "Warning: Neither xml2json nor python3 found. JSON conversion skipped."
    fi
    echo "JSON output saved to vulnhunter_scan.json"
fi

# Enhanced Post-Scan Analysis with NSE Scripts
echo "------------------------------------------------------"
echo "Post-scan analysis options:"
echo "1) List open ports"
echo "2) Identify running services"
echo "3) Detect OS and Version"
echo "4) Show detailed vulnerabilities"
echo "5) Run additional NSE scripts"
echo "6) Save results to a timestamped backup"
echo "7) Custom Analysis (grep-based)"
echo "------------------------------------------------------"
read -p "Select post-scan analysis option (1-7): " analysis_choice

case "$analysis_choice" in
    1)
        echo "Open Ports:"
        grep -i "open" "$OUTPUT_FILE" || echo "No open ports detected."
        ;;
    2)
        echo "Running Services:"
        grep -i "service" "$OUTPUT_FILE" || echo "No service information found."
        ;;
    3)
        echo "OS & Version Detection:"
        grep -i "os details" "$OUTPUT_FILE" || echo "No OS and version information detected."
        ;;
    4)
        echo "Vulnerabilities Detected (if any):"
        grep -i "vuln" "$OUTPUT_FILE" || echo "No vulnerabilities detected."
        ;;
    5)
        echo "Running additional NSE scripts for post-scan analysis..."
        nmap $SCAN_OPTIONS --script vuln,discovery -p "$PORT_RANGE" --host-timeout "${TIMEOUT}s" "$TARGET" -oN additional_nse_results.txt
        echo "NSE script analysis complete. Results saved to additional_nse_results.txt"
        ;;
    6)
        BACKUP_FILE="vulnhunter_backup_$(date +%Y%m%d_%H%M%S).txt"
        cp "$OUTPUT_FILE" "$BACKUP_FILE"
        gzip "$BACKUP_FILE"
        echo "Results saved to backup file: ${BACKUP_FILE}.gz"
        ;;
    7)
        read -p "Enter custom grep search pattern: " custom_pattern
        echo "Custom grep analysis:"
        grep -i "$custom_pattern" "$OUTPUT_FILE" || echo "No matches found for the custom pattern."
        ;;
    *)
        echo "Invalid choice. No post-scan analysis performed."
        ;;
esac

echo "------------------------------------------------------"
echo "Scan complete. Check the results above for details."
echo "------------------------------------------------------"
