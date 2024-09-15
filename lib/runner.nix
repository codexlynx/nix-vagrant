{ pkgs, machine }:
{
  package ? pkgs.vagrant,
  config,
  provision ? { },
  preStart ? "",
  postStart ? "",
}:
let
  inherit (pkgs) lib writeShellScriptBin;

  vagrant = machine {
    inherit package config provision;
  };
in
writeShellScriptBin "runner" ''
  ${preStart}
  ${lib.getExe vagrant.up}
  ${lib.getExe vagrant.provision}
  ${lib.getExe vagrant.destroy}
  ${postStart}
''
