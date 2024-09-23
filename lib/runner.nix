{ pkgs }:
vagrant:
let
  inherit (pkgs) lib writeShellScriptBin;
in
writeShellScriptBin "runner" ''
  ${lib.getExe (vagrant).up}
  ${lib.getExe (vagrant).destroy}
''
