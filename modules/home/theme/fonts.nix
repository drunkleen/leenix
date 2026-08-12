{ pkgs, ... }:

{
  # Vazirmatn is the authoritative Persian/Arabic text font. The rule matches
  # any family request that carries a Persian (fa) or Arabic (ar) language tag
  # and prepends Vazirmatn with a strong binding, so explicit families such as
  # JetBrainsMono Nerd Font, DejaVu Sans, serif or monospace also resolve to
  # Vazirmatn for Persian/Arabic text. Requests without a fa/ar language tag
  # (Latin/English, Nerd Font symbols) are untouched.
  fonts.fontconfig.configFile."persian-arabic-vazirmatn" = {
    enable = true;
    priority = 60;
    text = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
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
