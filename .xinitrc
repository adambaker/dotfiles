#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/usr/X11/lib/X11/xinit/.Xresources
sysmodmap=/usr/X11/lib/X11/xinit/.Xmodmap

xset r rate 190 40
xset -b

# merge in defaults and keymaps

if test -f $sysresources; then
  if test -x /usr/bin/cpp; then
    xrdb -merge "$sysresources"
  else
    xrdb -nocpp -merge "$sysresources"
  fi
fi

if test -f $sysmodmap; then
  xmodmap $sysmodmap
fi

if test -f $userresources; then
  if test -x /usr/bin/cpp; then
    xrdb -merge "$userresources"
  else
    xrdb -nocpp -merge "$userresources"
  fi
fi

if test -f $usermodmap; then
  xmodmap "$usermodmap"
fi

while true ; do
  qual=$(iwconfig wlan0 | grep '[0-9]\+\/[0-9]\+' -o)
  a=$(echo $qual | egrep '^[0-9]+' -o)
  b=$(echo $qual | egrep '[0-9]+$' -o)

  if test -e $b; then
    qual=(($a * 100 / $b))%
  fi

  xsetroot -name "$(iwconfig wlan0 | head -n 1 | awk '{ print $4 }') $qual ($( acpi -b | awk '{ print $3, $4 }' | tr -d ',' )) $(date +"%R, %D")"
  sleep 10s
done &

keychain ~/.ssh/id_rsa

if test -f "~/.keychain/$HOSTNAME-sh"; then
  . ~/.keychain/$HOSTNAME-sh 2>/dev/null
fi

if test -f "~/.keychain/$HOSTNAME-sh-gpg"; then
  . ~/.keychain/$HOSTNAME-sh-gpg 2>/dev/null
fi

exec dwm
