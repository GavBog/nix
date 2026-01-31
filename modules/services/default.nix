{ ... }:
{
  services.openssh.enable = true;
  services.cloudflare-warp.enable = true;
  services.usbmuxd.enable = true;

  time.timeZone = "America/New_York";
}
