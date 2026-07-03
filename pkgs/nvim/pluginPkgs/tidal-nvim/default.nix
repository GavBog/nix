{ pkgs, lib }:
pkgs.vimUtils.buildVimPlugin {
  pname = "tidal.nvim";
  version = "0.1.0";
  src = pkgs.fetchgit {
    url = "https://codeberg.org/MrReason/tidal.nvim";
    rev = "8752e4ff26bde30aaf92ff7c68a3fe7a9b846071";
    hash = "sha256-F6eVwpmIgErqQdZndxxhUXj8KHKvWpye8LCzfHSpXm4=";
  };
  meta.homepage = "https://codeberg.org/MrReason/tidal.nvim";
  meta.license = lib.licenses.mit;

  nvimSkipModule = [
    "losc.benchmarks.init"
    "losc.examples.client"
    "losc.examples.server"
    "losc.src.losc.plugins.udp-socket"
  ];
}
