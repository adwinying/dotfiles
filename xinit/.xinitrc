#
# .xinitrc
# Startup sequence for xorg
#

# Map left control to Esc when pressed alone
xcape -e 'Control_L=Escape'

# Lauch i3 wm
exec i3
