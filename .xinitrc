#!/bin/sh
# $Xorg: xinitrc.cpp,v 1.3 2000/08/17 19:54:30 cpqbld Exp $

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/usr/X11/lib/X11/xinit/.Xresources
sysmodmap=/usr/X11/lib/X11/xinit/.Xmodmap

xset r rate 190 40
xset -b

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    if [ -x /usr/bin/cpp ] ; then
        xrdb -merge $sysresources
    else
        xrdb -nocpp -merge $sysresources
    fi
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    if [ -x /usr/bin/cpp ] ; then
        xrdb -merge "$userresources"
    else
        xrdb -nocpp -merge "$userresources"
    fi
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs
if [ -d /usr/X11/lib/X11/xinit/xinitrc.d ] ; then
  for f in /usr/X11/lib/X11/xinit/xinitrc.d/*.sh ; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Disable bell
xset -b

while true ; do
  QUAL=`iwconfig wlan0 | grep '[0-9]\+\/[0-9]\+' -o`
  A=`echo $QUAL | egrep '^[0-9]+' -o`
  B=`echo $QUAL | egrep '[0-9]+$' -o`

  if [ $B ]; then
    QUAL=$(($A * 100 / $B))%
  fi

  xsetroot -name "$(iwconfig wlan0 | head -n 1 | awk '{ print $4 }') $QUAL ($( acpi -b | awk '{ print $3, $4 }' | tr -d ',' )) $(date +"%R, %D")"
  sleep 1m
done &

keychain ~/.ssh/id_rsa
[ -f ~/.keychain/$HOSTNAME-sh ] && . ~/.keychain/$HOSTNAME-sh 2>/dev/null
[ -f ~/.keychain/$HOSTNAME-sh-gpg ] && . ~/.keychain/$HOSTNAME-sh-gpg 2>/dev/null

exec dwm
