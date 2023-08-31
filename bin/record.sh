#! /system/bin/sh
#echo "record test"
mainmic2spk=1
hsmic2rcv=2
mainmic2headphone=3
secmic2headphone=4
playback_spk=5
playback_rcv=6
capture_mainmic=7
capture_secmic=8
secmic2spk=9
mainmic2rcv=10
hsmic2headphone=11
hsmic2spk=12
capture_hsmic=13
enable=1
disable=0
open="-Y"
close="-N"
pname_play="agmcap"
pbname="loopbacktest"

if test $2 -eq $enable
then
	loopbacktest $open "$1" 13
	#tinymix > /sdcard/log/record_$1_open_$(date +%Y%m%d_%H%M%S).txt
	if test $1 -eq $playback_spk -o $1 -eq $playback_rcv
	then
		echo "playback test!"
	else
		agmcap /sdcard/miccapture.wav -D 100 -d 101 -c 1 -r 48000 -b 16 -i "CODEC_DMA-LPAIF_RXTX-TX-3"
		#tinymix > /sdcard/log/record_$1_start_$(date +%Y%m%d_%H%M%S).txt
	fi
elif test $2 -eq $disable
then
	if test $1 -eq $playback_spk -o $1 -eq $playback_rcv
	then
		pkill -f $pbname
		loopbacktest $close "$1"
	else
		loopbacktest $close "$1"
		#tinymix > /sdcard/log/record_$1_close_$(date +%Y%m%d_%H%M%S).txt
	fi
else
	echo "input error ctl cmd!"
fi
