{ pkgs, ... }:

{
  # Vazirmatn is the preferred Persian/Arabic text font. Latin, UI, and
  # monospace fonts (e.g. JetBrainsMono Nerd Font) are intentionally left
  # untouched: Vazirmatn is only preferred for sans-serif requests that carry
  # a Persian (fa) or Arabic (ar) language tag, so it acts as a fallback for
  # Persian/Arabic glyph coverage without affecting Latin appearance.
  fonts.fontconfig.configFile."persian-arabic-vazirmatn" = {
    enable = true;
    priority = 60;
    text = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
        <description>Prefer Vazirmatn for Persian (fa) sans-serif text</description>
        <match target="pattern">
          <test name="family" compare="eq" qual="any">
            <string>sans-serif</string>
          </test>
          <test name="lang" compare="contains">
            <string>fa</string>
          </test>
          <edit name="family" mode="prepend" binding="strong">
            <string>Vazirmatn</string>
          </edit>
        </match>
        <description>Prefer Vazirmatn for Arabic (ar) sans-serif text</description>
        <match target="pattern">
          <test name="family" compare="eq" qual="any">
            <string>sans-serif</string>
          </test>
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
