{
  pkg-config,
  fetchCrate,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "ssh-to-ansible";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Vd+s9aA/Q+rdMtSHwaqleAJTVVcn0+pGo89AHHajd5Q=";
  };

  cargoHash = "sha256-vIm+JX6zNLmWbAEbQRaS/HBIynSQN+OrXw0LLuFwdmQ=";

  nativeBuildInputs = [ pkg-config ];

  meta = {
    mainProgram = "s2a";
    description = " A tool to convert a SSH configuration to an Ansible YAML inventory.";
  };
}
