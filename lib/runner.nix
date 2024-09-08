{ pkgs, machine }:
{
  package ? pkgs.vagrant,
  config,
  script,
  launchScript ? "sh",
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
  ${lib.getExe vagrant.up}
  ${lib.getExe vagrant.ssh} "${launchScript}${scriptFile}"
  ${lib.getExe vagrant.destroy}
''
