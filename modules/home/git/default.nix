{ variables, ... }:

{
  home.file.".config/git/allowed_signers".text = ''
    ${variables.git.email} ${builtins.readFile ../../../keys/github.pub}
  '';

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = variables.git.name;
        email = variables.git.email;
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

      init.defaultBranch = variables.git.branch;

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
