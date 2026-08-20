{ leenix, ... }:

let
  gitCfg = leenix.git;
  allowedSigners = leenix.git.allowedSigners;
in
{
  # Git SSH commit-signing allowed-signers record, from typed LEENIX policy
  # (typed leenix.* policy -> config.leenix -> HM specialArg `leenix`). No
  # Core-relative personal key path is read here.
  home.file.".config/git/allowed_signers".text = ''
    ${if allowedSigners != null then allowedSigners else ""}
  '';

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = gitCfg.name;
        email = gitCfg.email;
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

      init.defaultBranch = gitCfg.branch;

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
    };
  };
}
