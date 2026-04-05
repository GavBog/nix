{ customPkgs, ... }:
{
  users.users.gavbog = {
    initialPassword = "gavbog";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  users.defaultUserShell = customPkgs.zsh;

  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  environment.shells = [ customPkgs.zsh ];
}
