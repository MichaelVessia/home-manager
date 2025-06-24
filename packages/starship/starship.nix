{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    
    settings = {
      # General prompt format
      format = ''
        [╭─](bold blue)$username$hostname$directory$git_branch$git_status$cmd_duration
        [╰─](bold blue)$character
      '';

      # Prompt character
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      # Username
      username = {
        show_always = false;
        format = "[$user]($style) in ";
        style_user = "bold cyan";
      };

      # Hostname
      hostname = {
        ssh_only = true;
        format = "on [$hostname]($style) ";
        style = "bold yellow";
      };

      # Directory
      directory = {
        format = "[$path]($style)[$read_only]($read_only_style) ";
        style = "bold blue";
        truncation_length = 3;
        truncate_to_repo = false;
        read_only = " 🔒";
      };

      # Git branch
      git_branch = {
        format = "on [$symbol$branch]($style) ";
        symbol = " ";
        style = "bold purple";
      };

      # Git status
      git_status = {
        format = "[$all_status$ahead_behind]($style) ";
        style = "bold red";
        conflicted = "🏳";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "?";
        stashed = "$";
        modified = "!";
        staged = "+";
        renamed = "»";
        deleted = "✘";
      };

      # Command duration
      cmd_duration = {
        format = "took [$duration]($style) ";
        style = "bold yellow";
        min_time = 2000;
      };

      # Language/tool modules (basic selection)
      nodejs = {
        format = "via [$symbol($version)]($style) ";
        symbol = " ";
        style = "bold green";
      };

      python = {
        format = "via [\${symbol}\${pyenv_prefix}(\${version})(\($virtualenv\))]($style) ";
        symbol = " ";
        style = "bold yellow";
      };

      rust = {
        format = "via [$symbol($version)]($style) ";
        symbol = " ";
        style = "bold red";
      };

      golang = {
        format = "via [$symbol($version)]($style) ";
        symbol = " ";
        style = "bold cyan";
      };

      docker_context = {
        format = "via [$symbol$context]($style) ";
        symbol = " ";
        style = "bold blue";
      };

      # Battery (useful for laptops)
      battery = {
        disabled = false;
        display = [
          { threshold = 10; style = "bold red"; }
          { threshold = 30; style = "bold yellow"; }
        ];
      };
    };
  };
}