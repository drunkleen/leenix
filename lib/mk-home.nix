{ inputs, self }:
{ vars }:

{
  useGlobalPkgs = true;
  useUserPackages = true;

  extraSpecialArgs = {
    inherit vars inputs self;
  };

  users.${vars.username} = import ../home/${vars.username};
}
