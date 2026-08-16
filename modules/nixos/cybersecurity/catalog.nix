# LEENIX canonical cybersecurity capability registry.
#
# Single source of truth for the declarative cybersecurity catalog. Everything
# else in modules/nixos/cybersecurity/ is DERIVED from this file:
#   - options.nix     generates leenix.cybersecurity.<category>.<leaf>.enable
#   - assertions.nix  profile-gate / unfree / platform assertions
#   - checks.nix      frozen-count + consistency checks
#   - default.nix     package composition (imported by profiles/cybersecurity.nix)
#
# Leaf metadata:
#   description    human-readable capability description
#   kind           tool/framework/library/wordlist/external
#   classification "A" = normal global Nix package/data
#                  "E" = external/licensed integration (real launcher semantics)
#   packages       (A leaves) pkgs: -> [ pkg ... ]
#   resourcePath   (wordlist leaves) canonical share path relative to the package
#   integration    (E leaves) { exe; setup; } -> thin LEENIX launcher metadata
#   platforms      [ "x86_64-linux" "aarch64-linux" ]
#   guarded        defensive package selection (pkgs.X or null + availableOn)
#   unfree         requires nixpkgs.config.allowUnfree (never silently enabled)
#   heavy          large / slow / memory-heavy (informational)
{
  activeDirectory = {
    "bloodhound"        = { description = "BloodHound (AD attack-path GUI)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.bloodhound ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
    "bloodhound-python" = { description = "BloodHound Python client (AD collection)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.bloodhound-py ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "enum4linux-ng"     = { description = "enum4linux-ng (SMB/AD enumeration)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.enum4linux-ng ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "impacket"          = { description = "Impacket (Python AD/SMB framework)"; kind = "framework"; classification = "A"; packages = pkgs: [ pkgs.python3Packages.impacket ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "kerbrute"          = { description = "Kerbrute (Kerberos user enum/spray)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.kerbrute ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "ldapdomaindump"    = { description = "LDAP Domain Dump"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.ldapdomaindump ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "netexec"           = { description = "NetExec (AD/SMB automation, successor of crackmapexec)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.netexec ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "responder"         = { description = "Responder (LLMNR/NBT-NS poisoner)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.responder ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "smbmap"            = { description = "SMBMap (SMB share enumeration)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.smbmap ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  cloud = {
    "grype"      = { description = "Grype (container/artifact vulnerability scanner)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.grype ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "kubeaudit"  = { description = "Kubeaudit (Kubernetes security audit)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.kubeaudit ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "kube-bench" = { description = "kube-bench (CIS Kubernetes benchmark)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.kube-bench ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "kube-hunter" = { description = "kube-hunter (Kubernetes security hunter)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.kube-hunter ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "syft"       = { description = "Syft (SBOM generator)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.syft ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "trivy"      = { description = "Trivy (container/cloud vulnerability scanner)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.trivy ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  debugging = {
    "bpftrace"      = { description = "bpftrace (dynamic tracing)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.bpftrace ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "gdb"           = { description = "GDB (debugger)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.gdb ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "gdb-dashboard" = { description = "GDB Dashboard (visual gdb startup)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.gdb-dashboard ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "gef"           = { description = "GEF (GDB Enhanced Features)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.gef ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "heaptrack"     = { description = "heaptrack (heap profiler)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.heaptrack ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "lldb"          = { description = "LLDB (debugger)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.lldb ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "rr"            = { description = "rr (record/replay debugger)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.rr ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "strace"        = { description = "strace (syscall tracer)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.strace ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "valgrind"      = { description = "Valgrind (memory debugger)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.valgrind ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  discovery = {
    "arp-scan"  = { description = "arp-scan (layer-2 discovery)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.arp-scan ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "bettercap" = { description = "BetterCAP (MITM/network framework)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.bettercap ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "masscan"   = { description = "Masscan (fast port scanner)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.masscan ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "naabu"     = { description = "Naabu (fast port scanner)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.naabu ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "nmap"      = { description = "Nmap (network mapper)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.nmap ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "rustscan"  = { description = "RustScan (fast port scanner)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.rustscan ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  dns = {
    "amass"     = { description = "Amass (subdomain enumeration)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.amass ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "dnsenum"   = { description = "dnsenum (DNS enumeration)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.dnsenum ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "dnsrecon"  = { description = "dnsrecon (DNS recon)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.dnsrecon ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "dnsx"      = { description = "dnsx (fast DNS tool)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.dnsx ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "fierce"    = { description = "Fierce (DNS recon)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.fierce ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "subfinder" = { description = "Subfinder (subdomain discovery)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.subfinder ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  exploitation = {
    "exploitdb"  = { description = "ExploitDB / searchsploit"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.exploitdb ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "metasploit" = { description = "Metasploit Framework"; kind = "framework"; classification = "A"; packages = pkgs: [ pkgs.metasploit ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
  };
  forensics = {
    "autopsy"        = { description = "Autopsy (forensic GUI)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.autopsy ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
    "binwalk"        = { description = "Binwalk (firmware/binary analysis)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.binwalk ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "bulk_extractor" = { description = "bulk_extractor (evidence carving)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.bulk_extractor ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "exiftool"       = { description = "ExifTool (metadata extraction)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.exiftool ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "foremost"       = { description = "Foremost (file carving)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.foremost ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "scalpel"        = { description = "Scalpel (file carving)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.scalpel ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "sleuthkit"      = { description = "The Sleuth Kit (disk forensics CLI)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.sleuthkit ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "volatility3"    = { description = "Volatility 3 (memory forensics; VSL v1.0 non-free license)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.volatility3 ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = true; heavy = false; };
    "yara"           = { description = "YARA (pattern matching/malware detection)"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.yara ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  fuzzing = {
    "aflplusplus" = { description = "AFL++ (coverage-guided fuzzer)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.aflplusplus ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "honggfuzz"   = { description = "Honggfuzz (feedback-driven fuzzer)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.honggfuzz ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "radamsa"     = { description = "Radamsa (general-purpose fuzzer)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.radamsa ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  mobile = {
    "apktool"     = { description = "Apktool (Android APK decode/rebuild)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.apktool ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "frida-tools" = { description = "Frida tools (runtime instrumentation)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.frida-tools ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "jadx"        = { description = "JADX (Android/DEX decompiler)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.jadx ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
    "objection"   = { description = "Objection (Android/iOS runtime pwn)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.objection ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  network = {
    "tcpdump"   = { description = "tcpdump (packet capture CLI)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.tcpdump ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "tshark"    = { description = "tshark (Wireshark CLI capture)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.tshark ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "wireshark" = { description = "Wireshark (GUI packet analyzer)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.wireshark ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  osint = {
    "holehe"       = { description = "Holehe (email-to-account check)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.holehe ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "maigret"      = { description = "Maigret (username OSINT)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.maigret ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "recon-ng"     = { description = "Recon-ng (recon framework)"; kind = "framework"; classification = "A"; packages = pkgs: [ pkgs.recon-ng ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "sherlock"     = { description = "Sherlock (username OSINT)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.sherlock ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "theHarvester" = { description = "theHarvester (email/domain OSINT)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.theharvester ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  passwordAuditing = {
    "cewl"     = { description = "CeWL (wordlist generator from websites)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.cewl ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "crunch"   = { description = "Crunch (wordlist generator)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.crunch ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "hashcat"  = { description = "Hashcat (password cracker)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.hashcat ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "hydra"    = { description = "THC Hydra (online password cracker)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.thc-hydra ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "john"     = { description = "John the Ripper (password cracker)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.john ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "ophcrack" = { description = "Ophcrack (LM/NTLM rainbow-table cracker)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.ophcrack ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  proxy = {
    "burpsuiteCommunity"    = { description = "Burp Suite Community (proprietary; GUI)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.burpsuite ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = true; heavy = true; };
    "burpsuiteProfessional" = { description = "Burp Suite Professional (commercial; external integration)"; kind = "external"; classification = "E"; integration = { exe = "BurpSuitePro"; setup = "Download Burp Suite Professional from https://portswigger.net/burp/pro and install it on PATH."; }; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "mitmproxy"             = { description = "mitmproxy (interception proxy)"; kind = "framework"; classification = "A"; packages = pkgs: [ pkgs.mitmproxy ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "proxychains"           = { description = "proxychains (force proxy through CLI)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.proxychains ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "zap"                   = { description = "OWASP ZAP (web app proxy/scanner)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.zap ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
  };
  reverseEngineering = {
    "angr"       = { description = "angr (symbolic execution framework)"; kind = "framework"; classification = "A"; packages = pkgs: [ pkgs.python3Packages.angr ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
    "binaryNinja" = { description = "Binary Ninja (commercial; external integration)"; kind = "external"; classification = "E"; integration = { exe = "binaryninja"; setup = "Download Binary Ninja from https://binary.ninja and install it on PATH."; }; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "binutils"   = { description = "binutils (objdump/readelf/nm)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.binutils ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "capstone"   = { description = "Capstone (disassembly framework)"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.capstone ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "cutter"     = { description = "Cutter (radare2 GUI)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.cutter ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "ghidra"     = { description = "Ghidra (NSA RE suite)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.ghidra ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
    "hopper"     = { description = "Hopper Disassembler (commercial; external integration)"; kind = "external"; classification = "E"; integration = { exe = "hopper"; setup = "Download Hopper from https://www.hopperapp.com and install it on PATH."; }; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "idaFree"    = { description = "IDA Free (commercial; external integration)"; kind = "external"; classification = "E"; integration = { exe = "ida64"; setup = "Download IDA Free from https://hex-rays.com/ida-free and install it on PATH."; }; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "idaPro"     = { description = "IDA Pro (commercial; external integration)"; kind = "external"; classification = "E"; integration = { exe = "ida64"; setup = "Install IDA Pro from https://hex-rays.com and put it on PATH."; }; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "keystone"   = { description = "Keystone (assembly framework)"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.keystone ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "lief"       = { description = "LIEF (binary parsing/editing library)"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.lief ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "patchelf"   = { description = "patchelf (ELF binary patching)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.patchelf ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "radare2"    = { description = "radare2 (binary analysis framework)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.radare2 ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "rizin"      = { description = "Rizin (binary analysis framework)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.rizin ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "unicorn"    = { description = "Unicorn Engine (CPU emulation framework)"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.unicorn ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  scanning = {
    "nuclei" = { description = "Nuclei (template vulnerability scanner)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.nuclei ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "nikto"  = { description = "Nikto (web server scanner)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.nikto ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "wpscan" = { description = "WPScan (WordPress scanner)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.wpscan ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  staticAnalysis = {
    "bandit"     = { description = "Bandit (Python SAST)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.bandit ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "checkov"    = { description = "Checkov (IaC security)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.checkov ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "gitleaks"   = { description = "Gitleaks (secret scanning)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.gitleaks ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "semgrep"    = { description = "Semgrep (static analysis)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.semgrep ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "trufflehog" = { description = "TruffleHog (secret scanning)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.trufflehog ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  web = {
    "commix"      = { description = "Commix (command injection)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.commix ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "dalfox"      = { description = "Dalfox (XSS scanner)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.dalfox ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "feroxbuster" = { description = "Feroxbuster (content discovery)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.feroxbuster ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "ffuf"        = { description = "FFUF (web fuzzer)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.ffuf ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "gau"         = { description = "gau (getallurls)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.gau ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "gobuster"    = { description = "Gobuster (content/dir fuzzer)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.gobuster ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "httprobe"    = { description = "httprobe (HTTP probing)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.httprobe ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "httpx"       = { description = "httpx (HTTP toolkit)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.httpx ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "katana"      = { description = "Katana (crawler)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.katana ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "sqlmap"      = { description = "SQLMap (SQL injection)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.sqlmap ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "wfuzz"       = { description = "WFuzz (web fuzzer)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.wfuzz ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  wireless = {
    "aircrack-ng" = { description = "Aircrack-ng (Wi-Fi auditing suite)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.aircrack-ng ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "bully"       = { description = "Bully (WPS brute-force)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.bully ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "hcxtools"    = { description = "hcxtools (Wi-Fi capture conversion)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.hcxtools ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "kismet"      = { description = "Kismet (Wi-Fi detector/IDS)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.kismet ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  wordlists = {
    "fuzzdb"              = { description = "FuzzDB (fuzzing payload collection)"; kind = "wordlist"; classification = "A"; packages = pkgs: [ pkgs.fuzzdb ]; resourcePath = "share/fuzzdb"; linkPath = "/share/fuzzdb"; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "payloadsAllTheThings" = { description = "PayloadsAllTheThings (web payload collection)"; kind = "wordlist"; classification = "A"; packages = pkgs: [ pkgs.payloadsallthethings ]; resourcePath = "share/payloadsallthethings"; linkPath = "/share/payloadsallthethings"; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    "rockyou"             = { description = "RockYou password dictionary"; kind = "wordlist"; classification = "A"; packages = pkgs: [ pkgs.rockyou ]; resourcePath = "share/wordlists/rockyou.txt"; linkPath = "/share/wordlists"; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
    "seclists"            = { description = "SecLists (comprehensive security wordlists)"; kind = "wordlist"; classification = "A"; packages = pkgs: [ pkgs.seclists ]; resourcePath = "share/wordlists/seclists"; linkPath = "/share/wordlists"; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
  };
}
