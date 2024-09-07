# nix-vagrant

<img src="https://r7.pngegg.com/path/339/633/226/5bbbb587d6390-358f94abbaa945123d02c06a05c46ab4.png" width="200" align="right" alt="Vagrant">
<img src="https://nixos.org/logo/nixos-logo-only-hires.png" width="200" align="right" alt="NixOS">


A nix library for render and run declarative HashiCorp Vagrant config files powered by nixago and CUE Lang.
* Make Vagrantfiles from nix
* Batteries includes box runner

## Usage
### Make Vagrantfiles

```nix
vagrant.machine1 = nix-vagrant.lib.make {
  name = "machine1";
  provider = "vmware_fusion";
  box = "CumulusCommunity/cumulus-vx";
};
```

### Box runner

```nix
packages.start = nix-vagrant.lib.runner {
  machine = {
    name = "windows1";
    provider = "virtualbox";
    box = "gusztavvargadr/windows-11";
  };

  launchScript = "powershell -noprofile -noninteractive - < C:/";

  script = ''
    $PSVersionTable.BuildVersion
    cmd /k ver
  '';
};
```

