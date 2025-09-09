# Custom Zsh functions ported from Fish

# Extract function
extract() {
  case $1 in
    *.tar.bz2)   tar xjf $1     ;;
    *.tar.gz)    tar xzf $1     ;;
    *.bz2)       bunzip2 $1     ;;
    *.rar)       unrar e $1     ;;
    *.gz)        gunzip $1      ;;
    *.tar)       tar xf $1      ;;
    *.tbz2)      tar xjf $1     ;;
    *.tgz)       tar xzf $1     ;;
    *.zip)       unzip $1       ;;
    *.Z)         uncompress $1  ;;
    *.7z)        7z x $1        ;;
    *)           echo "unknown extension: $1" ;;
  esac
}

# Extract to directory function
extracttodir() {
  case $1 in
    *.tar.bz2)   tar -xjf $1 -C "$2"        ;;
    *.tar.gz)    tar -xzf $1 -C "$2"        ;;
    *.rar)       unrar x $1 "$2/"           ;;
    *.tar)       tar -xf $1 -C "$2"         ;;
    *.tbz2)      tar -xjf $1 -C "$2"        ;;
    *.tgz)       tar -xzf $1 -C "$2"        ;;
    *.zip)       unzip $1 -d $2             ;;
    *.7z)        7za e -y $1 -o"$2"         ;;
    *)           echo "unknown extension: $1" ;;
  esac
}

# List and grep function
lsr() {
  ls | rg -i "$1"
}

# Make directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Count files
num() {
  ls -1 ${1:-.} | wc -l
}

# Wget with options
wg() {
  if [ $# -eq 1 ]; then
    wget -c "$1"
  elif [ $# -eq 2 ]; then
    wget -c -O "$1" "$2"
  else
    echo "Incorrect number of arguments"
  fi
}

# YouTube download functions
ytarchive() {
  yt-dlp -f 'bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' -o '%(upload_date)s - %(channel)s - %(id)s - %(title)s.%(ext)s' \
    --sponsorblock-mark "all" \
    --geo-bypass \
    --sub-langs 'all' \
    --embed-subs \
    --embed-metadata \
    --convert-subs 'srt' \
    --download-archive "$1.txt" "https://www.youtube.com/$1/videos"
}

ytarchivevideo() {
  yt-dlp -f 'bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' -o '%(upload_date)s - %(channel)s - %(id)s - %(title)s.%(ext)s' \
    --sponsorblock-mark "all" \
    --geo-bypass \
    --sub-langs 'all' \
    --embed-metadata \
    --convert-subs 'srt' \
    --download-archive "$1" "$2"
}

ytd() {
  yt-dlp -f 'bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' -o '%(upload_date)s - %(channel)s - %(id)s - %(title)s.%(ext)s' \
    --sponsorblock-mark "all" \
    --geo-bypass \
    --sub-langs 'all' \
    --embed-subs \
    --embed-metadata \
    --convert-subs 'srt' \
    "$@"
}

ytarchiveplaylists() {
  yt-dlp --yes-playlist -f best -ciw \
    -o "/downloads/youtube-dl/%(uploader)s/playlists/%(playlist)s/videos/%(playlist_index)s - %(title)s.%(ext)s" \
    -v "$@"
}