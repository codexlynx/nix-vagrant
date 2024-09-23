{
  pkgs,
  ssh-to-ansible,
  machine,
}:
{
  package ? pkgs.vagrant,
  config,
  init ? {
    launchScript = "powershell -noninteractive -executionpolicy unrestricted - < C:/";
    script = "";
  },
  scriptPreStart ? "",
  scriptPostStart ? "",
  chocolatelyPackages ? [ ],
  boxstartedPackages ? [ ],
}:
let
  inherit (pkgs) lib writeShellScriptBin writeTextFile;

  playbook = writeTextFile {
    name = "playbook.yml";
    executable = false;
    text = lib.generators.toYAML { } [
      {
        name = "Imperative pkgs installing";
        hosts = "all";
        gather_facts = "no";
        tasks = [
          {
            name = "Install chocolately pkgs";
            win_chocolatey = {
              name = [ "boxstarter" ] ++ chocolatelyPackages;
              state = "latest";
              choco_args = [
                "--force"
                "-params"
                "ALLUSERS=1"
              ];
            };
          }
          {
            name = "Install boxstarter pkgs";
            "ansible.windows.win_powershell" = {
              script = ''
                Install-BoxstarterPackage -PackageName "${lib.concatStringsSep "," boxstartedPackages}" -DisableReboots
              '';
            };
          }
        ];
      }
    ];
  };

  imperativePkgs = writeShellScriptBin "imperative-pkgs" ''
    export TMPFILE=$(mktemp /tmp/XXXXXX.yaml)

    export LANGUAGE="C.UTF-8"
    export LANG="C.UTF-8"
    export LC_COLLATE="C.UTF-8"
    export LC_CTYPE="C.UTF-8"
    export LC_MONETARY="C.UTF-8"
    export LC_NUMERIC="C.UTF-8"
    export LC_TIME="C.UTF-8"
    export LC_MESSAGES="C.UTF-8"
    export LC_ALL="C.UTF-8"

    ${lib.getExe (vagrant.ssh-config)} | ${lib.getExe ssh-to-ansible} --quiet -e all -o $TMPFILE \
      --var ansible_shell_type:cmd \
      --var shell_type:cmd \
      --var ansible_become_method:runas \
      --var become_method:runas

    # TODO: Fix this imperative operations
    ${pkgs.ansible}/bin/ansible-galaxy collection install ansible.windows
    ${pkgs.ansible}/bin/ansible-galaxy collection install chocolatey.chocolatey

    ${pkgs.ansible}/bin/ansible-playbook -i $TMPFILE ${playbook}
  '';

  vagrant = machine {
    inherit
      package
      config
      init
      scriptPreStart
      ;
    scriptPostStart = ''
      ${lib.getExe imperativePkgs}
      ${scriptPostStart}
    '';
  };

in
vagrant
// {
  inherit imperativePkgs;
}
