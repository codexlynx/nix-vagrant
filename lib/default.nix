{
  system,
  pkgs,
  nixago,
}:
let
  make = import ./make.nix { inherit system nixago; };
  machine = import ./machine.nix { inherit pkgs make; };
  runner = import ./runner.nix { inherit pkgs machine; };
in
{
  inherit make machine runner;
}
