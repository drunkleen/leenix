# LEENIUM canonical color palette — the single shared source of LEENIUM colors.
#
# Owned here so boot/display/login artifacts (SDDM greeter theme, Plymouth,
# Limine) and application themes (OpenCode) consume the SAME palette instead of
# hardcoding disconnected copies. `defs` maps semantic names to exact hex colors;
# consumers decide how to map them to their own schema.

{
  defs = {
    bg = "#0B1113";
    sidebar = "#0E1518";
    panel = "#11191C";
    card = "#141E21";
    popup = "#182326";
    floating = "#1D2A2D";
    hover = "#223033";
    active = "#304144";
    selection = "#365156";
    text = "#D8E3E0";
    muted = "#718688";
    accent = "#33B8A8";
    cyan = "#59D6C5";
    sea = "#4DBA7A";
    seaBright = "#67CF94";
    type = "#71E4D8";
    warn = "#D9C76B";
    warnBright = "#EFD45E";
    orange = "#F4A259";
    error = "#E16F73";
    errorSoft = "#F08787";
    blue = "#5E9BFF";
  };
}
