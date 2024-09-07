{
  system,
  pkgs,
  nixago,
}:
let
  make = import ./make.nix { inherit system pkgs nixago; };
in
{
  inherit make;

  runner = import ./runner.nix { inherit pkgs make; };
}
