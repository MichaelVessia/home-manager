{ config, pkgs, lib, ... }:

let
  # Define which packages need AppArmor profiles
  # Format: app-name = "package-name" (usually the same)
  appArmorApps = {
    signal-desktop = "signal-desktop";
    brave = "brave";
    #discord = "discord";
    #slack = "slack";
    #zoom = "zoom";
    #teams = "teams";
    #chromium = "chromium";
    #google-chrome = "google-chrome";
  };
in
{
  # Export the apps list as JSON for the script to read
  home.file.".config/home-manager/apparmor-apps.json".text = builtins.toJSON {
    apps = appArmorApps;
  };
}
