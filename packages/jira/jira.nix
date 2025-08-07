{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    jira-cli-go # Jira CLI tool for work
  ];

  # Jira CLI configuration - using existing config file
  # API token is loaded from environment variable JIRA_API_TOKEN
}