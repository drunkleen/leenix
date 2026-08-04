{ vars, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user = {
        name = vars.git.name;
        email = vars.git.email;
      };

      init.defaultBranch = vars.git.defaultBranch;

      pull.rebase = false;
      push.autoSetupRemote = true;

      core.editor = "nvim";
      color.ui = true;
    };
  };
}
