{
  pkgs,
  make,
}:
let
  inherit (pkgs) lib writeShellScriptBin;
in
# TODO: Validate and documentate config
package: config:
let
  vagrantfile = "./.vagrant/${config.name}";
in
{
  up = writeShellScriptBin "up" ''
    export VAGRANT_VAGRANTFILE=${vagrantfile}
    ${(make vagrantfile config).shellHook}
    ${lib.getExe package} box update
    ${lib.getExe package} up --provider=${config.provider}
  '';

  destroy = writeShellScriptBin "destroy" ''
    export VAGRANT_VAGRANTFILE=${vagrantfile}
    ${(make vagrantfile config).shellHook}
    ${lib.getExe package} destroy -f
  '';

  ssh = writeShellScriptBin "ssh" ''
    export VAGRANT_VAGRANTFILE=${vagrantfile}
    export TMPFILE=$(mktemp)
    ${lib.getExe package} ssh-config > $TMPFILE
    ssh -F $TMPFILE ${config.name} $@
  '';
}
