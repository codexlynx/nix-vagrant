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
  inherit (pkgs) lib formats writeShellScriptBin;
  fmtYaml = formats.yaml { };

  # TODO: Improve playbook definition, check params.
  playbook = fmtYaml.generate "playbook.yaml" [
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
              Import-Module "''${Env:ProgramData}\boxstarter\boxstarter.chocolatey\boxstarter.chocolatey.psd1" -Force
              Install-BoxstarterPackage -PackageName "${lib.concatStringsSep "\",\"" boxstartedPackages}" -DisableReboots
            '';
          };
        }
      ];
    }
  ];

  imperativePkgs = writeShellScriptBin "imperative-pkgs" ''
    export TMPFILE=$(mktemp /tmp/XXXXXX.yaml)
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
