#! /system/bin/sh
#echo "loopback test"
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
pname_play="agmplay"
pname_agmhostless="agmhostless"
pbname="loopbacktest"

if test $2 -eq $enable
then
	loopbacktest $open "$1" 13
	tinymix > /sdcard/log/loopbacktest_$1_open_$(date +%Y%m%d_%H%M%S).txt
	cat /d/regmap/wcd937x-slave.a01170223-wcd937x_csr/registers > /sdcard/log/wcd937x_registers_$1_open_$(date +%Y%m%d_%H%M%S).txt
	cat /d/regmap/soc\:spf_core_platform\:bolero-codec/registers > /sdcard/log/bolero-codec_$1_open_$(date +%Y%m%d_%H%M%S).txt
	if test $1 -eq $playback_spk -o $1 -eq $playback_rcv
	then
		echo "playback test!"
	else
		if test $1 -eq $mainmic2headphone -o $1 -eq $secmic2headphone -o $1 -eq $hsmic2headphone
		then
			start agmhostless_loop_headset
		else
			if test $1 -eq $mainmic2spk -o $1 -eq $secmic2spk -o $1 -eq $hsmic2spk
			then
				#start agmhostless_loop_spk
				start agmhostless_loop
			else
				if test $1 -eq $mainmic2rcv -o $1 -eq $hsmic2rcv
				then
					start agmhostless_loop_hsmic_rcv
				else
					start agmhostless_loop
				fi
			fi
		fi
		tinymix > /sdcard/log/loopbacktest_$1_start_$(date +%Y%m%d_%H%M%S).txt
		cat /d/regmap/wcd937x-slave.a01170223-wcd937x_csr/registers > /sdcard/log/wcd937x_registers_$1_start_$(date +%Y%m%d_%H%M%S).txt
		cat /d/regmap/soc\:spf_core_platform\:bolero-codec/registers > /sdcard/log/bolero-codec_$1_start_$(date +%Y%m%d_%H%M%S).txt
	fi
elif test $2 -eq $disable
then
	if test $1 -eq $playback_spk -o $1 -eq $playback_rcv
	then
		pkill -f $pbname
		loopbacktest $close "$1"
	else
		stop agmhostless_loop
		stop agmhostless_loop_spk
		stop agmhostless_loop_rcv
		stop agmhostless_loop_headset
		stop agmhostless_loop_hsmic_rcv
		loopbacktest $close "$1"
		tinymix > /sdcard/log/loopbacktest_$1_close_$(date +%Y%m%d_%H%M%S).txt
		cat /d/regmap/wcd937x-slave.a01170223-wcd937x_csr/registers > /sdcard/log/wcd937x_registers_$1_close_$(date +%Y%m%d_%H%M%S).txt
		cat /d/regmap/soc\:spf_core_platform\:bolero-codec/registers > /sdcard/log/bolero-codec_$1_close_$(date +%Y%m%d_%H%M%S).txt
	fi
else
	echo "input error ctl cmd!"
fi
