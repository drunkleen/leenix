{ ... }:

{
  services.hyprsunset = {
    enable = true;

    settings = {
      profile = [
        {
          time = "07:00";
          identity = true;
        }
      ];
    };
  };
}
