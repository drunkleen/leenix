{ ... }:

{
  programs.zsh.shellAliases = {
    d = "docker";
    dc = "docker compose";

    dps = "docker ps";
    dpsa = "docker ps -a";
    di = "docker images";

    dex = "docker exec -it";
    dlog = "docker logs -f";

    dcu = "docker compose up -d";
    dcd = "docker compose down";
    dcl = "docker compose logs -f";
    dcb = "docker compose build";
  };
}
