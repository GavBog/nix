{
  lib,
  pkgs,
  ...
}: let
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

    # Set destinations for dotfiles
    dest1="${home}/.config/cosmic"
    # dest2 = "${home}/..."

    # copy nix store dotfiles to their destinations
    mkdir -p "$(dirname "$dest1")" # "$(dirname "$dest2")"
    ${pkgs.rsync}/bin/rsync -r --checksum --no-perms --no-owner --no-group \
      "${dotfilesPath}/cosmic/" "$dest1/"
    # ${pkgs.rsync}/bin/rsync -r --checksum --no-perms --no-owner --no-group \
    #   "${dotfilesPath}/.../" "$dest2/"

    # change ownership and perms
    set -- "$dest1" # "$dest2"
    chown -R "$user_uid:$user_gid" "$@"
    chmod -R u+rwX "$@"

    # dont forget about the parent directories!
    set -- "$(dirname "$dest1")" # "$(dirname "$dest2")"
    chown "$user_uid:$user_gid" "$@"
    chmod u+rwX "$@"
  '';
}
