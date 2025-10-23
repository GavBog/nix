{ ... }:
{
  services.openssh.enable = true;
  services.cloudflare-warp.enable = true;

  time.timeZone = "America/New_York";
}
