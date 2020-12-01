#
# .xinitrc
# Startup sequence for xorg
#

# Map left control to Esc when pressed alone
xcape -e 'Control_L=Escape'

# Map left and right Super keys to input change
xcape -e 'Super_L=Hangul_Hanja'
xcape -e 'Super_R=Hangul'

# Compositor
picom -b

# IME
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
ibus-daemon -drx

# Lauch i3 wm
exec i3
