# Host applications policy control panel - every accepted catalog leaf is
# explicitly listed, alphabetically ordered (categories and leaves), all false by default.
#
# DATA / POLICY ONLY: booleans. Package implementation and capability metadata live in
# modules/nixos/applications/catalog.nix. profiles.applications (the master gate) is
# owned by variables/profiles.nix. Only flip leaves to true after enabling profiles.applications.
#
# Behavior-preserving migration from modules/home/apps (previously installed on tuf-f15):
#   communication.discord, communication.signalDesktop, communication.telegramDesktop,
#   email.thunderbird, password.bitwarden, streaming.spotify
{
  applications = {
    communication = {
      discord = true;
      elementDesktop = false;
      ferdium = false;
      mumble = false;
      nheko = false;
      pidgin = false;
      revoltDesktop = false;
      sessionDesktop = false;
      signalDesktop = true;
      slack = false;
      teams = false;
      telegramDesktop = true;
      tokodon = false;
      zoom = false;
    };
    containers = {
      boxbuddy = false;
    };
    creative = {
      audacity = false;
      darktable = false;
      gimp = true;
      handbrake = false;
      inkscape = false;
      kdenlive = false;
      krita = false;
      obsStudio = true;
      openshot = false;
      penpotDesktop = false;
      rawtherapee = false;
      shotcut = false;
    };
    documents = {
      calibre = false;
      evince = false;
      foliate = false;
      okular = false;
      papers = false;
      pdfArranger = false;
    };
    email = {
      evolution = false;
      geary = false;
      protonmailBridge = false;
      protonmailDesktop = false;
      thunderbird = true;
    };
    finance = {
      gnucash = false;
      kmymoney = false;
    };
    notes = {
      affine = false;
      anytype = false;
      appflowy = false;
      jabref = false;
      joplinDesktop = false;
      logseq = false;
      notesnook = false;
      obsidian = false;
      zotero = false;
    };
    office = {
      freeoffice = false;
      libreoffice = true;
      onlyoffice = false;
    };
    password = {
      bitwarden = true;
      keepassxc = false;
      onePassword = false;
    };
    reading = {
      koodoReader = false;
      liferea = false;
      newsboat = false;
      newsflash = false;
      rssguard = false;
    };
    remoteAccess = {
      anydesk = false;
      lookingGlass = false;
      moonlight = false;
      parsec = false;
      realVncViewer = false;
      remmina = false;
      rustdesk = true;
      sunshine = false;
      teamviewer = false;
      tigervnc = false;
    };
    streaming = {
      feishin = false;
      freetube = false;
      spotify = true;
      tidalHifi = false;
    };
    sync = {
      dropbox = false;
      megasync = false;
      syncthing = false;
      syncthingTray = false;
    };
    system = {
      gearlever = false;
      gnomeSoftware = false;
      missionCenter = false;
      rpiImager = false;
      warehouse = false;
    };
    tasks = {
      endeavour = false;
      planner = false;
      todoist = false;
    };
    torrenting = {
      deluge = false;
      qbittorrent = false;
      transmission = false;
    };
  };
}
