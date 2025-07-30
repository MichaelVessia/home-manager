{ lib, config, pkgs, ... }:

{
  home.packages = with pkgs; [
    aws-sso-cli
    awscli2
  ];
}