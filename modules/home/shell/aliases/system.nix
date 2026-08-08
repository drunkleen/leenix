{ ... }:

{
  programs.zsh.shellAliases = {
    cls = "clear";
    ports = "ss -tulpn";
    psg = "ps aux | grep -i";
    dfh = "df -h";
    duh = "du -sh";

    mkdir = "mkdir -p";
    cp = "cp -iv";
    mv = "mv -iv";
    rm = "rm -i";
  };
}
