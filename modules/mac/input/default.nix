{ ... }:
{
  services.kanata = {
    enable = true;
    keyboards = {
      default = {
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
