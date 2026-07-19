{
  pkgs,
  keymapConfig ? ./keymap.toml,
}:

let
  sshfsPlugin = pkgs.fetchFromGitHub {
    owner = "uhs-robert";
    repo = "sshfs.yazi";
    rev = "a8b8903c0da5a4febe91713108a9b0c8a2749475";
    hash = "sha256-RYZ0wFkYfR/TfYntRipNPvpSl4gvtmNukLBQONRk1jU=";
  };

  relativeMotionsPlugin = pkgs.fetchFromGitHub {
    # https://github.com/dedukun/relative-motions.yazi/pull/32
    owner = "Jormala";
    repo = "relative-motions.yazi";
    rev = "d4f2003b90a6129847e17107df76ba43091c7755";
    hash = "sha256-lyzwbs1u4qXuIamE31QAD6e22RPJxROs7Q/tuTkz12Q=";
  };

  yaziConfig = pkgs.runCommand "yazi-config" { } ''
    mkdir -p $out/plugins

    ln -s ${sshfsPlugin} $out/plugins/sshfs.yazi
    ln -s ${relativeMotionsPlugin} $out/plugins/relative-motions.yazi

    cp ${keymapConfig} $out/keymap.toml
  '';

in
pkgs.symlinkJoin {
  name = "yazi-custom";
  paths = [ pkgs.yazi ];
  nativeBuildInputs = [ pkgs.makeWrapper ];

  postBuild = ''
    wrapProgram "$out/bin/yazi" \
      --set YAZI_CONFIG_HOME "${yaziConfig}"
  '';
}
