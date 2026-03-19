# Aliases and functions - sourced from .zshrc

### Aliases
alias ls=eza
alias yy='yay --noconfirm'

### Custom functions

# Activate venv when cd'ing to a directory
function cd() {
  builtin cd "$@"

  if [[ -z "$VIRTUAL_ENV" ]] ; then
    if [[ -d ./venv ]] ; then
      source ./venv/bin/activate
    elif [[ -d ./.venv ]] ; then
      source ./.venv/bin/activate
    fi
  else
    local parentdir
    parentdir="$(dirname "$VIRTUAL_ENV")"
    if [[ "$PWD"/ != "$parentdir"/* ]] ; then
      deactivate
    fi
  fi
}

# Perform checks on shutdown
shutdown () {
  local projects_dir=~/projects
  if [[ -d "$projects_dir/Obsidian-Vault" ]]; then
    cd "$projects_dir/Obsidian-Vault"
    if [[ -n $(git status --porcelain) ]]; then
      git add .
      git commit -m "$(uname -n) $(date +'%d-%m-%Y')"
      git push
    fi
    cd - > /dev/null
  fi

  rm ~/.startup_check

  command shutdown "$@"
}

# Sync arch-install configs: link repo configs to this machine (run from repo root)
arch-sync() {
  local repo="${1:-$HOME/projects/arch-install}"
  if [[ ! -d "$repo/config/zsh" ]]; then
    echo "Not a repo root: $repo"
    return 1
  fi
  (cd "$repo" && ./update_local_configs.sh)
}

# Open project in Cursor.
# - Uses workspace file when available: $HOME/workspaces/<name>.code-workspace
# - Otherwise opens: $HOME/projects/<name>
cr() {
  local project="$1"
  local projects_dir="$HOME/projects"
  local workspaces_dir="$HOME/workspaces"

  if [[ -z "$project" ]]; then
    command cursor "$projects_dir"
    return
  fi

  local workspace_file="$workspaces_dir/${project}.code-workspace"
  local project_path="$projects_dir/$project"

  if [[ -f "$workspace_file" ]]; then
    command cursor "$workspace_file"
  elif [[ -e "$project_path" ]]; then
    command cursor "$project_path"
  else
    echo "Project not found: $project"
    return 1
  fi
}

# Completion for `cr` from $HOME/projects.
_cr() {
  local projects_dir="$HOME/projects"
  [[ -d "$projects_dir" ]] || return 1
  _path_files -W "$projects_dir"
}

if (( $+functions[compdef] )); then
  compdef _cr cr
  compdef _wallpaper wallpaper
fi


# Set wallpaper and apply pywal theme to alacritty, polybar, dunst
wallpaper() {
  local wallpapers_dir="$HOME/.wallpapers"

  if [[ -z "$1" ]]; then
    echo "Usage: wallpaper <image>"
    return 1
  fi

  local file="$1"
  [[ -f "$file" ]] || file="$wallpapers_dir/$file"

  if [[ ! -f "$file" ]]; then
    echo "File not found: $1"
    return 1
  fi

  feh --bg-fill "$file"
  wal -i "$file" -n -q
  bash ~/.config/polybar/launch.sh &>/dev/null &disown
  sleep 0.3
  killall -9 dunst &>/dev/null
  sleep 0.5
  dunst &disown 2>/dev/null
}

_wallpaper() {
  local wallpapers_dir="$HOME/.wallpapers"
  [[ -d "$wallpapers_dir" ]] || return 1
  _path_files -W "$wallpapers_dir"
}

# MongoDB Compass with gnome-libsecret password store
mongodb-compass() {
  command mongodb-compass --password-store="gnome-libsecret" --ignore-additional-command-line-flags "$@"
}

# Monitor controls
monitor-165hz() {
  xrandr --output DisplayPort-0 --mode 2560x1440 --rate 165.00
}

turn-monitor-off() {
  local monitor="DisplayPort-1"
  case "$1" in
    --first)  monitor="DisplayPort-0" ;;
    --second) monitor="DisplayPort-1" ;;
  esac
  xrandr --output "$monitor" --off
}

turn-monitor-on() {
  xrandr --output DisplayPort-1 --right-of DisplayPort-0 --auto
}

# Quick edit of aliases (opens in $EDITOR, then sources)
alias edit-aliases='${EDITOR:-vim} ~/.aliases.zshrc && source ~/.aliases.zshrc'
