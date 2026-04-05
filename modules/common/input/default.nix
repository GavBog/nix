{ ... }:
{
  boot.kernelModules = [ "uinput" ];

  hardware.uinput.enable = true;
  users.groups.uinput = { };

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  systemd.services.kanata-default.serviceConfig = {
    SupplementaryGroups = [
      "input"
      "uinput"
    ];
  };
}
