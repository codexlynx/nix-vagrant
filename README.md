# nix-vagrant
> [!WARNING]  
> This library is in an early, experimental stage and may lack complete functionality. It is intended for testing and feedback purposes only. Use at your own risk as stability is not guaranteed.

<img src="https://r7.pngegg.com/path/339/633/226/5bbbb587d6390-358f94abbaa945123d02c06a05c46ab4.png" width="200" align="right" alt="Vagrant">
<img src="https://nixos.org/logo/nixos-logo-only-hires.png" width="200" align="right" alt="NixOS">


A [nix](https://zero-to-nix.com/concepts/nix-language) library for render, run and manage declarative HashiCorp [Vagrant](https://www.vagrantup.com/) config files powered by nixago and [CUE Lang](https://cuelang.org/).
* Make Vagrantfiles from nix
* Manage vagrant machine lifecycle
* Batteries includes box runner

## Usage
### Make Vagrantfiles
```nix
vagrant.file.cumulus = 
  pkgs.writeShellScriptBin "result"
    (nix-vagrant.lib."${system}".make "Vagrantfile" {
      name = "machine1";
      provider = "vmware_fusion";
      box = "CumulusCommunity/cumulus-vx";
      gui = false;
    }).shellHook;
```

#### Commands
```commandline
$ nix run .#vagrant.x86_64-linux.file.cumulus
```

### Manual machine lifecycle control
```nix
vagrant.machine.windows = nix-vagrant.lib."${system}".machine {
  package = pkgs.vagrant;

  config = {
    name = "windows1";
    provider = "virtualbox";
    box = "gusztavvargadr/windows-11";
    gui = true;
  };

  init = {
    launchScript = "powershell -noninteractive -executionpolicy unrestricted - < C:/";

    script = ''
      echo Hello from Windows!
    '';
  };
};
```
#### Commands
```commandline
$ nix run .#vagrant.x86_64-linux.machine.windows.up
$ nix run .#vagrant.x86_64-linux.machine.windows.ssh
$ nix run .#vagrant.x86_64-linux.machine.windows.destroy
$ nix run .#vagrant.x86_64-linux.machine.windows.ssh-config
$ nix run .#vagrant.x86_64-linux.machine.windows.provision
```

### Box runner
```nix
packages.start = nix-vagrant.lib."${system}".runner {
  config = {
    name = "windows1";
    provider = "virtualbox";
    box = "gusztavvargadr/windows-11";
    gui = false;
  };
};
```

#### Commands
```commandline
$ nix run .#start
```


