# Extensions are obtained thanks to the guide here: https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265.
# Check `about:support` for extension/add-on ID strings. Then find the
# installation url by donwloading the extension file (instead of installing it
# directly). Always install the latest version of the extensions by using the
# "latest" tag in the download url.
# See also:
# - https://github.com/mozilla/policy-templates/blob/master/linux/policies.json#L120
# - https://mozilla.github.io/policy-templates/#extensionsettings
{
  "uBlock0@raymondhill.net" = {
    install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
    installation_mode = "force_installed";
    default_area = "navbar";
  };
  "tridactyl.vim.betas@cmcaine.co.uk" = {
    install_url = "https://tridactyl.cmcaine.co.uk/betas/tridactyl-latest.xpi";
    installation_mode = "force_installed";
    default_area = "menupanel";
  };
}
