{ config, pkgs, lib, ... }:

{
  imports = [
    ../../packages/apparmor/apparmor-profiles.nix
  ];
}