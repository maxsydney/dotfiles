#!/usr/bin/env bash

## Application Launcher & Window Switcher
## Combined interface with multiple modes

FILE="$HOME/.config/polybar/scripts/rofi/colors.rasi"

## random accent color (disabled by default)
#COLORS=('#EC7875' '#EC6798' '#BE78D1' '#75A4CD' '#00C7DF' '#00B19F' '#61C766' \
#		'#B9C244' '#EBD369' '#EDB83F' '#E57C46' '#AC8476' '#6C77BB' '#6D8895')
#AC="${COLORS[$(( $RANDOM % 14 ))]}"
#SE="${COLORS[$(( $RANDOM % 14 ))]}"
#sed -i -e "s/ac: .*/ac:   ${AC}FF;/g" $FILE
#sed -i -e "s/se: .*/se:   ${SE}FF;/g" $FILE

# Launch rofi with both drun and window modes
# Use Ctrl+Tab or Left/Right arrow keys to switch between modes
rofi -no-config -no-lazy-grab -show drun -modi drun,window -theme ~/.config/polybar/scripts/rofi/launcher.rasi
