{
  pkgs,
  ssh-to-ansible,
  machine,
}:
let
  withPackages = import ./withPackages.nix { inherit pkgs ssh-to-ansible machine; };
in
{
  inherit withPackages;
}
