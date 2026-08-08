{ ... }:

{
  home.file.".config/git/allowed_signers".text = ''
    snape@drunkleen.com ${builtins.readFile ../../../keys/github.pub}
  '';

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "DrunkLeen";
        email = "snape@drunkleen.com";
        signingKey = "~/.ssh/github.pub";
      };

      gpg = {
        format = "ssh";

        ssh.allowedSignersFile = "~/.config/git/allowed_signers";
      };

      commit = {
        verbose = true;
        gpgSign = true;
      };

      tag.gpgSign = true;

      init.defaultBranch = "master";

      pull.rebase = true;
      push.autoSetupRemote = true;

      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
      };

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
