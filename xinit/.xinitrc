#
# .xinitrc
# Startup sequence for xorg
#

# Map left control to Esc when pressed alone
xcape -e 'Control_L=Escape'

# Compositor
picom -b

# IME
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
ibus-daemon -drx

# Lauch i3 wm
exec i3
