{
  stdenvNoCC,
}:

# LEENIUM SDDM greeter theme.
#
# Original LEENIX theme: colors come from the canonical palette in
# lib/leenium.nix (single shared source — same palette as the LEENIUM Plymouth
# theme and the OpenCode theme). Assets are simple, palette-driven SVG
# recreations owned by LEENIX (no third-party assets copied). Installed into
# share/sddm/themes/leenium and resolved by SDDM via the system profile's
# ThemeDir. No mutable /usr/share edits, no ~/.config dependency.

let
  palette = import ../../../../lib/leenium.nix;
  defs = palette.defs;
in

stdenvNoCC.mkDerivation {
  pname = "leenium-sddm-theme";
  version = "1.0.0";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    theme="$out/share/sddm/themes/leenium"
    mkdir -p "$theme/assets"

    cat > "$theme/metadata.desktop" <<'LEENIUM_EOF'
    [Desktop Entry]
    Type=X-SDDM-Theme
    Name=LEENIUM
    Comment=LEENIUM SDDM greeter theme
    X-KDE-PluginInfo-Name=leenium
    LEENIUM_EOF

    cat > "$theme/theme.conf" <<'LEENIUM_EOF'
    [General]
    Background=${defs.bg}
    TextColor=${defs.text}
    MutedColor=${defs.muted}
    AccentColor=${defs.accent}
    LEENIUM_EOF

    cat > "$theme/assets/lock.svg" <<'LEENIUM_EOF'
    <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 64 64">
      <rect x="16" y="30" width="32" height="24" rx="5" fill="${defs.accent}"/>
      <path d="M22 30 v-8 a10 10 0 0 1 20 0 v8" fill="none" stroke="${defs.accent}" stroke-width="5"/>
      <circle cx="32" cy="42" r="4" fill="${defs.bg}"/>
    </svg>
    LEENIUM_EOF

    cat > "$theme/assets/logo.svg" <<'LEENIUM_EOF'
    <svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 128 128">
      <rect x="8" y="8" width="112" height="112" rx="20" fill="none" stroke="${defs.accent}" stroke-width="8"/>
      <path d="M34 88 V40 l30 34 V40" fill="none" stroke="${defs.cyan}" stroke-width="10" stroke-linecap="round" stroke-linejoin="round"/>
    </svg>
    LEENIUM_EOF

    cat > "$theme/Main.qml" <<'LEENIUM_EOF'
    import QtQuick 2.15
    import QtQuick.Layouts 1.15
    import SddmComponents 2.0

    Rectangle {
        id: root
        width: 640
        height: 480
        color: "${defs.bg}"

        TextConstants { id: textConstants }

        Column {
            anchors.centerIn: parent
            spacing: 20

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: "assets/logo.svg"
                width: 96
                height: 96
                sourceSize: Qt.size(96, 96)
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "LEENIUM"
                color: "${defs.accent}"
                font.pixelSize: 34
                font.bold: true
            }

            TextBox {
                id: name
                anchors.horizontalCenter: parent.horizontalCenter
                width: 240
                height: 40
                color: "${defs.text}"
                focusColor: "${defs.accent}"
                borderColor: "${defs.hover}"
                text: userModel.lastUser
            }

            PasswordBox {
                id: password
                anchors.horizontalCenter: parent.horizontalCenter
                width: 240
                height: 40
                color: "${defs.text}"
                focusColor: "${defs.accent}"
                borderColor: "${defs.hover}"
                focus: true
                KeyNavigation.backtab: loginButton
                KeyNavigation.tab: session
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 12

                Text {
                    text: textConstants.session
                    color: "${defs.muted}"
                    anchors.verticalCenter: parent.verticalCenter
                }

                ComboBox {
                    id: session
                    width: 200
                    height: 40
                    model: sessionModel
                    color: "${defs.text}"
                    focusColor: "${defs.accent}"
                    borderColor: "${defs.hover}"
                    KeyNavigation.backtab: password
                    KeyNavigation.tab: layout
                }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 12

                Text {
                    text: textConstants.layout
                    color: "${defs.muted}"
                    anchors.verticalCenter: parent.verticalCenter
                }

                ComboBox {
                    id: layout
                    width: 200
                    height: 40
                    model: layoutModel
                    color: "${defs.text}"
                    focusColor: "${defs.accent}"
                    borderColor: "${defs.hover}"
                    KeyNavigation.backtab: session
                    KeyNavigation.tab: loginButton
                }
            }

            Button {
                id: loginButton
                anchors.horizontalCenter: parent.horizontalCenter
                text: textConstants.login
                color: "${defs.accent}"
                textColor: "${defs.bg}"
                onClicked: sddm.login(name.text, password.text, session.index)
            }
        }

        Component.onCompleted: {
            name.forceActiveFocus()
            session.currentIndex = sessionModel.lastIndex(sessionModel.lastUser)
        }
    }
    LEENIUM_EOF

    runHook postInstall
  '';
}
