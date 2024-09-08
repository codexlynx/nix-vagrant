{
  system,
  pkgs,
  nixago,
  make,
}:
let
  inherit (pkgs) lib writeShellScriptBin;

in
# TODO: Validate and documentate config
config:
let
  vagrantfile = "./.vagrant/${config.name}";
in
{
  up = writeShellScriptBin "up" ''
    export VAGRANT_VAGRANTFILE=${vagrantfile}
    ${(make vagrantfile config).shellHook}
    ${lib.getExe config.package} box update
    ${lib.getExe config.package} up
  '';

  destroy = writeShellScriptBin "destroy" ''
    export VAGRANT_VAGRANTFILE=${vagrantfile}
    ${(make vagrantfile config).shellHook}
    ${lib.getExe config.package} destroy -f
  '';

  ssh = writeShellScriptBin "ssh" ''
    export VAGRANT_VAGRANTFILE=${vagrantfile}
    export TMPFILE=$(mktemp)
    ${lib.getExe config.package} ssh-config > $TMPFILE
    ssh -F $TMPFILE ${config.name} $@
  '';
}
