#!/bin/sh

kill redshift &> /dev/null

envFile=~/bin/redshift/env.sh
changeValue=300


changeMode() {
  sed -i "s/REDSHIFT=$1/REDSHIFT=$2/g" $envFile 
  REDSHIFT=$2
  echo $REDSHIFT
}

changeTemp() {
  if [ "$2" -gt 1000 ] && [ "$2" -lt 25000 ]
  then
    sed -i "s/REDSHIFT_TEMP=$1/REDSHIFT_TEMP=$2/g" $envFile 
    redshift -P -O $((REDSHIFT_TEMP+changeValue))
  fi
}

case $1 in 
  toggle) 
    if [ "$REDSHIFT" = on ];
    then
      changeMode "$REDSHIFT" off
      redshift -x
    else
      changeMode "$REDSHIFT" on
      redshift -O "$REDSHIFT_TEMP"
    fi
    ;;
  increase)
    changeMode "$REDSHIFT" on;
    changeTemp $((REDSHIFT_TEMP)) $((REDSHIFT_TEMP+changeValue));
    ;;
  decrease)
    changeMode "$REDSHIFT" on;
    changeTemp $((REDSHIFT_TEMP)) $((REDSHIFT_TEMP-changeValue));
    ;;
  temperature)
    case $REDSHIFT in
      on)
        echo "%{F#A3BE8C}󱩌%{F-}" 
        ;;
      off)
        echo "%{F#d35f5e}%{F-}"
        ;;
    esac
    ;;
esac