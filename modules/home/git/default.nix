{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "DrunkLeen";
        email = "snape@drunkleen.com";
      };

      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
    };
  };
}
