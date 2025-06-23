{ pkgs, username, ... }:

{
  # Let Home Manager install and manage itself.
  home-manager.enable = true;
  
  # Git config using Home Manager modules
  git = {
    enable = true;
    userName = username;
    userEmail = "michael@vessia.net";
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
    };
    extraConfig = {
      url."git@github.com:".insteadOf = "https://github.com/";
      push.autoSetupRemote = true;
    };
};
  
  # Basic nvim setup, but we'll manage dots with chezmoi
  neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  fish = {
    enable = true;
    
    # Interactive shell init
    interactiveShellInit = ''
      # Disable greeting
      set -g fish_greeting
      
      # Better colors for ls
      set -gx LS_COLORS (${pkgs.vivid}/bin/vivid generate molokai)
      
      # Set your preferred editor (already set in sessionVariables but good to have here too)
      set -gx EDITOR nvim
      
      # Better command not found handling
      function fish_command_not_found
        ${pkgs.nix-index}/bin/nix-locate --minimal --no-group --type x --type s --top-level --whole-name --at-root "/bin/$argv[1]"
      end
    '';
    
    # Shell aliases
    shellAliases = {
      # Nix aliases
      rebuild = "home-manager switch --flake .#${username}";
      update = "nix flake update";
      
      # Git aliases
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph --decorate";
      
      # Common shortcuts
      ll = "ls -lah";
      la = "ls -A";
      l = "ls -CF";
      
      # Directory navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      
      # Safety aliases
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";
    };
    
    # Custom functions
    functions = {
      # Create and enter directory
      mkcd = ''
        mkdir -p $argv[1]
        cd $argv[1]
      '';
      
      # Extract archives
      extract = ''
        if test -f $argv[1]
          switch $argv[1]
            case '*.tar.bz2'
              tar xjf $argv[1]
            case '*.tar.gz'
              tar xzf $argv[1]
            case '*.bz2'
              bunzip2 $argv[1]
            case '*.gz'
              gunzip $argv[1]
            case '*.tar'
              tar xf $argv[1]
            case '*.zip'
              unzip $argv[1]
            case '*.7z'
              7z x $argv[1]
            case '*'
              echo "Unknown archive format"
          end
        else
          echo "'$argv[1]' is not a valid file"
        end
      '';
      
      # Quick backup
      backup = ''
        cp -r $argv[1] $argv[1].backup.(date +%Y%m%d_%H%M%S)
      '';
    };
    
    # Plugins using fishPlugins
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
    ];
  };
  
  # Enable starship prompt (alternative to tide - choose one)
  # starship = {
  #   enable = true;
  #   enableFishIntegration = true;
  # };
  
  # Other programs that integrate well with fish
  fzf = {
    enable = true;
    enableFishIntegration = true;
  };
  
  zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd cd" ];
  };
}
