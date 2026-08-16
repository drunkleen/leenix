# LEENIX canonical optional-applications capability registry.
#
# Single source of truth for the declarative applications catalog. Everything
# else in modules/nixos/applications/ is DERIVED from this file:
#   - options.nix     generates leenix.applications.<category>.<leaf>.enable
#   - assertions.nix  profile-gate / unfree / platform assertions
#   - checks.nix      frozen-count + consistency + ownership checks
#   - default.nix     package composition (imported by profiles/applications.nix)
#
# Leaf metadata:
#   description    human-readable capability description
#   kind           gui / cli / daemon / library
#   classification "A" = Nix-owned package reference(s)
#   packages       pkgs: -> [ pkg ... ]  (canonical current attrs ONLY)
#   platforms      [ "x86_64-linux" "aarch64-linux" ]
#   guarded        package selection uses pkgs.X or null + availableOn
#   unfree         requires nixpkgs.config.allowUnfree (never silently enabled)
#   heavy          large / slow / memory-heavy app (informational)
#   packageOnly    install the package ONLY; never enable/start/configure its
#                  service, open firewall ports, add users/groups, or touch
#                  networking/virtualisation/secrets (metadata caveat: the
#                  applications module only ever contributes systemPackages)
#
# VERSION POLICY: no versions, no fetchurl/fetchFromGitHub/overrideAttrs, no
# pinned rev/src. Effective versions derive from the locked flake nixpkgs input
# at evaluation time (flake.lock is the reproducibility boundary).
{
  communication = {
    discord = { description = "Discord (proprietary chat client)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.discord ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = true; heavy = true; packageOnly = false; };
    elementDesktop = { description = "Element (Matrix client)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.element-desktop ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    ferdium = { description = "Ferdium (messaging aggregator)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.ferdium ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    mumble = { description = "Mumble (voice chat)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.mumble ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    nheko = { description = "nheko (Matrix client)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.nheko ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    pidgin = { description = "Pidgin (multi-protocol IM)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.pidgin ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    revoltDesktop = { description = "Revolt desktop (Guilded/Revolt chat)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.revolt-desktop ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    sessionDesktop = { description = "Session (encrypted messenger)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.session-desktop ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    signalDesktop = { description = "Signal Desktop (encrypted messenger)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.signal-desktop ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    slack = { description = "Slack (proprietary team chat)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.slack ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = true; heavy = true; packageOnly = false; };
    teams = { description = "Microsoft Teams (proprietary)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.teams ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = true; heavy = true; packageOnly = false; };
    telegramDesktop = { description = "Telegram Desktop"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.telegram-desktop ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    tokodon = { description = "Tokodon (Mastodon client)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.kdePackages.tokodon ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    zoom = { description = "Zoom (proprietary video meetings)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.zoom-us ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = true; heavy = true; packageOnly = false; };
  };
  containers = {
    boxbuddy = { description = "BoxBuddy (distrobox GUI)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.boxbuddy ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
  };
  creative = {
    audacity = { description = "Audacity (audio editor)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.audacity ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    darktable = { description = "Darktable (RAW photo editor)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.darktable ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    gimp = { description = "GIMP (raster graphics editor)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.gimp ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    handbrake = { description = "HandBrake (video transcoder)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.handbrake ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    inkscape = { description = "Inkscape (vector graphics editor)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.inkscape ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    kdenlive = { description = "Kdenlive (non-linear video editor)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.kdePackages.kdenlive ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    krita = { description = "Krita (digital painting)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.krita ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    obsStudio = { description = "OBS Studio (streaming/recording)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.obs-studio ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    openshot = { description = "OpenShot (video editor)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.openshot-qt ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    penpotDesktop = { description = "Penpot Desktop (design tool)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.penpot-desktop ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    rawtherapee = { description = "RawTherapee (RAW photo editor)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.rawtherapee ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    shotcut = { description = "Shotcut (video editor)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.shotcut ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
  };
  documents = {
    calibre = { description = "Calibre (ebook manager)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.calibre ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    evince = { description = "Evince (document viewer)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.evince ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    foliate = { description = "Foliate (ebook reader)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.foliate ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    okular = { description = "Okular (document viewer)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.kdePackages.okular ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    papers = { description = "Papers (GNOME document viewer)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.papers ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    pdfArranger = { description = "PDF Arranger (PDF merge/split)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.pdfarranger ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
  };
  email = {
    evolution = { description = "Evolution (mail/calendar)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.evolution ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    geary = { description = "Geary (GTK mail client)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.geary ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    protonmailBridge = { description = "Proton Mail Bridge (IMAP/SMTP bridge daemon)"; kind = "daemon"; classification = "A"; packages = pkgs: [ pkgs.protonmail-bridge ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    protonmailDesktop = { description = "Proton Mail Desktop"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.protonmail-desktop ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    thunderbird = { description = "Thunderbird (mail/news)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.thunderbird ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
  };
  finance = {
    gnucash = { description = "GnuCash (personal finance)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.gnucash ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    kmymoney = { description = "KMyMoney (personal finance)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.kmymoney ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
  };
  notes = {
    affine = { description = "AFFiNE (knowledge workspace)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.affine ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    anytype = { description = "Anytype (local-first notes)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.anytype ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = true; heavy = true; packageOnly = false; };
    appflowy = { description = "AppFlowy (local-first workspace)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.appflowy ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    jabref = { description = "JabRef (bibliography manager)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.jabref ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    joplinDesktop = { description = "Joplin (note-taking)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.joplin-desktop ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    logseq = { description = "Logseq (outliner notes)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.logseq ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    notesnook = { description = "Notesnook (encrypted notes)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.notesnook ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    obsidian = { description = "Obsidian (markdown knowledge base)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.obsidian ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = true; heavy = true; packageOnly = false; };
    zotero = { description = "Zotero (reference manager)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.zotero ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
  };
  office = {
    freeoffice = { description = "FreeOffice (proprietary office suite; x86_64-only)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.freeoffice ]; platforms = [ "x86_64-linux" ]; guarded = true; unfree = true; heavy = true; packageOnly = false; };
    libreoffice = { description = "LibreOffice (office suite)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.libreoffice ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    onlyoffice = { description = "OnlyOffice (office suite; x86_64-only)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.onlyoffice-desktopeditors ]; platforms = [ "x86_64-linux" ]; guarded = true; unfree = false; heavy = true; packageOnly = false; };
  };
  password = {
    bitwarden = { description = "Bitwarden Desktop (password manager)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.bitwarden-desktop ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    keepassxc = { description = "KeePassXC (password manager)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.keepassxc ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    onePassword = { description = "1Password (proprietary password manager)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs._1password-gui ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = true; heavy = false; packageOnly = false; };
  };
  reading = {
    koodoReader = { description = "Koodo Reader (ebook reader)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.koodo-reader ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    liferea = { description = "Liferea (RSS reader)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.liferea ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    newsboat = { description = "Newsboat (terminal RSS reader)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.newsboat ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    newsflash = { description = "NewsFlash (RSS reader)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.newsflash ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    rssguard = { description = "RSS Guard (RSS reader)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.rssguard ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
  };
  remoteAccess = {
    anydesk = { description = "AnyDesk (proprietary remote desktop)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.anydesk ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = true; heavy = false; packageOnly = false; };
    lookingGlass = { description = "Looking Glass (shared-memory KVM display; x86_64-only)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.looking-glass-client ]; platforms = [ "x86_64-linux" ]; guarded = true; unfree = false; heavy = false; packageOnly = false; };
    moonlight = { description = "Moonlight (game streaming client)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.moonlight-qt ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    parsec = { description = "Parsec (proprietary remote/game streaming)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.parsec-bin ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = true; heavy = false; packageOnly = false; };
    realVncViewer = { description = "RealVNC Viewer (proprietary VNC client)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.realvnc-vnc-viewer ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = true; heavy = false; packageOnly = false; };
    remmina = { description = "Remmina (RDP/VNC client)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.remmina ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    rustdesk = { description = "RustDesk (remote desktop)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.rustdesk ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    sunshine = { description = "Sunshine (game streaming host; PACKAGE ONLY - no service, no ports)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.sunshine ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = true; };
    teamviewer = { description = "TeamViewer (proprietary remote desktop)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.teamviewer ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = true; heavy = false; packageOnly = false; };
    tigervnc = { description = "TigerVNC (VNC viewer)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.tigervnc ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
  };
  streaming = {
    feishin = { description = "Feishin (Jellyfin music client)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.feishin ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    freetube = { description = "FreeTube (YouTube client)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.freetube ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; packageOnly = false; };
    spotify = { description = "Spotify (proprietary music streaming)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.spotify ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = true; heavy = true; packageOnly = false; };
    tidalHifi = { description = "Tidal Hi-Fi (proprietary music streaming; x86_64-only)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.tidal-hifi ]; platforms = [ "x86_64-linux" ]; guarded = true; unfree = false; heavy = true; packageOnly = false; };
  };
  sync = {
    dropbox = { description = "Dropbox (proprietary file sync)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.dropbox ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = true; heavy = false; packageOnly = false; };
    megasync = { description = "MEGA (proprietary file sync)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.megasync ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = true; heavy = false; packageOnly = false; };
    syncthing = { description = "Syncthing (P2P file sync; PACKAGE ONLY - no service, no ports)"; kind = "daemon"; classification = "A"; packages = pkgs: [ pkgs.syncthing ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = true; };
    syncthingTray = { description = "SyncthingTray (syncthing tray GUI)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.syncthingtray ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
  };
  system = {
    gearlever = { description = "Gear Lever (GTK4 theme manager)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.gearlever ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    gnomeSoftware = { description = "GNOME Software (app center)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.gnome-software ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    missionCenter = { description = "Mission Center (system monitor GUI)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.mission-center ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    rpiImager = { description = "Raspberry Pi Imager (SD-card imaging)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.rpi-imager ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    warehouse = { description = "Warehouse (Flatpak manager)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.warehouse ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
  };
  tasks = {
    endeavour = { description = "Endeavour (GNOME To Do fork)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.endeavour ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    planner = { description = "Planner (GNOME To Do)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.planner ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    todoist = { description = "Todoist (proprietary task manager)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.todoist-electron ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = true; heavy = true; packageOnly = false; };
  };
  torrenting = {
    deluge = { description = "Deluge (BitTorrent client)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.deluge ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    qbittorrent = { description = "qBittorrent (BitTorrent client)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.qbittorrent ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
    transmission = { description = "Transmission GTK (BitTorrent client)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.transmission_4-gtk ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; packageOnly = false; };
  };
}
