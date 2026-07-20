{ ... }:
{
  services.kanata = {
    enable = true;
    keyboards = {
      default = {
        extraDefCfg = "
          process-unmapped-keys yes
          concurrent-tap-hold   yes
          chords-v2-min-idle    25
        ";
        config = builtins.readFile ./handsdown-neu.kbd;
      };
    };
  };
}
