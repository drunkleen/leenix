# Host cybersecurity policy control panel — every accepted catalog leaf is
# explicitly listed, alphabetically ordered, all false by default.
#
# DATA / POLICY ONLY: booleans. Tool/data implementation and capability
# metadata live in modules/nixos/cybersecurity/catalog.nix.
# profiles.cybersecurity (the master gate) is owned by variables/profiles.nix.
# Only flip leaves to true after enabling profiles.cybersecurity.
{
  cybersecurity = {
    activeDirectory = {
      bloodhound = false;
      bloodhound-python = false;
      enum4linux-ng = false;
      impacket = false;
      kerbrute = false;
      ldapdomaindump = false;
      netexec = false;
      responder = false;
      smbmap = false;
    };
    cloud = {
      grype = false;
      kube-bench = false;
      kube-hunter = false;
      kubeaudit = false;
      syft = false;
      trivy = false;
    };
    debugging = {
      bpftrace = false;
      gdb = false;
      gdb-dashboard = false;
      gef = false;
      heaptrack = false;
      lldb = false;
      rr = false;
      strace = false;
      valgrind = false;
    };
    discovery = {
      arp-scan = true;
      bettercap = false;
      masscan = false;
      naabu = false;
      nmap = true;
      rustscan = true;
    };
    dns = {
      amass = false;
      dnsenum = false;
      dnsrecon = false;
      dnsx = false;
      fierce = false;
      subfinder = false;
    };
    exploitation = {
      exploitdb = false;
      metasploit = true;
    };
    forensics = {
      autopsy = false;
      binwalk = false;
      bulk_extractor = false;
      exiftool = false;
      foremost = false;
      scalpel = false;
      sleuthkit = false;
      volatility3 = false;
      yara = false;
    };
    fuzzing = {
      aflplusplus = false;
      honggfuzz = false;
      radamsa = false;
    };
    mobile = {
      apktool = false;
      frida-tools = false;
      jadx = false;
      objection = false;
    };
    network = {
      tcpdump = true;
      tshark = false;
      wireshark = true;
    };
    osint = {
      holehe = false;
      maigret = false;
      recon-ng = false;
      sherlock = false;
      theHarvester = false;
    };
    passwordAuditing = {
      cewl = false;
      crunch = false;
      hashcat = true;
      hydra = true;
      john = true;
      ophcrack = false;
    };
    proxy = {
      burpsuiteCommunity = false;
      burpsuiteProfessional = false;
      mitmproxy = false;
      proxychains = false;
      zap = false;
    };
    reverseEngineering = {
      angr = false;
      binaryNinja = false;
      binutils = false;
      capstone = false;
      cutter = false;
      ghidra = true;
      hopper = false;
      idaFree = false;
      idaPro = false;
      keystone = false;
      lief = false;
      patchelf = false;
      radare2 = false;
      rizin = false;
      unicorn = false;
    };
    scanning = {
      nikto = true;
      nuclei = false;
      wpscan = true;
    };
    staticAnalysis = {
      bandit = false;
      checkov = false;
      gitleaks = false;
      semgrep = false;
      trufflehog = false;
    };
    web = {
      commix = false;
      dalfox = false;
      feroxbuster = false;
      ffuf = false;
      gau = false;
      gobuster = true;
      httprobe = false;
      httpx = false;
      katana = false;
      sqlmap = true;
      wfuzz = false;
    };
    wireless = {
      aircrack-ng = false;
      bully = false;
      hcxtools = false;
      kismet = false;
    };
    wordlists = {
      fuzzdb = false;
      payloadsAllTheThings = false;
      rockyou = false;
      seclists = true;
    };
  };
}
