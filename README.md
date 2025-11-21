# VulnHunter 🕵️‍♂️  
**Network Scanner & Vulnerability Hunter**

VulnHunter is a powerful wrapper around **Nmap** designed to scan multiple targets, detect vulnerabilities, and generate actionable reports. It leverages the **Nmap Scripting Engine (NSE)** for enhanced fingerprinting, service discovery, and vulnerability detection.

---

## ✨ Features

- 🎯 **Multi-target support**: Single IP, IP range, or whole subnet.
- ⚙️ **Scan modes**:
  - `intense` – aggressive, full-featured scan (default)
  - `quick` – fast, lightweight scan
  - `stealth` – SYN scan for reduced detection
  - `udp` – UDP port scan
  - `all` – combined TCP & UDP with service & vuln checks
- 📜 **NSE integration**:
  - Default, `vuln`, `discovery`, `ssl`, and more
- ⏱️ **Real-time progress output**
- 🔎 **Post-scan analysis menu**:
  - Open ports
  - Services
  - OS & version detection
  - Vulnerabilities
  - Additional NSE runs
  - Grep-based custom analysis
- 💾 **Output options**:
  - Plain text logs
  - JSON output
  - Timestamped backups & restore flow

---

## 📦 Prerequisites

### Nmap

```bash
sudo apt-get install nmap
# or
brew install nmap
```

### xml2json (for JSON output)

```bash
sudo apt-get install xml2json
# or
brew install xml2json
```

---

## 🚀 Usage

```bash
./vulnhunter.sh <target_ip_or_range> [options]
```

**Options:**

- `-m <mode>` → intense, quick, stealth, udp, all  
- `-p <ports>` → e.g., 1-65535, 80,443  
- `-t <timeout>` → timeout per scan  
- `-j` → JSON output  
- `-n` → Enable NSE scripts  
- `-h` → Help  

---

## 📚 Examples

### Intense scan

```bash
./vulnhunter.sh 192.168.1.1 -m intense -p 1-65535 -t 30
```

### Full scan with NSE + JSON

```bash
sudo ./vulnhunter.sh 192.168.1.1 -n -m intense -p 1-65535 -t 30 -j
```

### Quick subnet scan

```bash
./vulnhunter.sh 192.168.1.0/24 -n -m quick -p 1-1024 -t 20
```

---

## 🧠 Post-Scan Analysis

Interactive menu includes:

1. Open ports  
2. Service detection  
3. OS detection  
4. Vulnerability list  
5. Additional NSE scans  
6. Save backups  
7. Custom grep analysis  

---

## 📂 Output Files

- `vulnhunter_scan_<timestamp>.txt`  
- `vulnhunter_scan.json`  
- `vulnhunter_backup_<timestamp>.txt.gz`  

---

## 🔧 Advanced Customization

```bash
NSE_SCRIPTS_OPTIONS="--script vuln,discovery,brute,exploit"
```

---

## ⚠️ Legal

Only scan systems you **own** or have **explicit permission** to test.

---

## 📄 License

MIT License
