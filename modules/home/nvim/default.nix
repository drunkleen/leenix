{ ... }:

{
  programs.neovim = {
    enable = true;
  };

  xdg.configFile."nvim" = {
    source = ../../../dotfiles/nvim;
  };
}
