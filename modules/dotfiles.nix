{lib, ...}: let
  user = "gavbog";
  home = "/home/${user}";
  dotfilesPath = builtins.path {
    name = "dotfiles";
    path = ./dotfiles;
  };
in {
  system.activationScripts.dotfiles = lib.stringAfter ["users"] ''
    user_uid=$(id -u ${user})
    user_gid=$(id -g ${user})

    # Replace Cosmic Configuration
    cp -rT "${dotfilesPath}/cosmic" "${home}/.config/cosmic"

    chown -R "$user_uid:$user_gid" "${home}/.config/cosmic"
    chmod -R u+rwX "${home}/.config/cosmic"
  '';
}
