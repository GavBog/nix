# Extensions are obtained thanks to the guide here: https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265.
# Check `about:support` for extension/add-on ID strings. Then find the
# installation url by donwloading the extension file (instead of installing it
# directly). Always install the latest version of the extensions by using the
# "latest" tag in the download url.
# See also:
# - https://github.com/mozilla/policy-templates/blob/master/linux/policies.json#L120
# - https://mozilla.github.io/policy-templates/#extensionsettings
{ pkgs }:
let
  ublockOrigin = pkgs.fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/4675310/ublock_origin-1.69.0.xpi";
    hash = "sha256-eFvN5ool+qiglJlk7F/+m9y4XT8K4hwj9gfGyPkUcs8=";
  };
  tridactyl = pkgs.fetchurl {
    url = "https://tridactyl.cmcaine.co.uk/betas/tridactyl2-1.24.5pre7318.xpi";
    hash = "sha256-v7syCyICdqAOgVw4aMKC560B3qDONkQuMtfHOGlRdtI=";
  };
  darkReader = pkgs.fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/4710145/darkreader-4.9.123.xpi";
    hash = "sha256-mj5s2sU/ICV72BJkUywWr+2tAOsmI73tie0rMLHkAkM=";
  };
in
{
  "uBlock0@raymondhill.net" = {
    install_url = "file://${ublockOrigin}";
    installation_mode = "force_installed";
    default_area = "navbar";
  };
  "tridactyl.vim.betas@cmcaine.co.uk" = {
    install_url = "file://${tridactyl}";
    installation_mode = "force_installed";
    default_area = "menupanel";
  };
  "addon@darkreader.org" = {
    install_url = "file://${darkReader}";
    installation_mode = "force_installed";
    default_area = "menupanel";
  };
}
