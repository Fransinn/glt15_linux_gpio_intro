#!/bin/zsh

LDIR=${0:h}
cd $LDIR
AIN=(/sys/devices/ocp.?/helper.??/AIN0)

cat $AIN >/dev/null
sleep 1
cat $AIN >/dev/null

MOISTURE_UP_CNT=0
MOISTURE_LW_CNT=0

while sleep 8; do
  MOISTURE=$(<$AIN)
  if   [[ $MOISTURE -lt 320 ]] ; then MOISTURE_LW_CNT=$((MOISTURE_LW_CNT+1)); MOISTURE_UP_CNT=0;
  elif [[ $MOISTURE -gt 900 ]] ; then MOISTURE_UP_CNT=$((MOISTURE_UP_CNT+1)); MOISTURE_LW_CNT=0;
  else MOISTURE_UP_CNT=0; MOISTURE_LW_CNT=0;
  fi

  [[ $MOISTURE_LW_CNT -gt 2 ]] && ./imperialmarch.sh
  [[ $MOISTURE_UP_CNT -gt 2 ]] && ./daftpunkt.sh
done
