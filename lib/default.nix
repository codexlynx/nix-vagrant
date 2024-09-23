{
  system,
  pkgs,
  nixago,
  ssh-to-ansible,
}:
let
  make = import ./make.nix { inherit system nixago; };

  machine = import ./machine.nix { inherit pkgs make; };
  windows = import ./windows { inherit pkgs ssh-to-ansible machine; };

  runner = import ./runner.nix { inherit pkgs; };
in
{
  inherit
    make
    machine
    runner
    windows
    ;
}
