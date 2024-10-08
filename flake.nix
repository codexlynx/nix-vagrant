{
  description = "nix-vagrant render, run and manage declarative HashiCorp Vagrant config files";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    nixago = {
      url = "github:jmgilman/nixago";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      nixago,
    }:
    (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          config.allowUnfree = true;
          inherit system;
        };

        ssh-to-ansible = pkgs.callPackage ./pkgs/ssh-to-ansible { };
      in
      {
        lib = import ./lib {
          inherit
            system
            pkgs
            nixago
            ssh-to-ansible
            ;
        };

        formatter = pkgs.nixfmt-rfc-style;
      }
    ));
}
