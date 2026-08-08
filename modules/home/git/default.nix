{ ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "DrunkLeen";
        email = "snape@drunkleen.com";
      };

      init.defaultBranch = "master";

      pull.rebase = true;
      push.autoSetupRemote = true;

      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
      };

      commit.verbose = true;
      column.ui = "auto";

      branch.sort = "-committerdate";
      tag.sort = "-version:refname";

      rerere = {
        enabled = true;
        autoUpdate = true;
      };

      alias = {
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
      };
    };
  };
}
