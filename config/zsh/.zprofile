export PATH="$HOME/projects/scripts:$PATH"

export EDITOR=vim
export VISUAL=vim

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  exec startx
fi
