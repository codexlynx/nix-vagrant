{
  pkgs,
  make,
}:
# TODO: Validate and documentate config
{
  package ? pkgs.vagrant,
  config,
  init ? { },
}:
let
  inherit (pkgs) lib writeTextFile writeShellScriptBin;

  vagrantfile = "./.vagrant/${config.name}";

  provisionScript = writeTextFile {
    name = "script";
    text = init.script;
    executable = false;
  };

  ssh-config = writeShellScriptBin "ssh-config" ''
    export VAGRANT_VAGRANTFILE=${vagrantfile}
    ${lib.getExe package} ssh-config
  '';

  ssh = writeShellScriptBin "ssh" ''
    export TMPFILE=$(mktemp)
    ${pkgs.lib.getExe ssh-config} > $TMPFILE
    ssh -F $TMPFILE ${config.name} $@
  '';

  provision = writeShellScriptBin "provision" ''
    ${lib.getExe ssh} "${init.launchScript}${provisionScript}"
  '';
in
{
  inherit ssh-config ssh provision;

  up = writeShellScriptBin "up" ''
    export VAGRANT_VAGRANTFILE=${vagrantfile}
    ${(make vagrantfile config).shellHook}
    ${lib.getExe package} up --provider=${config.provider}
    ${lib.getExe provision}
  '';

  destroy = writeShellScriptBin "destroy" ''
    export VAGRANT_VAGRANTFILE=${vagrantfile}
    ${(make vagrantfile config).shellHook}
    ${lib.getExe package} destroy -f
  '';
}
