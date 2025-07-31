{ lib, config, pkgs, ... }:

{
  home.packages = with pkgs; [
    aws-sso-cli
    awscli2
  ];

  # NOTE: For GUI applications (like OpenLens) to find AWS CLI, create a system-wide symlink:
  # sudo ln -sf /Users/michael.vessia/.nix-profile/bin/aws /usr/local/bin/aws
}