{
  system,
  pkgs,
  nixago,
}:
{
  package ? pkgs.vagrant,
  name,
  provider,
  box,
  gui ? false,
}:
let
  inherit (pkgs) lib writeShellScriptBin;

  template = import ./../vagrantfile { inherit system nixago; };
  cfg = template { inherit name provider box gui; };
in
{
  up = writeShellScriptBin "up" ''
    export VAGRANT_VAGRANTFILE=./.vagrant/${name}
    ${(nixago.lib."${system}".make cfg).shellHook}
    ${lib.getExe package} box update
    ${lib.getExe package} up
  '';

  destroy = writeShellScriptBin "destroy" ''
    export VAGRANT_VAGRANTFILE=./.vagrant/${name}
    ${(nixago.lib."${system}".make cfg).shellHook}
    ${lib.getExe package} destroy -f
  '';

  ssh = writeShellScriptBin "ssh" ''
    export VAGRANT_VAGRANTFILE=./.vagrant/${name}
    export TMPFILE=$(mktemp)
    ${lib.getExe package} ssh-config > $TMPFILE
    ssh -F $TMPFILE ${name} $@
  '';
}
