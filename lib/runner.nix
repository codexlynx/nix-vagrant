{ pkgs, make }:
{
  machine,
  script,
  launchScript ? "sh",
}:
let
  inherit (pkgs) lib writeShellScriptBin;

  vagrant = make machine;
  scriptFile = writeShellScriptBin "script" script;
in
writeShellScriptBin "runner" ''
    ${lib.getExe vagrant.up}
    ${lib.getExe vagrant.ssh} "${launchScript}${lib.getExe scriptFile}"
    ${lib.getExe vagrant.destroy}
''
