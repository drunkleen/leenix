{
  lib,
  pkgs,
  config,
  browser,
  mediaPlayer,
  imageViewer,
  documentViewer,
  musicPlayer,
  ...
}:

# Central declarative XDG MIME / default-application policy. Owns ALL MIME
# associations so app modules only install packages/launchers. Driven by the
# LEENIX desktop role variables (host.nix -> extraSpecialArgs), so changing a
# host variable automatically updates the associations.
let
  # Dolphin is the fixed LEENIX file manager (not host-selectable).
  fmId = "org.kde.dolphin.desktop";

  desktopId = {
    browser = {
      firefox = "firefox.desktop";
      chromium = "chromium.desktop";
      google-chrome = "google-chrome-stable.desktop";
      brave = "brave-browser.desktop";
      vivaldi = "vivaldi-stable.desktop";
      librewolf = "librewolf.desktop";
    };
    mediaPlayer = {
      mpv = "mpv.desktop";
    };
    imageViewer = {
      imv = "imv.desktop";
    };
    documentViewer = {
      zathura = "org.pwmt.zathura-pdf-mupdf.desktop";
    };
    musicPlayer = {
      cliamp = "leenix-cliamp.desktop";
    };
  };

  browserId = desktopId.browser.${browser};
  mediaId = desktopId.mediaPlayer.${mediaPlayer};
  imageId = desktopId.imageViewer.${imageViewer};
  docId = desktopId.documentViewer.${documentViewer};
  musicId = desktopId.musicPlayer.${musicPlayer};

  # Application MIME support lists (mirror the pinned packages' desktop MimeType).
  imageMimes = [
    "image/x-farbfeld"
    "image/tiff"
    "image/tiff-fx"
    "image/png"
    "image/x-png"
    "image/jpeg"
    "image/jpg"
    "image/pjpeg"
    "image/svg+xml"
    "image/gif"
    "image/bmp"
    "image/x-bmp"
    "image/heif"
    "image/avif"
    "image/jxl"
    "image/webp"
    "image/qoi"
  ];
  videoMimes = [
    "video/mp4"
    "video/x-matroska"
    "video/webm"
    "video/quicktime"
    "video/x-msvideo"
    "video/mpeg"
    "video/ogg"
    "video/x-flv"
    "video/x-ms-wmv"
    "video/x-m4v"
    "video/mp2t"
    "video/3gpp"
  ];
  audioMimes = [
    "audio/mpeg"
    "audio/flac"
    "audio/ogg"
    "audio/opus"
    "audio/x-wav"
    "audio/wav"
    "audio/mp4"
    "audio/aac"
    "audio/webm"
    "audio/x-m4a"
    "audio/x-aiff"
    "audio/x-flac"
    "audio/midi"
  ];
in
{
  # KService/kbuildsycoca6: KDE apps (Dolphin) resolve applications through the
  # ksycoca service database. Keep the tool in the profile and rebuild the
  # cache after activation so the profile-installed desktop files are indexed.
  # The profile bin dir is put on PATH so TryExec= fields (e.g. mpv, imv, kitty)
  # resolve and their services are not discarded.
  home.packages = [
    pkgs.kdePackages.kservice
  ];

  home.activation.runKbuildsycoca = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # Home Manager's `run` helper safely handles DRY_RUN (no unbound variable
    # under `set -u`). The profile bin dir is on PATH so TryExec= fields
    # (e.g. mpv, imv, kitty) resolve and their services are not discarded.
    export PATH="${config.home.profileDirectory}/bin:$PATH"
    run --silence ${pkgs.kdePackages.kservice}/bin/kbuildsycoca6
  '';

  # The freedesktop menu-spec file is REQUIRED for KDE's KService/ksycoca to
  # discover applications: VFolderMenu reads <prefix>applications.menu and only
  # then scans the XDG applications directories. Without it Dolphin's Open With
  # and default-app resolution see zero services. Provide it under both the
  # prefixed name (XDG_MENU_PREFIX, e.g. hyprland-) and the plain name.
  xdg.configFile."menus/applications.menu".text = ''
    <!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
      "http://www.freedesktop.org/standards/menu-spec/menu-1.0.dtd">
    <Menu>
      <Name>Applications</Name>
      <DefaultAppDirs/>
      <DefaultDirectoryDirs/>
      <DefaultMergeDirs/>
    </Menu>
  '';
  xdg.configFile."menus/hyprland-applications.menu".text = ''
    <!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
      "http://www.freedesktop.org/standards/menu-spec/menu-1.0.dtd">
    <Menu>
      <Name>Applications</Name>
      <DefaultAppDirs/>
      <DefaultDirectoryDirs/>
      <DefaultMergeDirs/>
    </Menu>
  '';

  xdg.mimeApps.enable = true;

  xdg.mimeApps.defaultApplications = {
    # Directories / browser
    "inode/directory" = fmId;
    "x-scheme-handler/http" = browserId;
    "x-scheme-handler/https" = browserId;
    "text/html" = browserId;
    "application/xhtml+xml" = browserId;

    # Images -> imageViewer
    "image/png" = imageId;
    "image/x-png" = imageId;
    "image/jpeg" = imageId;
    "image/jpg" = imageId;
    "image/pjpeg" = imageId;
    "image/gif" = imageId;
    "image/webp" = imageId;
    "image/bmp" = imageId;
    "image/x-bmp" = imageId;
    "image/tiff" = imageId;
    "image/tiff-fx" = imageId;
    "image/svg+xml" = imageId;
    "image/avif" = imageId;
    "image/heif" = imageId;
    "image/jxl" = imageId;
    "image/qoi" = imageId;
    "image/x-farbfeld" = imageId;

    # Audio -> musicPlayer (CLIAMP)
    "audio/mpeg" = musicId;
    "audio/flac" = musicId;
    "audio/ogg" = musicId;
    "audio/opus" = musicId;
    "audio/x-wav" = musicId;
    "audio/wav" = musicId;
    "audio/mp4" = musicId;
    "audio/aac" = musicId;
    "audio/webm" = musicId;
    "audio/x-m4a" = musicId;
    "audio/x-aiff" = musicId;
    "audio/x-flac" = musicId;
    "audio/midi" = musicId;

    # Video -> mediaPlayer (MPV)
    "video/mp4" = mediaId;
    "video/x-matroska" = mediaId;
    "video/webm" = mediaId;
    "video/quicktime" = mediaId;
    "video/x-msvideo" = mediaId;
    "video/mpeg" = mediaId;
    "video/ogg" = mediaId;
    "video/x-flv" = mediaId;
    "video/x-ms-wmv" = mediaId;
    "video/x-m4v" = mediaId;
    "video/mp2t" = mediaId;
    "video/3gpp" = mediaId;
    "application/ogg" = mediaId;

    # Documents -> documentViewer (Zathura)
    "application/pdf" = docId;

    # Plain text -> graphical editor (Mousepad)
    "text/plain" = "org.xfce.mousepad.desktop";
    "text/markdown" = "org.xfce.mousepad.desktop";
  };

  # Make the selected applications available in freedesktop "Open With" lists.
  xdg.mimeApps.associations.added = {
    "inode/directory" = [ fmId ];
    "x-scheme-handler/http" = [ browserId ];
    "x-scheme-handler/https" = [ browserId ];
  } // lib.genAttrs imageMimes (_: [ imageId ])
    // lib.genAttrs audioMimes (_: [ musicId ])
    // lib.genAttrs videoMimes (_: [ mediaId ])
    // {
      "application/pdf" = [ docId ];
      "text/plain" = [ "org.xfce.mousepad.desktop" ];
    };

  # CLIAMP is a terminal app; give it a real XDG application identity so
  # Dolphin/file managers can open audio files through the canonical launcher.
  xdg.desktopEntries."leenix-cliamp" = {
    name = "CLIAMP";
    comment = "Retro terminal music player";
    exec = "leenix-launch-music --auto-play %F";
    icon = "multimedia-player";
    type = "Application";
    terminal = false;
    mimeType = audioMimes;
  };
}
