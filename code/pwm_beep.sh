#!/bin/zsh
PWMDIR=(/sys/devices/ocp.3/pwm_test_P8_13.??)
LINUXPWMFACTOR=1000000000

zmodload zsh/system || exit 3
RUNLOCK=/tmp/${0:t}.lock
[[ -e $RUNLOCK ]] || touch $RUNLOCK
zsystem flock -t 3 $RUNLOCK || exit 0

exitclean() {
  echo 0 > $PWMDIR/run
  echo 0 > $PWMDIR/duty
  exit 0
}
trap exitclean EXIT INT

beepme() {
integer period=$((LINUXPWMFACTOR/$1/1))
integer duty=$((period/2))
echo 0 > $PWMDIR/run
echo 0 > $PWMDIR/duty
[[ $FREQ -eq 0 || $DUR -eq 0 ]] && return
echo $period > $PWMDIR/period
echo $duty> $PWMDIR/duty
echo 1 > $PWMDIR/run
sleep $2
echo 0 > $PWMDIR/run
}

PREWAIT=0
DUR=0
FREQ=0
POSTWAIT=0

while [[ -n $1 ]]; do
  case $1 in
  (-l)  DUR=$(($2/1000.0)); shift;;
  (-f)  FREQ=$2; shift;;
  (-D) POSTWAIT=$(($2/1000.0)); shift;;
  (-d) PREWAIT=$(($2/1000.0)); shift;;
  (-n|-new) 
    [[ $PREWAIT -gt 0 ]] && sleep $PREWAIT
    beepme $FREQ $DUR;
    [[ $POSTWAIT -gt 0 ]] && sleep $POSTWAIT
    DUR=0; FREQ=0; PREWAIT=0; POSTWAIT=0;
    ;;
  esac
  shift
done
[[ $PREWAIT -gt 0 ]] && sleep $PREWAIT
beepme $FREQ $DUR;
[[ $POSTWAIT -gt 0 ]] && sleep $POSTWAIT
DUR=0; FREQ=0; PREWAIT=0; POSTWAIT=0;
