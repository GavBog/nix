# nixos-anywhere --flake .#server --generate-hardware-config nixos-generate-config ./systems/server/hardware-configuration.nix <hostname>
# nixos-rebuild switch --flake .#server --target-host <hostname>
{
  modulesPath,
  pkgs,
  customPkgs,
  ...
}@args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./hardware-configuration.nix
  ];
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;

  programs.mosh.enable = true;
  environment.systemPackages = with pkgs // customPkgs; [
    btop
    curl
    fastfetch
    fzf
    gitMinimal
    nvim
    zoxide
  ];

  users.defaultUserShell = customPkgs.zsh;
  environment.shells = [ customPkgs.zsh ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZZa4cTpu3dSZdMCu0ODzTT/eZOaYpSUJNVrqinHY8x gavbog@local"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILNB+1en0ybBSYVyo10btD3yp32qNT/dVQqxr1UXhE1q root@localhost"
  ]
  ++ (args.extraPublicKeys or [ ]);

  system.stateVersion = "25.11";
}
