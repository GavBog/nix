{ customPkgs, ... }:
{
  users.users.gavbog = {
    initialPassword = "gavbog";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  users.defaultUserShell = customPkgs.zsh;
  environment.shells = [ customPkgs.zsh ];
}
