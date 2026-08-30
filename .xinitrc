picom --config "$HOME/.config/picom/picom.conf" &
feh --bg-scale ~/Pictures/wallpapers/wall2.jpg
while true; do
	xsetroot -name " $(sbright) | $(svolume) | $(svolt) | $(sram) | $(scpu) | $(swifi) | $(sdate) "
	sleep 1s
done &
exec dwm
