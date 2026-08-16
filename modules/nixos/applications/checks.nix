{ lib, ... }:

# Derived consistency checks for the applications catalog. All counts and sets
# are DERIVED from catalog.nix and compared against frozen constants so drift
# fails evaluation. Versions are intentionally NOT frozen: they derive from the
# locked flake nixpkgs input at evaluation time.
let
  catalog = import ./catalog.nix;
  appLib = import ./lib.nix { inherit catalog; };

  aLeaves = builtins.filter (x: x.meta.classification == "A") appLib.all;
  unfreeLeaves = builtins.filter (x: x.meta.unfree) appLib.all;
  heavyLeaves = builtins.filter (x: x.meta.heavy) appLib.all;
  guardedLeaves = builtins.filter (x: x.meta.guarded) appLib.all;
  packageOnlyLeaves = builtins.filter (x: x.meta.packageOnly) appLib.all;

  sortedOk = xs: xs == builtins.sort builtins.lessThan xs;
  catOrderOk = sortedOk appLib.cats;
  leafOrderOk = builtins.all (cat: sortedOk (appLib.leavesOf cat)) appLib.cats;

  # Every A leaf has a package function and complete metadata.
  aPackagesOk = builtins.all (x: builtins.isFunction x.meta.packages) aLeaves;
  metaOk = builtins.all (x: (x.meta.description or "") != ""
    && (x.meta.kind or "") != ""
    && builtins.isList (x.meta.platforms or null)) appLib.all;

  # Static declaration of every referenced canonical package attr per leaf
  # (1:1 with catalog.nix `packages = pkgs: [ pkgs.<attr> ]`). Used to assert
  # global package-mapping uniqueness and ownership non-overlap.
  referenced = [
    "discord" "element-desktop" "ferdium" "mumble" "nheko" "pidgin" "revolt-desktop"
    "session-desktop" "signal-desktop" "slack" "teams" "telegram-desktop"
    "kdePackages.tokodon" "zoom-us"
    "boxbuddy"
    "audacity" "darktable" "gimp" "handbrake" "inkscape" "kdePackages.kdenlive"
    "krita" "obs-studio" "openshot-qt" "penpot-desktop" "rawtherapee" "shotcut"
    "calibre" "evince" "foliate" "kdePackages.okular" "papers" "pdfarranger"
    "evolution" "geary" "protonmail-bridge" "protonmail-desktop" "thunderbird"
    "gnucash" "kmymoney"
    "affine" "anytype" "appflowy" "jabref" "joplin-desktop" "logseq" "notesnook"
    "obsidian" "zotero"
    "freeoffice" "libreoffice" "onlyoffice-desktopeditors"
    "bitwarden-desktop" "keepassxc" "_1password-gui"
    "koodo-reader" "liferea" "newsboat" "newsflash" "rssguard"
    "anydesk" "looking-glass-client" "moonlight-qt" "parsec-bin" "realvnc-vnc-viewer"
    "remmina" "rustdesk" "sunshine" "teamviewer" "tigervnc"
    "feishin" "freetube" "spotify" "tidal-hifi"
    "dropbox" "megasync" "syncthing" "syncthingtray"
    "gearlever" "gnome-software" "mission-center" "rpi-imager" "warehouse"
    "endeavour" "planner" "todoist-electron"
    "deluge" "qbittorrent" "transmission_4-gtk"
  ];

  # 89 leaves each reference exactly one distinct attr; duplicates fail.
  # (uniqueness asserted inline in the checks list below)

  # Frozen sets.
  frozenUnfree = [
    "applications.communication.discord"
    "applications.communication.slack"
    "applications.communication.teams"
    "applications.communication.zoom"
    "applications.notes.anytype"
    "applications.notes.obsidian"
    "applications.office.freeoffice"
    "applications.password.onePassword"
    "applications.remoteAccess.anydesk"
    "applications.remoteAccess.parsec"
    "applications.remoteAccess.realVncViewer"
    "applications.remoteAccess.teamviewer"
    "applications.streaming.spotify"
    "applications.sync.dropbox"
    "applications.sync.megasync"
    "applications.tasks.todoist"
  ];

  frozenGuarded = [
    "applications.office.freeoffice"
    "applications.office.onlyoffice"
    "applications.remoteAccess.lookingGlass"
    "applications.streaming.tidalHifi"
  ];

  frozenPackageOnly = [
    "applications.remoteAccess.sunshine"
    "applications.sync.syncthing"
  ];

  frozenMigration = [
    "applications.communication.discord"
    "applications.communication.signalDesktop"
    "applications.communication.telegramDesktop"
    "applications.email.thunderbird"
    "applications.password.bitwarden"
    "applications.streaming.spotify"
  ];

  # Packages owned by other LEENIX owners (desktop/base/browser/gaming plus the
  # development/cybersecurity/ai catalogs). Derived from those catalogs' own
  # source + desktop/base/gaming module ownership; frozen here.
  ownedElsewhere = [
    "R" "SDL2" "X" "aflplusplus" "aider-chat" "aircrack-ng" "amass" "android-studio"
    "android-tools" "ansible" "apktool" "arp-scan" "autoconf" "automake" "autopsy"
    "avrdude" "awscli" "azure-cli" "bandit" "bat" "bazel" "beamPackages" "bettercap"
    "binaryen" "binutils" "binwalk" "black" "bloodhound" "bloodhound-py" "boost"
    "bpftrace" "brave" "btop" "buildah" "bulk_extractor" "bully" "bun" "bundler"
    "burpsuite" "cabal-install" "capstone" "cargo" "cewl" "checkov" "chez" "chromium"
    "clang" "clang-tools" "claude-code" "cliamp" "clinfo" "clojure" "cmake" "codex"
    "commix" "config" "crunch" "crystal" "cudaPackages" "curl" "cutter" "dalfox"
    "dart" "deno" "dfu-util" "dnsenum" "dnsrecon" "dnsx" "docker" "dolphin"
    "dotnet-sdk" "doxygen" "duckdb" "dune" "eigen" "emscripten" "enum4linux-ng"
    "eslint" "exiftool" "exploitdb" "eza" "fabric-ai" "fd" "feroxbuster" "ffmpeg"
    "ffuf" "fierce" "file" "firefox" "fltk" "flutter" "fmt" "foremost" "fpc"
    "frida-tools" "fuzzdb" "fzf" "gamemode" "gamescope" "gau" "gcc-arm-embedded"
    "gdb" "gdb-dashboard" "gef" "gemini-cli" "gfortran" "ghc" "ghdl" "ghidra" "git"
    "gitleaks" "glfw" "glm" "glslang" "gnat" "go" "gobuster" "google-chrome"
    "google-cloud-sdk" "goose" "gopls" "gpt4all" "gradle" "graphviz" "grpc" "grpcurl"
    "grype" "gtk3" "gtk4" "gtkwave" "hashcat" "hcxtools" "hdf5" "heaptrack" "holehe"
    "honggfuzz" "hotspot" "htop" "httprobe" "httpx" "icu" "imv" "iverilog" "jadx"
    "jan" "jdk" "john" "jq" "julia" "k3d" "k6" "k9s" "katana" "kerbrute" "keystone"
    "kind" "kismet" "koboldcpp" "kotlin" "kube-bench" "kube-hunter" "kubeaudit"
    "kubectl" "kubernetes-helm" "lapack" "lazydocker" "lazygit" "ldapdomaindump"
    "ldc" "leenfetch" "libGL" "libadwaita" "libepoxy" "libevent" "libinput"
    "librewolf" "libsodium" "libtool" "libusb1" "libuv" "libvirt" "libxml2" "lief"
    "llama-cpp" "lld" "lldb" "lmstudio" "localsend" "lua-language-server" "lua5_4"
    "maigret" "mako" "mangohud" "mariadb" "masscan" "maven" "mcp-proxy" "mesa-demos"
    "meson" "metasploit" "minikube" "mitmproxy" "mkdocs" "mongodb" "mosquitto" "mpv"
    "naabu" "nano" "neovim" "netcdf" "netexec" "nextpnr" "nikto" "nil" "nim" "ninja"
    "nixd" "nixfmt" "nlohmann_json" "nmap" "nodejs" "nuclei" "objection" "ocaml"
    "ocl-icd" "odin" "ollama" "opam" "openblas" "opencl-headers" "openclaw" "opencode"
    "opencv" "openmpi" "openocd" "openssh" "openssl" "opentofu" "ophcrack" "p7zip"
    "pahole" "pandoc" "patchelf" "payloadsallthethings" "perf" "perl" "php"
    "phpPackages" "picocom" "pipx" "pkg-config" "platformio" "playwright" "pnpm"
    "poetry" "postgresql" "premake" "prettier" "protobuf" "protontricks" "protonup-qt"
    "proxychains" "pyright" "python3" "python3Packages" "qemu" "qt5" "qt6" "qwen-code"
    "racket" "radamsa" "radare2" "raylib" "recon-ng" "redis" "responder" "ripgrep"
    "rizin" "rockyou" "rocmPackages" "rr" "rsync" "ruby" "ruff" "rust-analyzer"
    "rustc" "rustscan" "scala" "scalpel" "scons" "sdl3" "seclists" "semgrep" "sfml"
    "shaderc" "shellcheck" "sherlock" "shfmt" "skopeo" "sleuthkit" "smbmap" "spdlog"
    "sphinx" "spirv-tools" "sqlite" "sqlmap" "steam" "strace" "subfinder" "swayosd"
    "swift" "syft" "tailwindcss" "tcpdump" "terraform" "thc-hydra" "theharvester"
    "tmux" "tree" "trivy" "trufflehog" "tshark" "typescript"
    "typescript-language-server" "unicorn" "unzip" "uv" "v4l-utils" "vagrant"
    "valgrind" "verilator" "vim" "virt-manager" "vivaldi" "vlang" "volatility3"
    "vulkan-headers" "vulkan-loader" "vulkan-tools" "vulkan-validation-layers"
    "wabt" "walker" "wasm-pack" "wasmer" "wasmtime" "waybar" "websocat" "wfuzz"
    "wget" "which" "wireshark" "wpscan" "wxwidgets_3_2" "xmake" "yara" "yarn"
    "yazi" "yosys" "zap" "zathura" "zeromq" "zig" "zip" "zlib" "zoxide" "zsh" "zstd"
  ];

  overlap = builtins.filter (r: builtins.elem r ownedElsewhere) referenced;
  # "kdePackages.<x>" and "_1password-gui" etc. are namespaced/unique; assert the
  # flat intersection is empty.
  overlapOk = overlap == [ ];

  checks = [    { name = "category count == 16"; ok = builtins.length appLib.cats == 16; }
    { name = "leaf count == 89"; ok = builtins.length appLib.all == 89; }
    { name = "A classification count == 89"; ok = builtins.length aLeaves == 89; }
    { name = "categories alphabetically ordered"; ok = catOrderOk; }
    { name = "leaves alphabetically ordered per category"; ok = leafOrderOk; }
    { name = "classification is only A"; ok = builtins.all (x: x.meta.classification == "A") appLib.all; }
    { name = "every A leaf has a package implementation"; ok = aPackagesOk; }
    { name = "every leaf has complete metadata"; ok = metaOk; }
    { name = "unfree count == 16"; ok = builtins.length unfreeLeaves == 16; }
    { name = "unfree set matches audited result"; ok = builtins.sort builtins.lessThan (map appLib.path unfreeLeaves) == builtins.sort builtins.lessThan frozenUnfree; }
    { name = "heavy count == 35"; ok = builtins.length heavyLeaves == 35; }
    { name = "guarded count == 4"; ok = builtins.length guardedLeaves == 4; }
    { name = "guarded set matches audited result"; ok = builtins.sort builtins.lessThan (map appLib.path guardedLeaves) == builtins.sort builtins.lessThan frozenGuarded; }
    { name = "packageOnly count == 2"; ok = builtins.length packageOnlyLeaves == 2; }
    { name = "packageOnly set matches audited result"; ok = builtins.sort builtins.lessThan (map appLib.path packageOnlyLeaves) == builtins.sort builtins.lessThan frozenPackageOnly; }
    { name = "packageOnly leaves are exactly sunshine + syncthing"; ok = builtins.all (x: x.cat == "remoteAccess" && x.leaf == "sunshine" || x.cat == "sync" && x.leaf == "syncthing") packageOnlyLeaves; }
    { name = "package mappings globally unique (89 distinct)"; ok = builtins.length referenced == 89 && builtins.length referenced == builtins.length (lib.unique referenced); }
    { name = "no package referenced by another LEENIX owner"; ok = overlapOk; }
  ];
in
{
  assertions = map (c: {
    assertion = c.ok;
    message = "LEENIX applications catalog check failed: ${c.name} (derived from catalog.nix).";
  }) (builtins.filter (c: !c.ok) checks);
}
