{ pkgs, ... }:
{
  # Bootstrap from Yubikey:
  # 1. Add the result to .sops.yaml:
  # ssh-to-age -i /etc/ssh/ssh_host_ed25519_key.pub
  # 2. Plug in yubikey then update the keys for all secrets:
  # find . -type f -name "*.sops.*" ! -name ".sops.yaml" -exec sops updatekeys -y {} \;

  # Encrypt new File:
  # sops --encrypt --in-place {file}

  # Edit file:
  # (sudo) sops {file}

  environment.sessionVariables = {
    SOPS_AGE_KEY_CMD = "${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key";
    SOPS_AGE_KEY_FILE = "/etc/sops/age/keys.txt";
  };
  environment.etc."sops/age/keys.txt".text = ''
    #       Serial: 24937974, Slot: 2
    #         Name: age identity 5c49eddf
    #      Created: Mon, 09 Feb 2026 00:10:13 +0000
    #   PIN policy: Once   (A PIN is required once per session, if set)
    # Touch policy: Always (A physical touch is required for every decryption)
    #    Recipient: age1yubikey1qgyrtg6drd9uzn7t8eqc3h08r6ck647ega4geq84escczjhuteqxv682jtn
    AGE-PLUGIN-YUBIKEY-176ZHCQVRT3Y7MHC5NX2TH
  '';

  sops.defaultSopsFile = ./secrets.sops.yaml;
  sops.defaultSopsFormat = "yaml";
}
