{ config, pkgs, lib, ... }:

{
	home.packages = with pkgs; [
		fish
		fishPlugins.bass
		atuin # Replacement for shell history
	];
	
	# Auto-start fish from bash
	home.file.".bashrc".text = lib.mkAfter ''
		if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
		then
			exec fish
		fi
	'';

programs.fish = {

	enable = true;

	interactiveShellInit = pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
		# Source Nix environment
		if test -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
			source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
		end
		
		# Add Homebrew to PATH for macOS
		if test -d /opt/homebrew/bin
			fish_add_path /opt/homebrew/bin
		end
		if test -d /usr/local/bin
			fish_add_path /usr/local/bin
		end
		
		# Add ~/.local/bin to PATH for user binaries (e.g., Claude CLI)
		if test -d ~/.local/bin
			fish_add_path ~/.local/bin
		end
		
		# Load Home Manager session variables
		if test -f $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
			bass source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
		end
		
		# Load FLOCASTS_NPM_TOKEN from secrets
		if test -f $HOME/home-manager/secrets/flocasts-npm-token
			set -gx FLOCASTS_NPM_TOKEN (cat $HOME/home-manager/secrets/flocasts-npm-token | tr -d '\n')
		end
		
		# Load JIRA_API_TOKEN from secrets
		if test -f $HOME/home-manager/secrets/jira-api-token
			set -gx JIRA_API_TOKEN (cat $HOME/home-manager/secrets/jira-api-token | tr -d '\n')
		end
	'';

	shellAliases = {
		".." = "cd ..";
		"..." = "cd ../..";
		"...." = "cd ../../../";
		"....." = "cd ../../../../";
		
		"dots" = "chezmoi cd";
		"hm" = "cd ~/home-manager";


		# zoxide aliases (cd is now handled by zoxide directly)
		"cdi" = "zi";

    "ls" = "eza";
    "ll" = "eza -l";
    "la" = "eza -la";
    "lt" = "eza --tree";

		"cp" = "cp -v";
		"ddf" = "df -h";
		"etc" = "erd -H";
		"mkdir" = "mkdir -p";
		"mv" = "mv -v";
		"rm" = "rm -v";


		"avi" = "vlc *.avi";
		"jpeg" = "feh -Z *.jpeg";
		"jpg" = "feh -Z *.jpg";
		"mkv" = "vlc *.mkv";
		"mov" = "vlc *.mov";
		"mp3" = "vlc *.mp3";
		"mp4" = "vlc *.mp4";
		"png" = "feh -Z *.png";
		"vvlc" = "vlc *";
		"webm" = "vlc *.webm";
		
	};
	
	shellAbbrs = {
		# git abbreviations
		gaa  = "git add -A";
		ga   = "git add";
		gbd  = "git branch --delete";
		gb   = "git branch";
		gc   = "git commit";
		gcm  = "git commit -m";
		gcob = "git checkout -b";
		gco  = "git checkout";
		gd   = "git diff";
		gl   = "git log";
		gp   = "git push";
		gph = "git push -u origin HEAD";
		gs   = "git status";
		gst  = "git stash";
		gstp =  "git stash pop";
	};

	functions = {

		extract = '' 
		function extract
	    switch $argv[1]
	        case "*.tar.bz2"
	            tar xjf $argv[1]

	        case "*.tar.gz"
	            tar xzf $argv[1]

	        case "*.bz2"
	            bunzip2 $argv[1]

	        case "*.rar"
	            unrar e $argv[1]

	        case "*.gz"
	            gunzip $argv[1]

	        case "*.tar"
	            tar xf $argv[1]

	        case "*.tbz2"
	            tar xjf $argv[1]

	        case "*.tgz"
	            tar xzf $argv[1]

	        case "*.zip"
	            unzip $argv[1]

	        case "*.Z"
	            uncompress $argv[1]

	        case "*.7z"
	            7z x $argv[1]

	        case "*"
	            echo "unknown extension: $argv[1]"
	    end
		end
		'';


		extracttodir = '' 
		function extracttodir
		    switch $argv[1]
		        case "*.tar.bz2"
		            tar -xjf $argv[1] -C "$argv[2]"

		        case "*.tar.gz"
		            tar -xzf $argv[1] -C "$argv[2]"

		        case "*.rar"
		            unrar x $argv[1] "$argv[2]/"

		        case "*.tar"
		            tar -xf $argv[1] -C "$argv[2]"

		        case "*.tbz2"
		            tar -xjf $argv[1] -C "$argv[2]"

		        case "*.tgz"
		            tar -xzf $argv[1] -C "$argv[2]"

		        case "*.zip"
		            unzip $argv[1] -d $argv[2]

		        case "*.7z"
		            7za e -y $argv[1] -o"$argv[2]"

		        case "*"
		            echo "unknown extension: $argv[1]"
		    end
		end
		'';
		
		lsr = ''
		function lsr
    	ls | rg -i $argv[1]
		end
		 '';

		mkcd = '' 
		function mkcd --argument name
			mkdir -p $name
			cd $name
		end
		'';

		num = '' 
		function num 
			ls -1 $argv | wc -l;
		end
		'';

		wg = '' 
		function wg
	    set -l num_args (count $argv)

	    if test $num_args -eq 1
	        wget -c $argv[1]

	    else if test $num_args -eq 2
	        # arg1 = name, arg2 = url
	        wget -c -O $argv[1] $argv[2]

	    else
	        echo "Incorrect number of arguments"
	    end
		end
		'';

		ytarchive = '' 
		function ytarchive
		 yt-dlp -f bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best -o '%(upload_date)s - %(channel)s - %(id)s - %(title)s.%(ext)s' \
		 --sponsorblock-mark "all" \
		 --geo-bypass \
		 --sub-langs 'all' \
		 --embed-subs \
		 --embed-metadata \
		 --convert-subs 'srt' \
		 --download-archive $argv[1].txt https://www.youtube.com/$argv[1]/videos; 
		end
		'';

		ytarchivevideo = '' 
		function ytarchivevideo
		  yt-dlp -f bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best -o '%(upload_date)s - %(channel)s - %(id)s - %(title)s.%(ext)s' \
		 --sponsorblock-mark "all" \
		 --geo-bypass \
		 --sub-langs 'all' \
		 --embed-metadata \
		 --convert-subs 'srt' \
		 --download-archive $argv[1] $argv[2]; 
		end
		'';

		ytd = '' 
		function ytd
     yt-dlp -f bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best -o '%(upload_date)s - %(channel)s - %(id)s - %(title)s.%(ext)s' \
		 --sponsorblock-mark "all" \
		 --geo-bypass \
		 --sub-langs 'all' \
		 --embed-subs \
		 --embed-metadata \
		 --convert-subs 'srt' \
		 $argv
		end
		'';

		ytarchiveplaylists = ''
		function ytarchiveplaylists
		 yt-dlp --yes-playlist -f best -ciw \
		 -o "/downloads/youtube-dl/%(uploader)s/playlists/%(playlist)s/videos/%(playlist_index)s - %(title)s.%(ext)s" \
		 -v $argv
		end
		'';
	};

};

programs.fzf = {
	enable = true;
	enableFishIntegration = true;
	
	defaultOptions = [
		"--height 40%"
		"--layout=reverse"
		"--border"
	];
	
	fileWidgetOptions = [
		"--preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || echo {}'"
	];
	
	changeDirWidgetOptions = [
		"--preview 'eza --tree --level=2 --color=always {} 2>/dev/null || echo {}'"
	];
	
	defaultCommand = "fd --type f --hidden --follow --exclude .git";
	fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
	changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
};

programs.zoxide = {
	enable = true;
	enableFishIntegration = true;
	options = [
		"--cmd cd"  # This makes 'cd' command use zoxide
	];
};
}
