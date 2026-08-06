{ inputs }:
{ vars }:

{
  useGlobalPkgs = true;
  useUserPackages = true;

  extraSpecialArgs = {
    inherit vars inputs;
  };

  users.${vars.username} = import ../home/${vars.username};
}
