{ ... }:

# Direct typed-policy reproduction of the effective legacy tuf-f15
# `config.leenix` tree (migration proof fixture - Phase 9G.2A).

# Runtime instance metadata (instance-owned; see leenix.instance.*).
{
  leenix = {
    "ai" = {
      "codingAgents" = {
        "claudeCode" = {
          "enable" = false;
        };
        "codex" = {
          "enable" = true;
        };
        "geminiCli" = {
          "enable" = false;
        };
        "goose" = {
          "enable" = false;
        };
        "openclaw" = {
          "enable" = false;
        };
        "opencode" = {
          "enable" = true;
        };
        "qwenCode" = {
          "enable" = false;
        };
      };
      "localRuntimes" = {
        "gpt4all" = {
          "enable" = false;
        };
        "jan" = {
          "enable" = false;
        };
        "koboldcpp" = {
          "enable" = false;
        };
        "llamaCpp" = {
          "enable" = false;
        };
        "lmstudio" = {
          "enable" = false;
        };
        "ollama" = {
          "enable" = false;
        };
      };
      "mcp" = {
        "mcpProxy" = {
          "enable" = false;
        };
      };
      "utilities" = {
        "aider" = {
          "enable" = false;
        };
        "fabric" = {
          "enable" = false;
        };
      };
    };
    "applications" = {
      "communication" = {
        "discord" = {
          "enable" = true;
        };
        "elementDesktop" = {
          "enable" = false;
        };
        "ferdium" = {
          "enable" = false;
        };
        "mumble" = {
          "enable" = false;
        };
        "nheko" = {
          "enable" = false;
        };
        "pidgin" = {
          "enable" = false;
        };
        "revoltDesktop" = {
          "enable" = false;
        };
        "sessionDesktop" = {
          "enable" = false;
        };
        "signalDesktop" = {
          "enable" = true;
        };
        "slack" = {
          "enable" = false;
        };
        "teams" = {
          "enable" = false;
        };
        "telegramDesktop" = {
          "enable" = true;
        };
        "tokodon" = {
          "enable" = false;
        };
        "zoom" = {
          "enable" = false;
        };
      };
      "containers" = {
        "boxbuddy" = {
          "enable" = false;
        };
      };
      "creative" = {
        "audacity" = {
          "enable" = false;
        };
        "darktable" = {
          "enable" = false;
        };
        "gimp" = {
          "enable" = true;
        };
        "handbrake" = {
          "enable" = false;
        };
        "inkscape" = {
          "enable" = false;
        };
        "kdenlive" = {
          "enable" = false;
        };
        "krita" = {
          "enable" = false;
        };
        "obsStudio" = {
          "enable" = true;
        };
        "openshot" = {
          "enable" = false;
        };
        "penpotDesktop" = {
          "enable" = false;
        };
        "rawtherapee" = {
          "enable" = false;
        };
        "shotcut" = {
          "enable" = false;
        };
      };
      "documents" = {
        "calibre" = {
          "enable" = false;
        };
        "evince" = {
          "enable" = false;
        };
        "foliate" = {
          "enable" = false;
        };
        "okular" = {
          "enable" = false;
        };
        "papers" = {
          "enable" = false;
        };
        "pdfArranger" = {
          "enable" = false;
        };
      };
      "email" = {
        "evolution" = {
          "enable" = false;
        };
        "geary" = {
          "enable" = false;
        };
        "protonmailBridge" = {
          "enable" = false;
        };
        "protonmailDesktop" = {
          "enable" = false;
        };
        "thunderbird" = {
          "enable" = true;
        };
      };
      "finance" = {
        "gnucash" = {
          "enable" = false;
        };
        "kmymoney" = {
          "enable" = false;
        };
      };
      "notes" = {
        "affine" = {
          "enable" = false;
        };
        "anytype" = {
          "enable" = false;
        };
        "appflowy" = {
          "enable" = false;
        };
        "jabref" = {
          "enable" = false;
        };
        "joplinDesktop" = {
          "enable" = false;
        };
        "logseq" = {
          "enable" = false;
        };
        "notesnook" = {
          "enable" = false;
        };
        "obsidian" = {
          "enable" = false;
        };
        "zotero" = {
          "enable" = false;
        };
      };
      "office" = {
        "freeoffice" = {
          "enable" = false;
        };
        "libreoffice" = {
          "enable" = true;
        };
        "onlyoffice" = {
          "enable" = false;
        };
      };
      "password" = {
        "bitwarden" = {
          "enable" = true;
        };
        "keepassxc" = {
          "enable" = false;
        };
        "onePassword" = {
          "enable" = false;
        };
      };
      "reading" = {
        "koodoReader" = {
          "enable" = false;
        };
        "liferea" = {
          "enable" = false;
        };
        "newsboat" = {
          "enable" = false;
        };
        "newsflash" = {
          "enable" = false;
        };
        "rssguard" = {
          "enable" = false;
        };
      };
      "remoteAccess" = {
        "anydesk" = {
          "enable" = false;
        };
        "lookingGlass" = {
          "enable" = false;
        };
        "moonlight" = {
          "enable" = false;
        };
        "parsec" = {
          "enable" = false;
        };
        "realVncViewer" = {
          "enable" = false;
        };
        "remmina" = {
          "enable" = false;
        };
        "rustdesk" = {
          "enable" = true;
        };
        "sunshine" = {
          "enable" = false;
        };
        "teamviewer" = {
          "enable" = false;
        };
        "tigervnc" = {
          "enable" = false;
        };
      };
      "streaming" = {
        "feishin" = {
          "enable" = false;
        };
        "freetube" = {
          "enable" = false;
        };
        "spotify" = {
          "enable" = true;
        };
        "tidalHifi" = {
          "enable" = false;
        };
      };
      "sync" = {
        "dropbox" = {
          "enable" = false;
        };
        "megasync" = {
          "enable" = false;
        };
        "syncthing" = {
          "enable" = false;
        };
        "syncthingTray" = {
          "enable" = false;
        };
      };
      "system" = {
        "gearlever" = {
          "enable" = false;
        };
        "gnomeSoftware" = {
          "enable" = false;
        };
        "missionCenter" = {
          "enable" = false;
        };
        "rpiImager" = {
          "enable" = false;
        };
        "warehouse" = {
          "enable" = false;
        };
      };
      "tasks" = {
        "endeavour" = {
          "enable" = false;
        };
        "planner" = {
          "enable" = false;
        };
        "todoist" = {
          "enable" = false;
        };
      };
      "torrenting" = {
        "deluge" = {
          "enable" = false;
        };
        "qbittorrent" = {
          "enable" = false;
        };
        "transmission" = {
          "enable" = false;
        };
      };
    };
    "boot" = {
      "kernel" = {
        "channel" = "latest";
        "version" = null;
      };
      "limine" = {
        "extraEntries" = "/Windows\n    protocol: efi\n    path: guid(8adec9ed-2e11-4ca8-9cd5-8626d8733170):/EFI/Microsoft/Boot/bootmgfw.efi\n";
      };
      "loader" = "limine";
      "plymouth" = {
        "enable" = true;
      };
      "visual" = {
        "enable" = true;
        "verbose" = false;
      };
    };
    "bootstrap" = {
      "audio" = "wiremix";
      "bluetooth" = "bluetui";
      "enable" = true;
      "wifi" = "impala";
    };
    "cursor" = {
      "size" = 36;
      "theme" = "capitaine-cursors";
    };
    "cybersecurity" = {
      "activeDirectory" = {
        "bloodhound" = {
          "enable" = false;
        };
        "bloodhound-python" = {
          "enable" = false;
        };
        "enum4linux-ng" = {
          "enable" = false;
        };
        "impacket" = {
          "enable" = false;
        };
        "kerbrute" = {
          "enable" = false;
        };
        "ldapdomaindump" = {
          "enable" = false;
        };
        "netexec" = {
          "enable" = false;
        };
        "responder" = {
          "enable" = false;
        };
        "smbmap" = {
          "enable" = false;
        };
      };
      "cloud" = {
        "grype" = {
          "enable" = false;
        };
        "kube-bench" = {
          "enable" = false;
        };
        "kube-hunter" = {
          "enable" = false;
        };
        "kubeaudit" = {
          "enable" = false;
        };
        "syft" = {
          "enable" = false;
        };
        "trivy" = {
          "enable" = false;
        };
      };
      "debugging" = {
        "bpftrace" = {
          "enable" = false;
        };
        "gdb" = {
          "enable" = false;
        };
        "gdb-dashboard" = {
          "enable" = false;
        };
        "gef" = {
          "enable" = false;
        };
        "heaptrack" = {
          "enable" = false;
        };
        "lldb" = {
          "enable" = false;
        };
        "rr" = {
          "enable" = false;
        };
        "strace" = {
          "enable" = false;
        };
        "valgrind" = {
          "enable" = false;
        };
      };
      "discovery" = {
        "arp-scan" = {
          "enable" = true;
        };
        "bettercap" = {
          "enable" = false;
        };
        "masscan" = {
          "enable" = false;
        };
        "naabu" = {
          "enable" = false;
        };
        "nmap" = {
          "enable" = true;
        };
        "rustscan" = {
          "enable" = true;
        };
      };
      "dns" = {
        "amass" = {
          "enable" = false;
        };
        "dnsenum" = {
          "enable" = false;
        };
        "dnsrecon" = {
          "enable" = false;
        };
        "dnsx" = {
          "enable" = false;
        };
        "fierce" = {
          "enable" = false;
        };
        "subfinder" = {
          "enable" = false;
        };
      };
      "exploitation" = {
        "exploitdb" = {
          "enable" = false;
        };
        "metasploit" = {
          "enable" = true;
        };
      };
      "forensics" = {
        "autopsy" = {
          "enable" = false;
        };
        "binwalk" = {
          "enable" = false;
        };
        "bulk_extractor" = {
          "enable" = false;
        };
        "exiftool" = {
          "enable" = false;
        };
        "foremost" = {
          "enable" = false;
        };
        "scalpel" = {
          "enable" = false;
        };
        "sleuthkit" = {
          "enable" = false;
        };
        "volatility3" = {
          "enable" = false;
        };
        "yara" = {
          "enable" = false;
        };
      };
      "fuzzing" = {
        "aflplusplus" = {
          "enable" = false;
        };
        "honggfuzz" = {
          "enable" = false;
        };
        "radamsa" = {
          "enable" = false;
        };
      };
      "mobile" = {
        "apktool" = {
          "enable" = false;
        };
        "frida-tools" = {
          "enable" = false;
        };
        "jadx" = {
          "enable" = false;
        };
        "objection" = {
          "enable" = false;
        };
      };
      "network" = {
        "tcpdump" = {
          "enable" = true;
        };
        "tshark" = {
          "enable" = false;
        };
        "wireshark" = {
          "enable" = true;
        };
      };
      "osint" = {
        "holehe" = {
          "enable" = false;
        };
        "maigret" = {
          "enable" = false;
        };
        "recon-ng" = {
          "enable" = false;
        };
        "sherlock" = {
          "enable" = false;
        };
        "theHarvester" = {
          "enable" = false;
        };
      };
      "passwordAuditing" = {
        "cewl" = {
          "enable" = false;
        };
        "crunch" = {
          "enable" = false;
        };
        "hashcat" = {
          "enable" = true;
        };
        "hydra" = {
          "enable" = true;
        };
        "john" = {
          "enable" = true;
        };
        "ophcrack" = {
          "enable" = false;
        };
      };
      "proxy" = {
        "burpsuiteCommunity" = {
          "enable" = false;
        };
        "burpsuiteProfessional" = {
          "enable" = false;
        };
        "mitmproxy" = {
          "enable" = false;
        };
        "proxychains" = {
          "enable" = false;
        };
        "zap" = {
          "enable" = false;
        };
      };
      "reverseEngineering" = {
        "angr" = {
          "enable" = false;
        };
        "binaryNinja" = {
          "enable" = false;
        };
        "binutils" = {
          "enable" = false;
        };
        "capstone" = {
          "enable" = false;
        };
        "cutter" = {
          "enable" = false;
        };
        "ghidra" = {
          "enable" = true;
        };
        "hopper" = {
          "enable" = false;
        };
        "idaFree" = {
          "enable" = false;
        };
        "idaPro" = {
          "enable" = false;
        };
        "keystone" = {
          "enable" = false;
        };
        "lief" = {
          "enable" = false;
        };
        "patchelf" = {
          "enable" = false;
        };
        "radare2" = {
          "enable" = false;
        };
        "rizin" = {
          "enable" = false;
        };
        "unicorn" = {
          "enable" = false;
        };
      };
      "scanning" = {
        "nikto" = {
          "enable" = true;
        };
        "nuclei" = {
          "enable" = false;
        };
        "wpscan" = {
          "enable" = true;
        };
      };
      "staticAnalysis" = {
        "bandit" = {
          "enable" = false;
        };
        "checkov" = {
          "enable" = false;
        };
        "gitleaks" = {
          "enable" = false;
        };
        "semgrep" = {
          "enable" = false;
        };
        "trufflehog" = {
          "enable" = false;
        };
      };
      "web" = {
        "commix" = {
          "enable" = false;
        };
        "dalfox" = {
          "enable" = false;
        };
        "feroxbuster" = {
          "enable" = false;
        };
        "ffuf" = {
          "enable" = false;
        };
        "gau" = {
          "enable" = false;
        };
        "gobuster" = {
          "enable" = true;
        };
        "httprobe" = {
          "enable" = false;
        };
        "httpx" = {
          "enable" = false;
        };
        "katana" = {
          "enable" = false;
        };
        "sqlmap" = {
          "enable" = true;
        };
        "wfuzz" = {
          "enable" = false;
        };
      };
      "wireless" = {
        "aircrack-ng" = {
          "enable" = false;
        };
        "bully" = {
          "enable" = false;
        };
        "hcxtools" = {
          "enable" = false;
        };
        "kismet" = {
          "enable" = false;
        };
      };
      "wordlists" = {
        "fuzzdb" = {
          "enable" = false;
        };
        "payloadsAllTheThings" = {
          "enable" = false;
        };
        "rockyou" = {
          "enable" = false;
        };
        "seclists" = {
          "enable" = true;
        };
      };
    };
    "desktop" = {
      "browser" = "firefox";
      "documentViewer" = "zathura";
      "environment" = "hyprland";
      "hypridle" = {
        "enable" = true;
      };
      "hyprland" = {
        "enable" = true;
      };
      "hyprlock" = {
        "enable" = true;
      };
      "hyprsunset" = {
        "enable" = true;
      };
      "imageViewer" = "imv";
      "mediaPlayer" = "mpv";
      "musicPlayer" = "cliamp";
      "sddm" = {
        "autologin" = true;
        "enable" = true;
      };
      "uwsm" = {
        "enable" = true;
      };
      "waybar" = {
        "defaultVisible" = true;
        "enable" = true;
      };
    };
    "development" = {
      "buildTools" = {
        "autoconf" = {
          "enable" = false;
        };
        "automake" = {
          "enable" = false;
        };
        "bazel" = {
          "enable" = false;
        };
        "cmake" = {
          "enable" = true;
        };
        "libtool" = {
          "enable" = false;
        };
        "meson" = {
          "enable" = true;
        };
        "ninja" = {
          "enable" = false;
        };
        "pkg-config" = {
          "enable" = false;
        };
        "premake" = {
          "enable" = false;
        };
        "scons" = {
          "enable" = false;
        };
        "xmake" = {
          "enable" = false;
        };
      };
      "cloud" = {
        "ansible" = {
          "enable" = false;
        };
        "awscli" = {
          "enable" = false;
        };
        "azureCli" = {
          "enable" = false;
        };
        "gcloud" = {
          "enable" = false;
        };
        "helm" = {
          "enable" = false;
        };
        "k9s" = {
          "enable" = false;
        };
        "kubectl" = {
          "enable" = false;
        };
        "opentofu" = {
          "enable" = false;
        };
        "terraform" = {
          "enable" = false;
        };
      };
      "compute" = {
        "cuda" = {
          "enable" = false;
        };
        "opencl" = {
          "enable" = false;
        };
        "rocm" = {
          "enable" = false;
        };
      };
      "containers" = {
        "buildah" = {
          "enable" = false;
        };
        "docker" = {
          "enable" = false;
        };
        "k3d" = {
          "enable" = false;
        };
        "kind" = {
          "enable" = false;
        };
        "minikube" = {
          "enable" = false;
        };
        "skopeo" = {
          "enable" = false;
        };
      };
      "databases" = {
        "duckdb" = {
          "enable" = false;
        };
        "mariadb" = {
          "enable" = false;
        };
        "mongodb" = {
          "enable" = false;
        };
        "postgresql" = {
          "enable" = false;
        };
        "redis" = {
          "enable" = false;
        };
        "sqlite" = {
          "enable" = false;
        };
      };
      "debugging" = {
        "bpftrace" = {
          "enable" = false;
        };
        "gdb" = {
          "enable" = false;
        };
        "heaptrack" = {
          "enable" = false;
        };
        "hotspot" = {
          "enable" = false;
        };
        "lldb" = {
          "enable" = false;
        };
        "perf" = {
          "enable" = false;
        };
        "rr" = {
          "enable" = false;
        };
        "strace" = {
          "enable" = false;
        };
        "valgrind" = {
          "enable" = false;
        };
      };
      "documentation" = {
        "doxygen" = {
          "enable" = false;
        };
        "graphviz" = {
          "enable" = false;
        };
        "mkdocs" = {
          "enable" = false;
        };
        "pandoc" = {
          "enable" = false;
        };
        "sphinx" = {
          "enable" = false;
        };
      };
      "editors" = {
        "emacs" = {
          "enable" = false;
        };
        "geany" = {
          "enable" = false;
        };
        "gnomeBuilder" = {
          "enable" = false;
        };
        "kate" = {
          "enable" = false;
        };
        "lapce" = {
          "enable" = false;
        };
        "liteXl" = {
          "enable" = false;
        };
        "neovide" = {
          "enable" = false;
        };
        "pulsar" = {
          "enable" = false;
        };
        "sublimeText" = {
          "enable" = false;
        };
        "vscode" = {
          "enable" = true;
        };
        "vscodium" = {
          "enable" = false;
        };
        "zed" = {
          "enable" = true;
        };
      };
      "embedded" = {
        "avrdude" = {
          "enable" = false;
        };
        "dfu-util" = {
          "enable" = false;
        };
        "gccArmEmbedded" = {
          "enable" = false;
        };
        "openocd" = {
          "enable" = false;
        };
        "picocom" = {
          "enable" = false;
        };
        "platformio" = {
          "enable" = false;
        };
      };
      "fpga" = {
        "ghdl" = {
          "enable" = false;
        };
        "gtkwave" = {
          "enable" = false;
        };
        "iverilog" = {
          "enable" = false;
        };
        "nextpnr" = {
          "enable" = false;
        };
        "verilator" = {
          "enable" = false;
        };
        "yosys" = {
          "enable" = false;
        };
      };
      "graphics" = {
        "epoxy" = {
          "enable" = false;
        };
        "glfw" = {
          "enable" = false;
        };
        "glm" = {
          "enable" = false;
        };
        "glslang" = {
          "enable" = false;
        };
        "opengl" = {
          "enable" = false;
        };
        "raylib" = {
          "enable" = false;
        };
        "sdl2" = {
          "enable" = false;
        };
        "sdl3" = {
          "enable" = false;
        };
        "sfml" = {
          "enable" = false;
        };
        "shaderc" = {
          "enable" = false;
        };
        "spirv-tools" = {
          "enable" = false;
        };
        "vulkan" = {
          "enable" = false;
        };
      };
      "gui" = {
        "fltk" = {
          "enable" = false;
        };
        "gtk3" = {
          "enable" = false;
        };
        "gtk4" = {
          "enable" = false;
        };
        "libadwaita" = {
          "enable" = false;
        };
        "qt5" = {
          "enable" = false;
        };
        "qt6" = {
          "enable" = false;
        };
        "wxwidgets" = {
          "enable" = false;
        };
      };
      "ides" = {
        "arduinoIde" = {
          "enable" = false;
        };
        "clion" = {
          "enable" = false;
        };
        "codeBlocks" = {
          "enable" = false;
        };
        "datagrip" = {
          "enable" = false;
        };
        "dataspell" = {
          "enable" = false;
        };
        "dbeaver" = {
          "enable" = false;
        };
        "eclipse" = {
          "enable" = false;
        };
        "goland" = {
          "enable" = false;
        };
        "idea" = {
          "enable" = false;
        };
        "ideaCommunity" = {
          "enable" = false;
        };
        "jetbrainsToolbox" = {
          "enable" = false;
        };
        "kdevelop" = {
          "enable" = false;
        };
        "netbeans" = {
          "enable" = false;
        };
        "phpstorm" = {
          "enable" = false;
        };
        "pycharm" = {
          "enable" = false;
        };
        "pycharmCommunity" = {
          "enable" = false;
        };
        "qtCreator" = {
          "enable" = false;
        };
        "rider" = {
          "enable" = false;
        };
        "rstudio" = {
          "enable" = false;
        };
        "rubyMine" = {
          "enable" = false;
        };
        "rustRover" = {
          "enable" = false;
        };
        "spyder" = {
          "enable" = false;
        };
        "webstorm" = {
          "enable" = false;
        };
      };
      "languages" = {
        "ada" = {
          "enable" = false;
        };
        "c" = {
          "enable" = true;
        };
        "clojure" = {
          "enable" = false;
        };
        "cpp" = {
          "enable" = false;
        };
        "crystal" = {
          "enable" = false;
        };
        "csharp" = {
          "enable" = false;
        };
        "d" = {
          "enable" = false;
        };
        "dart" = {
          "enable" = false;
        };
        "elixir" = {
          "enable" = false;
        };
        "erlang" = {
          "enable" = false;
        };
        "fortran" = {
          "enable" = false;
        };
        "go" = {
          "enable" = false;
        };
        "haskell" = {
          "enable" = false;
        };
        "java" = {
          "enable" = false;
        };
        "julia" = {
          "enable" = false;
        };
        "kotlin" = {
          "enable" = false;
        };
        "lua" = {
          "enable" = true;
        };
        "nim" = {
          "enable" = false;
        };
        "node" = {
          "enable" = false;
        };
        "ocaml" = {
          "enable" = false;
        };
        "odin" = {
          "enable" = false;
        };
        "pascal" = {
          "enable" = false;
        };
        "perl" = {
          "enable" = false;
        };
        "php" = {
          "enable" = false;
        };
        "python" = {
          "enable" = true;
        };
        "r" = {
          "enable" = false;
        };
        "racket" = {
          "enable" = false;
        };
        "ruby" = {
          "enable" = false;
        };
        "rust" = {
          "enable" = true;
        };
        "scala" = {
          "enable" = false;
        };
        "scheme" = {
          "enable" = false;
        };
        "swift" = {
          "enable" = false;
        };
        "typescript" = {
          "enable" = false;
        };
        "v" = {
          "enable" = false;
        };
        "zig" = {
          "enable" = false;
        };
      };
      "libraries" = {
        "boost" = {
          "enable" = false;
        };
        "eigen" = {
          "enable" = false;
        };
        "ffmpeg" = {
          "enable" = false;
        };
        "fmt" = {
          "enable" = false;
        };
        "grpc" = {
          "enable" = false;
        };
        "icu" = {
          "enable" = false;
        };
        "libevent" = {
          "enable" = false;
        };
        "libinput" = {
          "enable" = false;
        };
        "libsodium" = {
          "enable" = false;
        };
        "libusb" = {
          "enable" = false;
        };
        "libuv" = {
          "enable" = false;
        };
        "libxml2" = {
          "enable" = false;
        };
        "nlohmann_json" = {
          "enable" = false;
        };
        "opencv" = {
          "enable" = false;
        };
        "openssl" = {
          "enable" = false;
        };
        "protobuf" = {
          "enable" = false;
        };
        "spdlog" = {
          "enable" = false;
        };
        "zeromq" = {
          "enable" = false;
        };
        "zlib" = {
          "enable" = false;
        };
        "zstd" = {
          "enable" = false;
        };
      };
      "linters" = {
        "black" = {
          "enable" = true;
        };
        "eslint" = {
          "enable" = true;
        };
        "nixfmt" = {
          "enable" = true;
        };
        "prettier" = {
          "enable" = true;
        };
        "ruff" = {
          "enable" = false;
        };
        "shellcheck" = {
          "enable" = false;
        };
        "shfmt" = {
          "enable" = false;
        };
      };
      "lsp" = {
        "gopls" = {
          "enable" = true;
        };
        "lua-language-server" = {
          "enable" = true;
        };
        "nil" = {
          "enable" = false;
        };
        "nixd" = {
          "enable" = false;
        };
        "pyright" = {
          "enable" = true;
        };
        "rust-analyzer" = {
          "enable" = true;
        };
        "typescript-language-server" = {
          "enable" = false;
        };
      };
      "mobile" = {
        "adb" = {
          "enable" = false;
        };
        "android" = {
          "enable" = false;
        };
        "flutter" = {
          "enable" = false;
        };
      };
      "packageManagers" = {
        "gradle" = {
          "enable" = false;
        };
        "maven" = {
          "enable" = false;
        };
        "opam" = {
          "enable" = false;
        };
        "pipx" = {
          "enable" = false;
        };
        "poetry" = {
          "enable" = false;
        };
        "uv" = {
          "enable" = false;
        };
      };
      "protocols" = {
        "grpcurl" = {
          "enable" = false;
        };
        "mqtt" = {
          "enable" = false;
        };
        "websocat" = {
          "enable" = false;
        };
      };
      "reverseEngineering" = {
        "binutils" = {
          "enable" = false;
        };
        "cutter" = {
          "enable" = false;
        };
        "ghidra" = {
          "enable" = false;
        };
        "pahole" = {
          "enable" = false;
        };
        "radare2" = {
          "enable" = false;
        };
      };
      "scientific" = {
        "hdf5" = {
          "enable" = false;
        };
        "lapack" = {
          "enable" = false;
        };
        "netcdf" = {
          "enable" = false;
        };
        "openblas" = {
          "enable" = false;
        };
        "openmpi" = {
          "enable" = false;
        };
      };
      "testing" = {
        "k6" = {
          "enable" = false;
        };
        "playwright" = {
          "enable" = false;
        };
      };
      "virtualization" = {
        "libvirt" = {
          "enable" = true;
        };
        "qemu" = {
          "enable" = false;
        };
        "vagrant" = {
          "enable" = false;
        };
        "virt-manager" = {
          "enable" = true;
        };
      };
      "web" = {
        "angular" = {
          "enable" = false;
        };
        "astro" = {
          "enable" = false;
        };
        "bun" = {
          "enable" = false;
        };
        "deno" = {
          "enable" = false;
        };
        "nextjs" = {
          "enable" = false;
        };
        "nuxt" = {
          "enable" = false;
        };
        "pnpm" = {
          "enable" = false;
        };
        "react" = {
          "enable" = false;
        };
        "remix" = {
          "enable" = false;
        };
        "solid" = {
          "enable" = false;
        };
        "svelte" = {
          "enable" = false;
        };
        "tailwindcss" = {
          "enable" = false;
        };
        "vite" = {
          "enable" = false;
        };
        "vue" = {
          "enable" = false;
        };
        "yarn" = {
          "enable" = false;
        };
      };
      "webAssembly" = {
        "binaryen" = {
          "enable" = false;
        };
        "emscripten" = {
          "enable" = false;
        };
        "wabt" = {
          "enable" = false;
        };
        "wasm-pack" = {
          "enable" = false;
        };
        "wasmer" = {
          "enable" = false;
        };
        "wasmtime" = {
          "enable" = false;
        };
      };
    };
    "disk" = {
      "device" = "/dev/nvme0n1";
      "layout" = "laptop-luks-btrfs";
    };
    "git" = {
      "allowedSigners" = "snape@drunkleen.com sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPDUHKfH8eRMUlbQg4CKDo2cS3zFL+M03tRrFs/5fF4LAAAABHNzaDo= snape@drunkleen.com\n";
      "branch" = "master";
      "email" = "snape@drunkleen.com";
      "name" = "DrunkLeen";
    };
    "hardware" = {
      "asus" = {
        "enable" = true;
        "model" = null;
      };
      "bluetooth" = {
        "enable" = true;
      };
      "camera" = {
        "privacy" = true;
      };
      "intel" = {
        "enable" = true;
      };
      "nvidia" = {
        "enable" = true;
      };
      "power-profiles" = {
        "enable" = true;
      };
    };
    "host" = {
      "architecture" = "x86_64-linux";
      "hostname" = "tuf-f15";
      "timezone" = "Europe/Berlin";
    };
    "instance" = {
      "configurationName" = "tuf-f15";
      "flakePath" = "/home/snape/nix-config";
      "policyPath" = "/home/snape/nix-config/instances/tuf-f15/policy.nix";
    };
    "keyboard" = {
      "layouts" = [ "us" "ir" ];
      "options" = [ "grp:alt_shift_toggle" ];
    };
    "locale" = {
      "language" = "en_US.UTF-8";
      "region" = "de_DE.UTF-8";
    };
    "memory" = {
      "hibernate" = {
        "enable" = false;
      };
      "zram" = {
        "enable" = true;
      };
    };
    "networking" = {
      "dns" = {
        "mode" = "system";
        "servers" = [  ];
      };
      "iwd" = {
        "enable" = true;
      };
      "openvpn" = {
        "enable" = false;
        "profiles" = {};
      };
      "ssh" = {
        "allowedUsers" = [ "snape" ];
        "autoStart" = false;
        "enable" = true;
        "keyboardInteractiveAuthentication" = false;
        "passwordAuthentication" = true;
        "permitRootLogin" = "no";
        "port" = 22;
        "publicKeys" = [ "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPDUHKfH8eRMUlbQg4CKDo2cS3zFL+M03tRrFs/5fF4LAAAABHNzaDo= snape@drunkleen.com" ];
      };
      "tailscale" = {
        "acceptDns" = false;
        "enable" = true;
      };
      "wireguard" = {
        "enable" = false;
        "interfaces" = {};
      };
    };
    "profiles" = {
      "ai" = {
        "enable" = true;
      };
      "applications" = {
        "enable" = true;
      };
      "base" = {
        "enable" = true;
      };
      "cybersecurity" = {
        "enable" = true;
      };
      "desktop" = {
        "enable" = true;
      };
      "development" = {
        "enable" = true;
      };
      "gaming" = {
        "enable" = true;
      };
      "hardened" = {
        "enable" = false;
      };
      "laptop" = {
        "enable" = true;
      };
      "server" = {
        "enable" = false;
      };
    };
    "security" = {
      "fido2" = {
        "enable" = false;
        "pinVerification" = true;
        "userPresence" = true;
        "userVerification" = false;
      };
      "firewall" = {
        "enable" = true;
        "rules" = [ {
          "interfaces" = [  ];
          "name" = "ssh-lan";
          "ports" = [ 22 ];
          "protocol" = "tcp";
          "sources" = [ "10.42.0.0/24" ];
        } {
          "interfaces" = [ "tailscale0" ];
          "name" = "ssh-tailscale";
          "ports" = [ 22 ];
          "protocol" = "tcp";
          "sources" = [  ];
        } ];
      };
      "pam" = {
        "enable" = true;
      };
      "passwordlessSudo" = false;
    };
    "services" = {
      "podman" = {
        "enable" = true;
      };
    };
    "storage" = {
      "mounts" = {
        "games" = {
          "automount" = true;
          "device" = "/dev/disk/by-uuid/F4AA40A7AA4067E6";
          "dirMask" = null;
          "enable" = true;
          "fileMask" = null;
          "group" = "users";
          "idleTimeoutSec" = 300;
          "options" = [  ];
          "path" = "/mnt/games";
          "readOnly" = false;
          "type" = "ntfs";
          "umask" = "002";
          "user" = "snape";
          "windowsSafe" = true;
        };
        "media" = {
          "automount" = true;
          "device" = "/dev/disk/by-uuid/40762FAF762FA49E";
          "dirMask" = null;
          "enable" = true;
          "fileMask" = null;
          "group" = "users";
          "idleTimeoutSec" = 300;
          "options" = [  ];
          "path" = "/mnt/media";
          "readOnly" = false;
          "type" = "ntfs";
          "umask" = "002";
          "user" = "snape";
          "windowsSafe" = true;
        };
      };
    };
    "theme" = {
      "mode" = "dark";
    };
    "user" = {
      "extraGroups" = [ "wheel" "video" "audio" "input" "gamemode" ];
      "homeDirectory" = "/home/snape";
      "username" = "snape";
    };
  };
}
