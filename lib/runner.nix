{ pkgs, machine }:
{
  package ? pkgs.vagrant,
  config,
  script,
  launchScript ? "sh",
  preStart ? "",
  postStart ? "",
}:
let
  inherit (pkgs) lib writeShellScriptBin writeTextFile;

  vagrant = machine package config;
  scriptFile = writeTextFile {
    name = "script";
    text = script;
    executable = false;
  };
in
writeShellScriptBin "runner" ''
  ${preStart}
  ${lib.getExe vagrant.up}
  ${lib.getExe vagrant.ssh} "${launchScript}${scriptFile}"
  ${lib.getExe vagrant.destroy}
  ${postStart}
''
