#
# .xinitrc
# Startup sequence for xorg
#

xcape="xcape -e 'Control_L=Escape;Super_L=Hangul_Hanja;Super_R=Hangul'"
picom="picom -b"

# IME
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus

# To start a session other wm: startx ~/.xinitrc [wm]
session=${1:-awesome}

if [[ "$session" == "i3" ]] || [[ "$sesion" == "i3wm" ]]; then
  $xcape
  $picom
  exec i3

elif [[ "$session" == "dwm" ]]; then
  feh --bg-scale /home/adwin/.config/awesome/wallpapers/pe.jpg &
  picom &
  $xcape &
  exec dwm

elif [[ "$session" == "awesome" ]]; then
  exec awesome

# No known session, try to run it as command
else
  exec $1
fi
