{ ... }:
{
  boot.kernelModules = [ "uinput" ];

  hardware.uinput.enable = true;
  users.groups.uinput = { };

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  systemd.services.kanata-internalKeyboard.serviceConfig = {
    SupplementaryGroups = [
      "input"
      "uinput"
    ];
  };

  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        devices = [
          # Replace the paths below with the appropriate device paths for your setup.
          # Use `ls /dev/input/by-path/` to find your keyboard devices.
          "/dev/input/by-path/platform-23510c000.spi-cs-0-event-kbd"
        ];
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
            caps
          )

          (defalias
            escctrl (tap-hold 200 200 esc lctrl)
          )

          (deflayer base
            @escctrl
          )
        '';
      };
    };
  };
}
