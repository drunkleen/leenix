{ pkgs, ... }:

{
  # Vazirmatn is the authoritative Persian/Arabic text font.
  #
  # 1. Unconditional (weak) family prepend: adds Vazirmatn as a fallback
  #    candidate to every font request. Because the binding is weak, the
  #    requested family still wins whenever it covers the requested glyphs
  #    (Latin, monospace, Nerd Font symbols, emoji all stay untouched). But
  #    when the requested family cannot satisfy the text's charset (e.g.
  #    Persian in JetBrainsMono Nerd Font or another font without Arabic
  #    glyphs), fontconfig falls back to Vazirmatn. Real applications
  #    (GTK/Pango, Qt, Firefox, kitty) request coverage via the charset
  #    property, not always via lang, so the previous lang-only rule missed
  #    them.
  #
  # 2. Language-gated (strong) prepends: force Vazirmatn when the request
  #    carries an explicit Persian (fa) or Arabic (ar) language tag, even for
  #    generic families such as sans-serif, serif and monospace.
  fonts.fontconfig.configFile."persian-arabic-vazirmatn" = {
    enable = true;
    priority = 60;
    text = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
        <description>Fall back to Vazirmatn when the requested family lacks the needed glyphs</description>
        <match target="pattern">
          <edit name="family" mode="prepend">
            <string>Vazirmatn</string>
          </edit>
        </match>
        <description>Prefer Vazirmatn for Persian (fa) text</description>
        <match target="pattern">
          <test name="lang" compare="contains">
            <string>fa</string>
          </test>
          <edit name="family" mode="prepend" binding="strong">
            <string>Vazirmatn</string>
          </edit>
        </match>
        <description>Prefer Vazirmatn for Arabic (ar) text</description>
        <match target="pattern">
          <test name="lang" compare="contains">
            <string>ar</string>
          </test>
          <edit name="family" mode="prepend" binding="strong">
            <string>Vazirmatn</string>
          </edit>
        </match>
      </fontconfig>
    '';
  };

  home.packages = [
    pkgs.vazirmatn
  ];
}
