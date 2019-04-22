#!/bin/bash

#      Copyright (C) 2019 Jan-Luca Neumann
#      https://github.com/sunsettrack4/easyepg
#
#      Collaborators:
#      - DeBaschdi ( https://github.com/DeBaschdi )
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with easyepg. If not, see <http://www.gnu.org/licenses/>.

# COMBINE XML SOURCE FILES

# #################
# M1300 MAIN MENU #
# #################

# M1300 MENU OVERLAY
echo 'dialog --backtitle "[M1300] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION" --title "SETUP MENU" --menu "Please choose:\nOption [1] to add a new setup for combined XML sources, or\nOption [2] to modify an existing one." 12 62 10 \' > /tmp/menu

# M1310 ADD
echo '	1 "ADD SETUP MODULE" \' >> /tmp/menu

# M1320 MODIFY
if ls -l combine/ 2> /dev/null | grep -q '^d'
then
	echo '	2 "MODIFY SETUP MODULE" \' >> /tmp/menu
fi

echo "2> /tmp/value" >> /tmp/menu

bash /tmp/menu
input="$(cat /tmp/value)"


# #################
# M1310 ADD SETUP #
# #################

if grep -q "1" /tmp/value
then
	rm /tmp/value
	rm /tmp/setupname 2> /dev/null
	
	until [ -s /tmp/setupname ]
	do
		# M1310 MENU OVERLAY
		dialog --backtitle "[M1310] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > ADD" --title "SETUP NAME" --inputbox "\nPlease enter a name for your setup:" 8 45 2> /tmp/setupname
		
		while grep -q "[[:punct:] ]" /tmp/setupname
		do
			# M131E SPECIAL CHARACTERS
			dialog --backtitle "[M131E] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > ADD" --title "SETUP NAME" --inputbox "Name must not contain special symbols!\nPlease enter a name for your setup:" 8 45 2> /tmp/setupname
			
			ls combine > /tmp/dir 2> /dev/null
			echo $(</tmp/setupname) >> /tmp/dir
			sort /tmp/dir | uniq -d > /tmp/dircompare
			
			while [ -s /tmp/dircompare ]
			do
				# M131E DUPLICATED NAME
				dialog --backtitle "[M131E] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > ADD" --title "SETUP NAME" --inputbox "Name already exists for another setup!\nPlease enter a name for your setup:" 8 45 2> /tmp/setupname
				
				ls combine > /tmp/dir 2> /dev/null
				echo $(</tmp/setupname) >> /tmp/dir
				sort /tmp/dir | uniq -d > /tmp/dircompare
			done
		done
		
		ls combine > /tmp/dir 2> /dev/null
		echo $(</tmp/setupname) >> /tmp/dir
		sort /tmp/dir | uniq -d > /tmp/dircompare
		
		while [ -s /tmp/dircompare ]
		do
			# M131F DUPLICATED NAME
			dialog --backtitle "[M131F] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > ADD" --title "SETUP NAME" --inputbox "Name already exists for another setup!\nPlease enter a name for your setup:" 8 45 2> /tmp/setupname
			
			ls combine > /tmp/dir 2> /dev/null
			echo $(</tmp/setupname) >> /tmp/dir
			sort /tmp/dir | uniq -d > /tmp/dircompare
			
			while grep -q "[[:punct:] ]" /tmp/setupname
			do
				# M131F SPECIAL CHARACTERS
				dialog --backtitle "[M131F] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > ADD" --title "SETUP NAME" --inputbox "Name must not contain special symbols!\nPlease enter a name for your setup:" 8 45 2> /tmp/setupname
				
				ls combine > /tmp/dir 2> /dev/null
				echo $(</tmp/setupname) >> /tmp/dir
				sort /tmp/dir | uniq -d > /tmp/dircompare
			done
		done
		
		if [ ! -s /tmp/setupname ]
		then
			echo "*** NO INPUT ***" > /tmp/setupname
		fi
	done
	
	if grep -q "*** NO INPUT ***" /tmp/setupname
	then
		rm /tmp/setupname
		echo "C" > /tmp/value
	elif [ -s /tmp/setupname ]
	then
		mkdir combine 2> /dev/null
		mkdir "combine/$(</tmp/setupname)"
		touch /tmp/chduplicates
		
		while [ -e /tmp/chduplicates ]
		do
			rm /tmp/xmlch2 2> /dev/null
			
			# ###############
			# COLLECT FILES #
			# ###############
			
			echo 'dialog --backtitle "[M1311] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > ADD" --title "CHANNEL LIST" --checklist "Please choose the channels you want to grab:" 15 50 10 \' > /tmp/chmenu
			
			if [ -e xml/horizon_de.xml ]
			then
				grep 'channel id=' xml/horizon_de.xml > /tmp/xmlch && cat /tmp/xmlch > /tmp/xmlch2
				sed 's/<channel id="/"[HORIZON DE] /g;s/">/" "" on \\/g' /tmp/xmlch >> /tmp/chmenu
			fi
			
			if [ -e xml/horizon_at.xml ]
			then
				grep 'channel id=' xml/horizon_at.xml > /tmp/xmlch && cat /tmp/xmlch >> /tmp/xmlch2
				sed 's/<channel id="/"[HORIZON AT] /g;s/">/" "" on \\/g' /tmp/xmlch >> /tmp/chmenu
			fi
			
			if [ -e xml/horizon_ch.xml ]
			then
				grep 'channel id=' xml/horizon_ch.xml > /tmp/xmlch && cat /tmp/xmlch >> /tmp/xmlch2
				sed 's/<channel id="/"[HORIZON CH] /g;s/">/" "" on \\/g' /tmp/xmlch >> /tmp/chmenu
			fi
			
			if [ -e xml/horizon_nl.xml ]
			then
				grep 'channel id=' xml/horizon_nl.xml > /tmp/xmlch && cat /tmp/xmlch >> /tmp/xmlch2
				sed 's/<channel id="/"[HORIZON NL] /g;s/">/" "" on \\/g' /tmp/xmlch >> /tmp/chmenu
			fi
			
			if [ -e xml/horizon_pl.xml ]
			then
				grep 'channel id=' xml/horizon_pl.xml > /tmp/xmlch && cat /tmp/xmlch >> /tmp/xmlch2
				sed 's/<channel id="/"[HORIZON PL] /g;s/">/" "" on \\/g' /tmp/xmlch >> /tmp/chmenu
			fi
			
			if [ -e xml/horizon_ie.xml ]
			then
				grep 'channel id=' xml/horizon_ie.xml > /tmp/xmlch && cat /tmp/xmlch >> /tmp/xmlch2
				sed 's/<channel id="/"[HORIZON IE] /g;s/">/" "" on \\/g' /tmp/xmlch >> /tmp/chmenu
			fi
			
			if [ -e xml/horizon_sk.xml ]
			then
				grep 'channel id=' xml/horizon_sk.xml > /tmp/xmlch && cat /tmp/xmlch >> /tmp/xmlch2
				sed 's/<channel id="/"[HORIZON SK] /g;s/">/" "" on \\/g' /tmp/xmlch >> /tmp/chmenu
			fi
			
			if [ -e xml/horizon_cz.xml ]
			then
				grep 'channel id=' xml/horizon_cz.xml > /tmp/xmlch && cat /tmp/xmlch >> /tmp/xmlch2
				sed 's/<channel id="/"[HORIZON CZ] /g;s/">/" "" on \\/g' /tmp/xmlch >> /tmp/chmenu
			fi
			
			if [ -e xml/horizon_hu.xml ]
			then
				grep 'channel id=' xml/horizon_hu.xml > /tmp/xmlch && cat /tmp/xmlch >> /tmp/xmlch2
				sed 's/<channel id="/"[HORIZON HU] /g;s/">/" "" on \\/g' /tmp/xmlch >> /tmp/chmenu
			fi
			
			if [ -e xml/horizon_ro.xml ]
			then
				grep 'channel id=' xml/horizon_ro.xml > /tmp/xmlch && cat /tmp/xmlch >> /tmp/xmlch2
				sed 's/<channel id="/"[HORIZON RO] /g;s/">/" "" on \\/g' /tmp/xmlch >> /tmp/chmenu
			fi
			
			if [ -e xml/zattoo_de.xml ]
			then
				grep 'channel id=' xml/zattoo_de.xml > /tmp/xmlch && cat /tmp/xmlch >> /tmp/xmlch2
				sed 's/<channel id="/"[ZATTOO DE] /g;s/">/" "" on \\/g' /tmp/xmlch >> /tmp/chmenu
			fi
			
			if [ -e xml/zattoo_ch.xml ]
			then
				grep 'channel id=' xml/zattoo_ch.xml > /tmp/xmlch && cat /tmp/xmlch >> /tmp/xmlch2
				sed 's/<channel id="/"[ZATTOO CH] /g;s/">/" "" on \\/g' /tmp/xmlch >> /tmp/chmenu
			fi
			
			if [ -e xml/swisscom_ch.xml ]
			then
				grep 'channel id=' xml/swisscom_ch.xml > /tmp/xmlch && cat /tmp/xmlch >> /tmp/xmlch2
				sed 's/<channel id="/"[SWISSCOM CH] /g;s/">/" "" on \\/g' /tmp/xmlch >> /tmp/chmenu
			fi
			
			if [ -e xml/tvplayer_uk.xml ]
			then
				grep 'channel id=' xml/tvplayer_uk.xml > /tmp/xmlch && cat /tmp/xmlch >> /tmp/xmlch2
				sed 's/<channel id="/"[TVPLAYER UK] /g;s/">/" "" on \\/g' /tmp/xmlch >> /tmp/chmenu
			fi
			
			if [ -e xml/magentatv_de.xml ]
			then
				grep 'channel id=' xml/magentatv_de.xml > /tmp/xmlch && cat /tmp/xmlch >> /tmp/xmlch2
				sed 's/<channel id="/"[MAGENTATV DE] /g;s/">/" "" on \\/g' /tmp/xmlch >> /tmp/chmenu
			fi
			
			if [ -e xml/external_oa.xml ]
			then
				grep 'channel id=' xml/external_oa.xml > /tmp/xmlch && cat /tmp/xmlch >> /tmp/xmlch2
				sed 's/<channel id="/"[EXTERNAL OA] /g;s/">/" "" on \\/g' /tmp/xmlch >> /tmp/chmenu
			fi
			
			echo "2>/tmp/channels" >> /tmp/chmenu
			
			sort /tmp/xmlch2 | uniq -d > /tmp/chduplicates
			sed -i 's/<channel id="//g;s/">//g' /tmp/chduplicates
			
			if [ -s /tmp/chduplicates ]
			then
				dialog --backtitle "[M131W] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > ADD" --title "WARNING" --msgbox "Duplicated Channel IDs exist in this setup!\nPlease remove the duplicated entries from setup.\n\nList of duplicated Channel IDs:\n\n$(</tmp/chduplicates)" 12 55 2> /tmp/value
			else
				rm /tmp/chduplicates
			fi
			
			sed -i 's/\&amp;/\&/g' /tmp/chmenu
			bash /tmp/chmenu
			
			if [ ! -s /tmp/channels ]
			then
				rm -rf combine/$(</tmp/setupname) 2> /dev/null
				rm /tmp/setupname /tmp/chduplicates 2> /dev/null
			else
				sed 's/\\\[/[/g;s/\\\]/]/g;s/\\(/(/g;s/\\)/)/g;s/\\\&/\&/g' /tmp/channels > /tmp/xmlch2
				sed -i 's/ "\[HORIZON [A-Z][A-Z]\] /\n/g;s/"\[HORIZON [A-Z][A-Z]\] //g;s/ "\[ZATTOO [A-Z][A-Z]\] /\n/g;s/"\[ZATTOO [A-Z][A-Z]\] //g;s/ "\[SWISSCOM [A-Z][A-Z]\] /\n/g;s/"\[SWISSCOM [A-Z][A-Z]\] //g;s/ "\[TVPLAYER [A-Z][A-Z]\] /\n/g;s/"\[TVPLAYER [A-Z][A-Z]\] //g;s/ "\[MAGENTATV [A-Z][A-Z]\] /\n/g;s/"\[MAGENTATV [A-Z][A-Z]\] //g;s/ "\[EXTERNAL [A-Z][A-Z]\] /\n/g;s/"\[EXTERNAL [A-Z][A-Z]\] //g;s/"//g;s/"//g' /tmp/xmlch2
				sort /tmp/xmlch2 | uniq -d > /tmp/chduplicates
				
				if [ -s /tmp/chduplicates ]
				then
					dialog --backtitle "[M131E] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > ADD" --title "ERROR" --infobox "Duplicated Channel IDs exist in this setup!" 5 40
					sleep 2s
				else
					rm /tmp/chduplicates
				fi
			fi
		done
		
		# ####################
		# SAVE CONFIGURATION #
		# ####################
		
		if [ -s /tmp/channels ]
		then
			sed -i 's/\\\[/[/g;s/\\\]/]/g;s/\\(/(/g;s/\\)/)/g;s/\\\&/\&/g' /tmp/channels
			sed -i 's/ "\[HORIZON/\n"\[HORIZON/g;s/ "\[ZATTOO/\n"\[ZATTOO/g;s/ "\[SWISSCOM/\n"\[SWISSCOM/g;s/ "\[TVPLAYER/\n"\[TVPLAYER/g;s/ "\[MAGENTATV/\n"\[MAGENTATV/g;s/ "\[EXTERNAL/\n"\[EXTERNAL/g' /tmp/channels
			
			if [ -e /tmp/setupname ]
			then
				if [ -e xml/horizon_de.xml ]
				then
					grep "HORIZON DE" /tmp/channels | sed '/HORIZON DE/s/\[HORIZON DE\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(</tmp/setupname)/hzn_de_channels.json
				fi
				
				if [ -e xml/horizon_at.xml ]
				then
					grep "HORIZON AT" /tmp/channels | sed '/HORIZON AT/s/\[HORIZON AT\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(</tmp/setupname)/hzn_at_channels.json
				fi
				
				if [ -e xml/horizon_ch.xml ]
				then
					grep "HORIZON CH" /tmp/channels | sed '/HORIZON CH/s/\[HORIZON CH\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(</tmp/setupname)/hzn_ch_channels.json
				fi
				
				if [ -e xml/horizon_nl.xml ]
				then
					grep "HORIZON NL" /tmp/channels | sed '/HORIZON NL/s/\[HORIZON NL\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(</tmp/setupname)/hzn_nl_channels.json
				fi
				
				if [ -e xml/horizon_pl.xml ]
				then
					grep "HORIZON PL" /tmp/channels | sed '/HORIZON PL/s/\[HORIZON PL\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(</tmp/setupname)/hzn_pl_channels.json
				fi
				
				if [ -e xml/horizon_ie.xml ]
				then
					grep "HORIZON IE" /tmp/channels | sed '/HORIZON IE/s/\[HORIZON IE\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(</tmp/setupname)/hzn_ie_channels.json
				fi
				
				if [ -e xml/horizon_sk.xml ]
				then
					grep "HORIZON SK" /tmp/channels | sed '/HORIZON SK/s/\[HORIZON SK\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(</tmp/setupname)/hzn_sk_channels.json
				fi
				
				if [ -e xml/horizon_cz.xml ]
				then
					grep "HORIZON CZ" /tmp/channels | sed '/HORIZON CZ/s/\[HORIZON CZ\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(</tmp/setupname)/hzn_cz_channels.json
				fi
				
				if [ -e xml/horizon_hu.xml ]
				then
					grep "HORIZON HU" /tmp/channels | sed '/HORIZON HU/s/\[HORIZON HU\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(</tmp/setupname)/hzn_hu_channels.json
				fi
				
				if [ -e xml/horizon_ro.xml ]
				then
					grep "HORIZON RO" /tmp/channels | sed '/HORIZON RO/s/\[HORIZON RO\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(</tmp/setupname)/hzn_ro_channels.json
				fi
				
				if [ -e xml/zattoo_de.xml ]
				then
					grep "ZATTOO DE" /tmp/channels | sed '/ZATTOO DE/s/\[ZATTOO DE\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(</tmp/setupname)/ztt_de_channels.json
				fi
				
				if [ -e xml/zattoo_ch.xml ]
				then
					grep "ZATTOO CH" /tmp/channels | sed '/ZATTOO CH/s/\[ZATTOO CH\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(</tmp/setupname)/ztt_ch_channels.json
				fi
				
				if [ -e xml/swisscom_ch.xml ]
				then
					grep "SWISSCOM CH" /tmp/channels | sed '/SWISSCOM CH/s/\[SWISSCOM CH\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(</tmp/setupname)/swc_ch_channels.json
				fi
				
				if [ -e xml/tvplayer_uk.xml ]
				then
					grep "TVPLAYER UK" /tmp/channels | sed '/TVPLAYER UK/s/\[TVPLAYER UK\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(</tmp/setupname)/tvp_uk_channels.json
				fi
				
				if [ -e xml/magentatv_de.xml ]
				then
					grep "MAGENTATV DE" /tmp/channels | sed '/MAGENTATV DE/s/\[MAGENTATV DE\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(</tmp/setupname)/tkm_de_channels.json
				fi
				
				if [ -e xml/external_oa.xml ]
				then
					grep "EXTERNAL OA" /tmp/channels | sed '/EXTERNAL OA/s/\[EXTERNAL OA\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(</tmp/setupname)/ext_oa_channels.json
				fi
				
				if [ -e xml/external_ob.xml ]
				then
					grep "EXTERNAL OB" /tmp/channels | sed '/EXTERNAL OB/s/\[EXTERNAL OB\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(</tmp/setupname)/ext_ob_channels.json
				fi
				
				if [ -e xml/external_oc.xml ]
				then
					grep "EXTERNAL OC" /tmp/channels | sed '/EXTERNAL OC/s/\[EXTERNAL OC\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(</tmp/setupname)/ext_oc_channels.json
				fi
			fi
			
			dialog --backtitle "[M131S] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > ADD" --title "INFO" --msgbox "New channel list added!" 5 30
		else
			dialog --backtitle "[M131I] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > ADD" --title "INFO" --msgbox "Channel list creation aborted!\nPlease note that at least 1 channel must be included in channel list!" 7 50
		fi
		
		echo "C" > /tmp/value
	fi

# ####################
# M1320 MODIFY SETUP #
# ####################

elif grep -q "2" /tmp/value
then
	echo 'dialog --backtitle "[M132S] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > MODIFY" --title "MODIFY SETUP" --menu "Please select the setup you want to modify:" 12 45 10 \' > /tmp/setupname
	ls combine > /tmp/combine
	sed 's/.*/"&" \\/g' /tmp/combine > /tmp/setupmenu
	nl /tmp/setupmenu >> /tmp/setupname
	echo "2> /tmp/selectedsetup" >> /tmp/setupname
	bash /tmp/setupname
	
	if [ -s /tmp/selectedsetup ]
	then
		echo "B" > /tmp/value
		while grep -q "B" /tmp/value
		do
			# M1320 MENU OVERLAY
			echo 'dialog --backtitle "[M1320] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > MODIFY" --title "MODIFY SETUP" --menu "Please choose an option:" 12 45 10 \' > /tmp/menu
			
			# M1321 CHANNEL LIST
			echo '	1 "MODIFY CHANNEL LIST" \' >> /tmp/menu
			
			# M1322 ADDON SCRIPTS
			echo '	2 "USE ADDON SCRIPTS" \' >> /tmp/menu
			
			# M1323 POST SCRIPTS
			echo '	3 "ADD/MODIFY POST SHELL SCRIPT" \' >> /tmp/menu
			
			# M1324 REMOVE SETUP
			echo '	4 "REMOVE THIS SETUP" \' >> /tmp/menu
			
			echo "2> /tmp/setupvalue" >> /tmp/menu
			bash /tmp/menu
			
			if grep -q "1" /tmp/setupvalue
			then
				touch /tmp/menu
				
				while [ -e /tmp/menu ]
				do
					# ####################
					# M1321 COLLECT DATA #
					# ####################
					
					rm /tmp/xmlch_* /tmp/channels_* /tmp/chduplicates /tmp/xmlch2 2> /dev/null
					
					echo 'dialog --backtitle "[M1321] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > MODIFY" --title "CHANNEL LIST" --checklist "Please choose the channels you want to grab:" 15 50 10 \' > /tmp/chmenu
					
					# HORIZON DE
					if [ -e xml/horizon_de.xml ]
					then
						grep 'channel id=' xml/horizon_de.xml > /tmp/xmlch_de
						sed -i 's/<channel id="/[HORIZON DE] /g;s/">//g;s/\&amp;/\&/g' /tmp/xmlch_de
					else
						rm combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_de_channels.json 2> /dev/null
					fi
					
					touch combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_de_channels.json /tmp/xmlch_de
					cd combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)
					
					if [ -e hzn_de_channels.json ]
					then
						sed '/{"channels":\[/d;/}/d;s/",//g;s/"\]//g;s/"//g' hzn_de_channels.json > /tmp/channels_de && cat /tmp/channels_de >> /tmp/xmlch2
						sed -i 's/.*/[HORIZON DE] &/g' /tmp/channels_de
						
						comm -12 <(sort -u /tmp/xmlch_de) <(sort -u /tmp/channels_de) > /tmp/comm_menu_enabled
						comm -2 -3 <(sort -u /tmp/xmlch_de) <(sort -u /tmp/channels_de) > /tmp/comm_menu_disabled
						sed 's/.*/"&" "" on \\/g' /tmp/comm_menu_enabled >> /tmp/chmenu
						sed 's/.*/"&" "" off \\/g' /tmp/comm_menu_disabled >> /tmp/chmenu
					fi
					
					cd - > /dev/null
					
					# HORIZON AT
					if [ -e xml/horizon_at.xml ]
					then
						grep 'channel id=' xml/horizon_at.xml > /tmp/xmlch_at
						sed -i 's/<channel id="/[HORIZON AT] /g;s/">//g;s/\&amp;/\&/g' /tmp/xmlch_at
					else
						rm combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_at_channels.json 2> /dev/null
					fi
					
					touch combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_at_channels.json /tmp/xmlch_at
					cd combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)
					
					if [ -e hzn_at_channels.json ]
					then
						sed '/{"channels":\[/d;/}/d;s/",//g;s/"\]//g;s/"//g' hzn_at_channels.json > /tmp/channels_at && cat /tmp/channels_at >> /tmp/xmlch2
						sed -i 's/.*/[HORIZON AT] &/g' /tmp/channels_at
						
						comm -12 <(sort -u /tmp/xmlch_at) <(sort -u /tmp/channels_at) > /tmp/comm_menu_enabled
						comm -2 -3 <(sort -u /tmp/xmlch_at) <(sort -u /tmp/channels_at) > /tmp/comm_menu_disabled
						sed 's/.*/"&" "" on \\/g' /tmp/comm_menu_enabled >> /tmp/chmenu
						sed 's/.*/"&" "" off \\/g' /tmp/comm_menu_disabled >> /tmp/chmenu
					fi
					
					cd - > /dev/null
					
					# HORIZON CH
					if [ -e xml/horizon_ch.xml ]
					then
						grep 'channel id=' xml/horizon_ch.xml > /tmp/xmlch_ch
						sed -i 's/<channel id="/[HORIZON CH] /g;s/">//g;s/\&amp;/\&/g' /tmp/xmlch_ch
					else
						rm combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_ch_channels.json 2> /dev/null
					fi
					
					touch combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_ch_channels.json /tmp/xmlch_ch
					cd combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)
					
					if [ -e hzn_ch_channels.json ]
					then
						sed '/{"channels":\[/d;/}/d;s/",//g;s/"\]//g;s/"//g' hzn_ch_channels.json > /tmp/channels_ch && cat /tmp/channels_ch >> /tmp/xmlch2
						sed -i 's/.*/[HORIZON CH] &/g' /tmp/channels_ch
						
						comm -12 <(sort -u /tmp/xmlch_ch) <(sort -u /tmp/channels_ch) > /tmp/comm_menu_enabled
						comm -2 -3 <(sort -u /tmp/xmlch_ch) <(sort -u /tmp/channels_ch) > /tmp/comm_menu_disabled
						sed 's/.*/"&" "" on \\/g' /tmp/comm_menu_enabled >> /tmp/chmenu
						sed 's/.*/"&" "" off \\/g' /tmp/comm_menu_disabled >> /tmp/chmenu
					fi
					
					cd - > /dev/null
					
					# HORIZON NL
					if [ -e xml/horizon_nl.xml ]
					then
						grep 'channel id=' xml/horizon_nl.xml > /tmp/xmlch_nl
						sed -i 's/<channel id="/[HORIZON NL] /g;s/">//g;s/\&amp;/\&/g' /tmp/xmlch_nl
					else
						rm combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_nl_channels.json 2> /dev/null
					fi
					
					touch combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_nl_channels.json /tmp/xmlch_nl
					cd combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)
						
					if [ -e hzn_nl_channels.json ]
					then
						sed '/{"channels":\[/d;/}/d;s/",//g;s/"\]//g;s/"//g' hzn_nl_channels.json > /tmp/channels_nl && cat /tmp/channels_nl >> /tmp/xmlch2
						sed -i 's/.*/[HORIZON NL] &/g' /tmp/channels_nl
						
						comm -12 <(sort -u /tmp/xmlch_nl) <(sort -u /tmp/channels_nl) > /tmp/comm_menu_enabled
						comm -2 -3 <(sort -u /tmp/xmlch_nl) <(sort -u /tmp/channels_nl) > /tmp/comm_menu_disabled
						sed 's/.*/"&" "" on \\/g' /tmp/comm_menu_enabled >> /tmp/chmenu
						sed 's/.*/"&" "" off \\/g' /tmp/comm_menu_disabled >> /tmp/chmenu
					fi
						
					cd - > /dev/null
					
					# HORIZON PL
					if [ -e xml/horizon_pl.xml ]
					then
						grep 'channel id=' xml/horizon_pl.xml > /tmp/xmlch_pl
						sed -i 's/<channel id="/[HORIZON PL] /g;s/">//g;s/\&amp;/\&/g' /tmp/xmlch_pl
					else
						rm combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_pl_channels.json 2> /dev/null
					fi
					
					touch combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_pl_channels.json /tmp/xmlch_pl
					cd combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)
					
					if [ -e hzn_pl_channels.json ]
					then
						sed '/{"channels":\[/d;/}/d;s/",//g;s/"\]//g;s/"//g' hzn_pl_channels.json > /tmp/channels_pl && cat /tmp/channels_pl >> /tmp/xmlch2
						sed -i 's/.*/[HORIZON PL] &/g' /tmp/channels_pl
						
						comm -12 <(sort -u /tmp/xmlch_pl) <(sort -u /tmp/channels_pl) > /tmp/comm_menu_enabled
						comm -2 -3 <(sort -u /tmp/xmlch_pl) <(sort -u /tmp/channels_pl) > /tmp/comm_menu_disabled
						sed 's/.*/"&" "" on \\/g' /tmp/comm_menu_enabled >> /tmp/chmenu
						sed 's/.*/"&" "" off \\/g' /tmp/comm_menu_disabled >> /tmp/chmenu
					fi
					
					cd - > /dev/null
					
					# HORIZON IE
					if [ -e xml/horizon_ie.xml ]
					then
						grep 'channel id=' xml/horizon_ie.xml > /tmp/xmlch_ie
						sed -i 's/<channel id="/[HORIZON IE] /g;s/">//g;s/\&amp;/\&/g' /tmp/xmlch_ie
					else
						rm combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_ie_channels.json 2> /dev/null
					fi
					
					touch combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_ie_channels.json /tmp/xmlch_ie
					cd combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)
					
					if [ -e hzn_ie_channels.json ]
					then
						sed '/{"channels":\[/d;/}/d;s/",//g;s/"\]//g;s/"//g' hzn_ie_channels.json > /tmp/channels_ie && cat /tmp/channels_ie >> /tmp/xmlch2
						sed -i 's/.*/[HORIZON IE] &/g' /tmp/channels_ie
						
						comm -12 <(sort -u /tmp/xmlch_ie) <(sort -u /tmp/channels_ie) > /tmp/comm_menu_enabled
						comm -2 -3 <(sort -u /tmp/xmlch_ie) <(sort -u /tmp/channels_ie) > /tmp/comm_menu_disabled
						sed 's/.*/"&" "" on \\/g' /tmp/comm_menu_enabled >> /tmp/chmenu
						sed 's/.*/"&" "" off \\/g' /tmp/comm_menu_disabled >> /tmp/chmenu
					fi
					
					cd - > /dev/null
					
					# HORIZON SK
					if [ -e xml/horizon_sk.xml ]
					then
						grep 'channel id=' xml/horizon_sk.xml > /tmp/xmlch_sk
						sed -i 's/<channel id="/[HORIZON SK] /g;s/">//g;s/\&amp;/\&/g' /tmp/xmlch_sk
					else
						rm combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_sk_channels.json 2> /dev/null
					fi
					
					touch combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_sk_channels.json /tmp/xmlch_sk
					cd combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)
					
					if [ -e hzn_sk_channels.json ]
					then
						sed '/{"channels":\[/d;/}/d;s/",//g;s/"\]//g;s/"//g' hzn_sk_channels.json > /tmp/channels_sk && cat /tmp/channels_sk >> /tmp/xmlch2
						sed -i 's/.*/[HORIZON SK] &/g' /tmp/channels_sk
						
						comm -12 <(sort -u /tmp/xmlch_sk) <(sort -u /tmp/channels_sk) > /tmp/comm_menu_enabled
						comm -2 -3 <(sort -u /tmp/xmlch_sk) <(sort -u /tmp/channels_sk) > /tmp/comm_menu_disabled
						sed 's/.*/"&" "" on \\/g' /tmp/comm_menu_enabled >> /tmp/chmenu
						sed 's/.*/"&" "" off \\/g' /tmp/comm_menu_disabled >> /tmp/chmenu
					fi
					
					cd - > /dev/null
					
					# HORIZON CZ
					if [ -e xml/horizon_cz.xml ]
					then
						grep 'channel id=' xml/horizon_cz.xml > /tmp/xmlch_cz
						sed -i 's/<channel id="/[HORIZON CZ] /g;s/">//g;s/\&amp;/\&/g' /tmp/xmlch_cz
					else
						rm combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_cz_channels.json 2> /dev/null
					fi
					
					touch combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_cz_channels.json /tmp/xmlch_cz
					cd combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)
					
					if [ -e hzn_cz_channels.json ]
					then
						sed '/{"channels":\[/d;/}/d;s/",//g;s/"\]//g;s/"//g' hzn_cz_channels.json > /tmp/channels_cz && cat /tmp/channels_cz >> /tmp/xmlch2
						sed -i 's/.*/[HORIZON CZ] &/g' /tmp/channels_cz
						
						comm -12 <(sort -u /tmp/xmlch_cz) <(sort -u /tmp/channels_cz) > /tmp/comm_menu_enabled
						comm -2 -3 <(sort -u /tmp/xmlch_cz) <(sort -u /tmp/channels_cz) > /tmp/comm_menu_disabled
						sed 's/.*/"&" "" on \\/g' /tmp/comm_menu_enabled >> /tmp/chmenu
						sed 's/.*/"&" "" off \\/g' /tmp/comm_menu_disabled >> /tmp/chmenu
					fi
					
					cd - > /dev/null
					
					# HORIZON HU
					if [ -e xml/horizon_hu.xml ]
					then
						grep 'channel id=' xml/horizon_hu.xml > /tmp/xmlch_hu
						sed -i 's/<channel id="/[HORIZON HU] /g;s/">//g;s/\&amp;/\&/g' /tmp/xmlch_hu
					else
						rm combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_hu_channels.json 2> /dev/null
					fi
					
					touch combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_hu_channels.json /tmp/xmlch_hu
					cd combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)
					
					if [ -e hzn_hu_channels.json ]
					then
						sed '/{"channels":\[/d;/}/d;s/",//g;s/"\]//g;s/"//g' hzn_hu_channels.json > /tmp/channels_hu && cat /tmp/channels_hu >> /tmp/xmlch2
						sed -i 's/.*/[HORIZON HU] &/g' /tmp/channels_hu
						
						comm -12 <(sort -u /tmp/xmlch_hu) <(sort -u /tmp/channels_hu) > /tmp/comm_menu_enabled
						comm -2 -3 <(sort -u /tmp/xmlch_hu) <(sort -u /tmp/channels_hu) > /tmp/comm_menu_disabled
						sed 's/.*/"&" "" on \\/g' /tmp/comm_menu_enabled >> /tmp/chmenu
						sed 's/.*/"&" "" off \\/g' /tmp/comm_menu_disabled >> /tmp/chmenu
					fi
					
					cd - > /dev/null
					
					# HORIZON RO
					if [ -e xml/horizon_ro.xml ]
					then
						grep 'channel id=' xml/horizon_ro.xml > /tmp/xmlch_ro
						sed -i 's/<channel id="/[HORIZON RO] /g;s/">//g;s/\&amp;/\&/g' /tmp/xmlch_ro
					else
						rm combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_ro_channels.json 2> /dev/null
					fi
					
					touch combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_ro_channels.json /tmp/xmlch_ro
					cd combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)
					
					if [ -e hzn_ro_channels.json ]
					then
						sed '/{"channels":\[/d;/}/d;s/",//g;s/"\]//g;s/"//g' hzn_ro_channels.json > /tmp/channels_ro && cat /tmp/channels_ro >> /tmp/xmlch2
						sed -i 's/.*/[HORIZON RO] &/g' /tmp/channels_ro
						
						comm -12 <(sort -u /tmp/xmlch_ro) <(sort -u /tmp/channels_ro) > /tmp/comm_menu_enabled
						comm -2 -3 <(sort -u /tmp/xmlch_ro) <(sort -u /tmp/channels_ro) > /tmp/comm_menu_disabled
						sed 's/.*/"&" "" on \\/g' /tmp/comm_menu_enabled >> /tmp/chmenu
						sed 's/.*/"&" "" off \\/g' /tmp/comm_menu_disabled >> /tmp/chmenu
					fi
					
					cd - > /dev/null
					
					# ZATTOO DE
					if [ -e xml/zattoo_de.xml ]
					then
						grep 'channel id=' xml/zattoo_de.xml > /tmp/xmlch_zde
						sed -i 's/<channel id="/[ZATTOO DE] /g;s/">//g;s/\&amp;/\&/g' /tmp/xmlch_zde
					else
						rm combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/ztt_de_channels.json 2> /dev/null
					fi
					
					touch combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/ztt_de_channels.json /tmp/xmlch_zde
					cd combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)
					
					if [ -e ztt_de_channels.json ]
					then
						sed '/{"channels":\[/d;/}/d;s/",//g;s/"\]//g;s/"//g' ztt_de_channels.json > /tmp/channels_zde && cat /tmp/channels_zde >> /tmp/xmlch2
						sed -i 's/.*/[ZATTOO DE] &/g' /tmp/channels_zde
						
						comm -12 <(sort -u /tmp/xmlch_zde) <(sort -u /tmp/channels_zde) > /tmp/comm_menu_enabled
						comm -2 -3 <(sort -u /tmp/xmlch_zde) <(sort -u /tmp/channels_zde) > /tmp/comm_menu_disabled
						sed 's/.*/"&" "" on \\/g' /tmp/comm_menu_enabled >> /tmp/chmenu
						sed 's/.*/"&" "" off \\/g' /tmp/comm_menu_disabled >> /tmp/chmenu
					fi
					
					cd - > /dev/null
					
					# ZATTOO CH
					if [ -e xml/zattoo_ch.xml ]
					then
						grep 'channel id=' xml/zattoo_ch.xml > /tmp/xmlch_zch
						sed -i 's/<channel id="/[ZATTOO CH] /g;s/">//g;s/\&amp;/\&/g' /tmp/xmlch_zch
					else
						rm combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/ztt_ch_channels.json 2> /dev/null
					fi
					
					touch combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/ztt_ch_channels.json /tmp/xmlch_zch
					cd combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)
					
					if [ -e ztt_ch_channels.json ]
					then
						sed '/{"channels":\[/d;/}/d;s/",//g;s/"\]//g;s/"//g' ztt_ch_channels.json > /tmp/channels_zch && cat /tmp/channels_zch >> /tmp/xmlch2
						sed -i 's/.*/[ZATTOO CH] &/g' /tmp/channels_zch
						
						comm -12 <(sort -u /tmp/xmlch_zch) <(sort -u /tmp/channels_zch) > /tmp/comm_menu_enabled
						comm -2 -3 <(sort -u /tmp/xmlch_zch) <(sort -u /tmp/channels_zch) > /tmp/comm_menu_disabled
						sed 's/.*/"&" "" on \\/g' /tmp/comm_menu_enabled >> /tmp/chmenu
						sed 's/.*/"&" "" off \\/g' /tmp/comm_menu_disabled >> /tmp/chmenu
					fi
					
					cd - > /dev/null
					
					# SWISSCOM CH
					if [ -e xml/swisscom_ch.xml ]
					then
						grep 'channel id=' xml/swisscom_ch.xml > /tmp/xmlch_swc
						sed -i 's/<channel id="/[SWISSCOM CH] /g;s/">//g;s/\&amp;/\&/g' /tmp/xmlch_swc
					else
						rm combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/swc_ch_channels.json 2> /dev/null
					fi
					
					touch combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/swc_ch_channels.json /tmp/xmlch_swc
					cd combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)
					
					if [ -e swc_ch_channels.json ]
					then
						sed '/{"channels":\[/d;/}/d;s/",//g;s/"\]//g;s/"//g' swc_ch_channels.json > /tmp/channels_swc && cat /tmp/channels_swc >> /tmp/xmlch2
						sed -i 's/.*/[SWISSCOM CH] &/g' /tmp/channels_swc
						
						comm -12 <(sort -u /tmp/xmlch_swc) <(sort -u /tmp/channels_swc) > /tmp/comm_menu_enabled
						comm -2 -3 <(sort -u /tmp/xmlch_swc) <(sort -u /tmp/channels_swc) > /tmp/comm_menu_disabled
						sed 's/.*/"&" "" on \\/g' /tmp/comm_menu_enabled >> /tmp/chmenu
						sed 's/.*/"&" "" off \\/g' /tmp/comm_menu_disabled >> /tmp/chmenu
					fi
					
					cd - > /dev/null
					
					# TVPLAYER UK
					if [ -e xml/tvplayer_uk.xml ]
					then
						grep 'channel id=' xml/tvplayer_uk.xml > /tmp/xmlch_tvp
						sed -i 's/<channel id="/[TVPLAYER UK] /g;s/">//g;s/\&amp;/\&/g' /tmp/xmlch_tvp
					else
						rm combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/tvp_uk_channels.json 2> /dev/null
					fi
					
					touch combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/tvp_uk_channels.json /tmp/xmlch_tvp
					cd combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)
					
					if [ -e tvp_uk_channels.json ]
					then
						sed '/{"channels":\[/d;/}/d;s/",//g;s/"\]//g;s/"//g' tvp_uk_channels.json > /tmp/channels_tvp && cat /tmp/channels_tvp >> /tmp/xmlch2
						sed -i 's/.*/[TVPLAYER UK] &/g' /tmp/channels_tvp
						
						comm -12 <(sort -u /tmp/xmlch_tvp) <(sort -u /tmp/channels_tvp) > /tmp/comm_menu_enabled
						comm -2 -3 <(sort -u /tmp/xmlch_tvp) <(sort -u /tmp/channels_tvp) > /tmp/comm_menu_disabled
						sed 's/.*/"&" "" on \\/g' /tmp/comm_menu_enabled >> /tmp/chmenu
						sed 's/.*/"&" "" off \\/g' /tmp/comm_menu_disabled >> /tmp/chmenu
					fi
					
					cd - > /dev/null
					
					# MAGENTATV DE
					if [ -e xml/magentatv_de.xml ]
					then
						grep 'channel id=' xml/magentatv_de.xml > /tmp/xmlch_tkmde
						sed -i 's/<channel id="/[MAGENTATV DE] /g;s/">//g;s/\&amp;/\&/g' /tmp/xmlch_tkmde
					else
						rm combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/tkm_de_channels.json 2> /dev/null
					fi
					
					touch combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/tkm_de_channels.json /tmp/xmlch_tkmde
					cd combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)
					
					if [ -e tkm_de_channels.json ]
					then
						sed '/{"channels":\[/d;/}/d;s/",//g;s/"\]//g;s/"//g' tkm_de_channels.json > /tmp/channels_tkmde && cat /tmp/channels_tkmde >> /tmp/xmlch2
						sed -i 's/.*/[MAGENTATV DE] &/g' /tmp/channels_tkmde
						
						comm -12 <(sort -u /tmp/xmlch_tkmde) <(sort -u /tmp/channels_tkmde) > /tmp/comm_menu_enabled
						comm -2 -3 <(sort -u /tmp/xmlch_tkmde) <(sort -u /tmp/channels_tkmde) > /tmp/comm_menu_disabled
						sed 's/.*/"&" "" on \\/g' /tmp/comm_menu_enabled >> /tmp/chmenu
						sed 's/.*/"&" "" off \\/g' /tmp/comm_menu_disabled >> /tmp/chmenu
					fi
					
					cd - > /dev/null
					
					# EXTERNAL SLOT 1
					if [ -e xml/external_oa.xml ]
					then
						grep 'channel id=' xml/external_oa.xml > /tmp/xmlch_extoa
						sed -i 's/<channel id="/[EXTERNAL OA] /g;s/">//g;s/\&amp;/\&/g' /tmp/xmlch_extoa
					else
						rm combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/ext_oa_channels.json 2> /dev/null
					fi
					
					touch combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/ext_oa_channels.json /tmp/xmlch_extoa
					cd combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)
					
					if [ -e ext_oa_channels.json ]
					then
						sed '/{"channels":\[/d;/}/d;s/",//g;s/"\]//g;s/"//g' ext_oa_channels.json > /tmp/channels_extoa && cat /tmp/channels_extoa >> /tmp/xmlch2
						sed -i 's/.*/[EXTERNAL OA] &/g' /tmp/channels_extoa
						
						comm -12 <(sort -u /tmp/xmlch_extoa) <(sort -u /tmp/channels_extoa) > /tmp/comm_menu_enabled
						comm -2 -3 <(sort -u /tmp/xmlch_extoa) <(sort -u /tmp/channels_extoa) > /tmp/comm_menu_disabled
						sed 's/.*/"&" "" on \\/g' /tmp/comm_menu_enabled >> /tmp/chmenu
						sed 's/.*/"&" "" off \\/g' /tmp/comm_menu_disabled >> /tmp/chmenu
					fi
					
					cd - > /dev/null
					
					# EXTERNAL SLOT 2
					if [ -e xml/external_ob.xml ]
					then
						grep 'channel id=' xml/external_ob.xml > /tmp/xmlch_extob
						sed -i 's/<channel id="/[EXTERNAL OB] /g;s/">//g;s/\&amp;/\&/g' /tmp/xmlch_extob
					else
						rm combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/ext_ob_channels.json 2> /dev/null
					fi
					
					touch combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/ext_ob_channels.json /tmp/xmlch_extob
					cd combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)
					
					if [ -e ext_ob_channels.json ]
					then
						sed '/{"channels":\[/d;/}/d;s/",//g;s/"\]//g;s/"//g' ext_ob_channels.json > /tmp/channels_extob && cat /tmp/channels_extob >> /tmp/xmlch2
						sed -i 's/.*/[EXTERNAL OB] &/g' /tmp/channels_extob
						
						comm -12 <(sort -u /tmp/xmlch_extob) <(sort -u /tmp/channels_extob) > /tmp/comm_menu_enabled
						comm -2 -3 <(sort -u /tmp/xmlch_extob) <(sort -u /tmp/channels_extob) > /tmp/comm_menu_disabled
						sed 's/.*/"&" "" on \\/g' /tmp/comm_menu_enabled >> /tmp/chmenu
						sed 's/.*/"&" "" off \\/g' /tmp/comm_menu_disabled >> /tmp/chmenu
					fi
					
					cd - > /dev/null
					
					# EXTERNAL SLOT 3
					if [ -e xml/external_oc.xml ]
					then
						grep 'channel id=' xml/external_oc.xml > /tmp/xmlch_extoc
						sed -i 's/<channel id="/[EXTERNAL OC] /g;s/">//g;s/\&amp;/\&/g' /tmp/xmlch_extoc
					else
						rm combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/ext_oc_channels.json 2> /dev/null
					fi
					
					touch combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/ext_oc_channels.json /tmp/xmlch_extoc
					cd combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)
					
					if [ -e ext_oc_channels.json ]
					then
						sed '/{"channels":\[/d;/}/d;s/",//g;s/"\]//g;s/"//g' ext_oc_channels.json > /tmp/channels_extoc && cat /tmp/channels_extoc >> /tmp/xmlch2
						sed -i 's/.*/[EXTERNAL OC] &/g' /tmp/channels_extoc
						
						comm -12 <(sort -u /tmp/xmlch_extoc) <(sort -u /tmp/channels_extoc) > /tmp/comm_menu_enabled
						comm -2 -3 <(sort -u /tmp/xmlch_extoc) <(sort -u /tmp/channels_extoc) > /tmp/comm_menu_disabled
						sed 's/.*/"&" "" on \\/g' /tmp/comm_menu_enabled >> /tmp/chmenu
						sed 's/.*/"&" "" off \\/g' /tmp/comm_menu_disabled >> /tmp/chmenu
					fi
					
					cd - > /dev/null
					
					# END
					echo "2>/tmp/channels" >> /tmp/chmenu
					
					sort /tmp/xmlch2 | uniq -d > /tmp/chduplicates
					
					if [ -s /tmp/chduplicates ]
					then
						dialog --backtitle "[M132E] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > MODIFY" --title "ERROR" --msgbox "Duplicated Channel IDs exist in this setup!\nPlease remove the duplicated entries from setup.\n\nList of duplicated Channel IDs:\n\n$(</tmp/chduplicates)" 12 55 2> /tmp/value
					else
						rm /tmp/chduplicates 2> /dev/null
					fi
					
					if [ -e /tmp/menu ]
					then
						if grep -q -E "\[HORIZON [A-Z][A-Z]\]|\[ZATTOO [A-Z][A-Z]\]|\[SWISSCOM [A-Z][A-Z]\]|\[TVPLAYER [A-Z][A-Z]\]|\[MAGENTATV [A-Z][A-Z]\]|\[EXTERNAL [A-Z][A-Z]\]" /tmp/chmenu
						then
							bash /tmp/chmenu
							rm /tmp/menu
						else
							dialog --backtitle "[M132F] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > MODIFY" --title "FATAL ERROR" --msgbox "Channel setup based on non-existing XML files! Setup files deleted!" 6 50
							rm /tmp/menu /tmp/channels
							touch /tmp/error
						fi
					fi
					
				
					# ####################
					# SAVE CONFIGURATION #
					# ####################
					
					if [ -s /tmp/channels ]
					then
						sed -i 's/\\\[/[/g;s/\\\]/]/g;s/\\(/(/g;s/\\)/)/g;s/\\\&/\&/g' /tmp/channels
						sed 's/ "\[HORIZON [A-Z][A-Z]\] /\n/g;s/"\[HORIZON [A-Z][A-Z]\] //g;s/ "\[ZATTOO [A-Z][A-Z]\] /\n/g;s/"\[ZATTOO [A-Z][A-Z]\] //g;s/ "\[SWISSCOM [A-Z][A-Z]\] /\n/g;s/"\[SWISSCOM [A-Z][A-Z]\] //g;s/ "\[TVPLAYER [A-Z][A-Z]\] /\n/g;s/"\[TVPLAYER [A-Z][A-Z]\] //g;s/ "\[MAGENTATV [A-Z][A-Z]\] /\n/g;s/"\[MAGENTATV [A-Z][A-Z]\] //g;s/ "\[EXTERNAL [A-Z][A-Z]\] /\n/g;s/"\[EXTERNAL [A-Z][A-Z]\] //g;s/"//g' /tmp/channels > /tmp/xmlch2
							
						sed -i 's/ "\[HORIZON/\n"\[HORIZON/g;s/ "\[ZATTOO/\n"\[ZATTOO/g;s/ "\[SWISSCOM/\n"\[SWISSCOM/g;s/ "\[TVPLAYER/\n"\[TVPLAYER/g;s/ "\[MAGENTATV/\n"\[MAGENTATV/g;s/ "\[EXTERNAL/\n"\[EXTERNAL/g;' /tmp/channels
						
						if [ -e combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine) ]
						then
							if [ -e xml/horizon_de.xml ]
							then
								grep "HORIZON DE" /tmp/channels | sed '/HORIZON DE/s/\[HORIZON DE\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_de_channels.json
							fi
							
							if [ -e xml/horizon_at.xml ]
							then
								grep "HORIZON AT" /tmp/channels | sed '/HORIZON AT/s/\[HORIZON AT\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_at_channels.json
							fi
							
							if [ -e xml/horizon_ch.xml ]
							then
								grep "HORIZON CH" /tmp/channels | sed '/HORIZON CH/s/\[HORIZON CH\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_ch_channels.json
							fi
							
							if [ -e xml/horizon_nl.xml ]
							then
								grep "HORIZON NL" /tmp/channels | sed '/HORIZON NL/s/\[HORIZON NL\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_nl_channels.json
							fi
							
							if [ -e xml/horizon_pl.xml ]
							then
								grep "HORIZON PL" /tmp/channels | sed '/HORIZON PL/s/\[HORIZON PL\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_pl_channels.json
							fi
							
							if [ -e xml/horizon_ie.xml ]
							then
								grep "HORIZON IE" /tmp/channels | sed '/HORIZON IE/s/\[HORIZON IE\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_ie_channels.json
							fi
							
							if [ -e xml/horizon_sk.xml ]
							then
								grep "HORIZON SK" /tmp/channels | sed '/HORIZON SK/s/\[HORIZON SK\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_sk_channels.json
							fi
							
							if [ -e xml/horizon_cz.xml ]
							then
								grep "HORIZON CZ" /tmp/channels | sed '/HORIZON CZ/s/\[HORIZON CZ\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_cz_channels.json
							fi
							
							if [ -e xml/horizon_hu.xml ]
							then
								grep "HORIZON HU" /tmp/channels | sed '/HORIZON HU/s/\[HORIZON HU\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_hu_channels.json
							fi
							
							if [ -e xml/horizon_ro.xml ]
							then
								grep "HORIZON RO" /tmp/channels | sed '/HORIZON RO/s/\[HORIZON RO\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/hzn_ro_channels.json
							fi
							
							if [ -e xml/zattoo_de.xml ]
							then
								grep "ZATTOO DE" /tmp/channels | sed '/ZATTOO DE/s/\[ZATTOO DE\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/ztt_de_channels.json
							fi
							
							if [ -e xml/zattoo_ch.xml ]
							then
								grep "ZATTOO CH" /tmp/channels | sed '/ZATTOO CH/s/\[ZATTOO CH\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/ztt_ch_channels.json
							fi
							
							if [ -e xml/swisscom_ch.xml ]
							then
								grep "SWISSCOM CH" /tmp/channels | sed '/SWISSCOM CH/s/\[SWISSCOM CH\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/swc_ch_channels.json
							fi
							
							if [ -e xml/tvplayer_uk.xml ]
							then
								grep "TVPLAYER UK" /tmp/channels | sed '/TVPLAYER UK/s/\[TVPLAYER UK\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/tvp_uk_channels.json
							fi
							
							if [ -e xml/magentatv_de.xml ]
							then
								grep "MAGENTATV DE" /tmp/channels | sed '/MAGENTATV DE/s/\[MAGENTATV DE\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/tkm_de_channels.json
							fi
							
							if [ -e xml/external_oa.xml ]
							then
								grep "EXTERNAL OA" /tmp/channels | sed '/EXTERNAL OA/s/\[EXTERNAL OA\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/ext_oa_channels.json
							fi
							
							if [ -e xml/external_ob.xml ]
							then
								grep "EXTERNAL OB" /tmp/channels | sed '/EXTERNAL OB/s/\[EXTERNAL OB\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/ext_ob_channels.json
							fi
							
							if [ -e xml/external_oc.xml ]
							then
								grep "EXTERNAL OC" /tmp/channels | sed '/EXTERNAL OC/s/\[EXTERNAL OC\] //g;s/.*/&,/g;$s/,/]\n}/g;1i{"channels":\[' > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/ext_oc_channels.json
							fi
						fi
						
						sort /tmp/xmlch2 | uniq -d > /tmp/chduplicates
					
						if [ -s /tmp/chduplicates ]
						then
							touch /tmp/menu
						else
							dialog --backtitle "[M132I] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > MODIFY" --title "INFO" --msgbox "New channel list saved!" 5 30
						fi
					elif [ -e /tmp/error ]
					then
						rm /tmp/error
					else
						dialog --backtitle "[M132I] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > MODIFY" --title "INFO" --msgbox "Channel list unchanged!\nPlease note that at least 1 channel must be included in channel list!" 7 50
					fi
					
					echo "B" > /tmp/value
				done
			elif grep -q "2" /tmp/setupvalue
			then
				# #####################
				# M1322 ADDON SCRIPTS #
				# #####################
				
				echo "ADDON" > /tmp/addonvalue
				
				while [ -s /tmp/addonvalue ]
				do
				
					echo 'dialog --backtitle "[M1322] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > ADDONS" --title "ADDON SETUP" --menu "Please choose the following options:\n[1] RATING MAPPER: Add additional data to description line\n[2] IMDB MAPPER: Insert additional data from IMDb source" 12 70 10 \' > /tmp/addonmenu
					
					if [ -e combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/ratingmapper.pl ]
					then
						echo '	1 "Remove: RATING MAPPER" \' >> /tmp/addonmenu
					else
						echo '	1 "Insert: RATING MAPPER" \' >> /tmp/addonmenu
					fi
					
					if [ -e combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/imdbmapper.pl ]
					then
						echo '	2 "Remove: IMDB MAPPER" \' >> /tmp/addonmenu
					else
						echo '	2 "Insert: IMDB MAPPER" \' >> /tmp/addonmenu
					fi
					
					echo "2>/tmp/addonvalue" >> /tmp/addonmenu
					
					bash /tmp/addonmenu
					
					if grep -q "1" /tmp/addonvalue
					then
						if [ -e combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/ratingmapper.pl ]
						then
							rm combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/ratingmapper.pl
							dialog --backtitle "[M1322] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > ADDONS" --title "ADDON SETUP" --msgbox "Addon RATING MAPPER deleted!" 5 35
						else
							curl -s https://raw.githubusercontent.com/DeBaschdi/EPGScripts/master/ratingmapper/ratingmapper.pl > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/ratingmapper.pl
							dialog --backtitle "[M1322] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > ADDONS" --title "ADDON SETUP" --msgbox "Addon RATING MAPPER added!" 5 35
						fi
					elif grep -q "2" /tmp/addonvalue
					then
						if [ -e combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/imdbmapper.pl ]
						then
							cd combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)
							rm Readme age.php country.php imdb.class.php imdbmapper.pl poster.php rating.php url.php year.php
							dialog --backtitle "[M1322] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > ADDONS" --title "ADDON SETUP" --msgbox "Addon IMDB MAPPER deleted!" 5 35
							cd - > /dev/null
						else
							curl -s https://raw.githubusercontent.com/DeBaschdi/EPGScripts/master/imdbmapper/Readme > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/Readme
							curl -s https://raw.githubusercontent.com/DeBaschdi/EPGScripts/master/imdbmapper/age.php > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/age.php
							curl -s https://raw.githubusercontent.com/DeBaschdi/EPGScripts/master/imdbmapper/country.php > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/country.php
							curl -s https://raw.githubusercontent.com/DeBaschdi/EPGScripts/master/imdbmapper/imdb.class.php > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/imdb.class.php
							curl -s https://raw.githubusercontent.com/DeBaschdi/EPGScripts/master/imdbmapper/imdbmapper.pl > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/imdbmapper.pl
							curl -s https://raw.githubusercontent.com/DeBaschdi/EPGScripts/master/imdbmapper/poster.php > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/poster.php
							curl -s https://raw.githubusercontent.com/DeBaschdi/EPGScripts/master/imdbmapper/rating.php > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/imdbmapper.php
							curl -s https://raw.githubusercontent.com/DeBaschdi/EPGScripts/master/imdbmapper/url.php > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/url.php
							curl -s https://raw.githubusercontent.com/DeBaschdi/EPGScripts/master/imdbmapper/year.php > combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/year.php
							
							sed -i "17s/\/my\/path\/to\/php\/helperscripts/combine\/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/g" combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/imdbmapper.pl
							dialog --backtitle "[M1322] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > ADDONS" --title "ADDON SETUP" --msgbox "Addon IMDB MAPPER added!" 5 35
						fi
					fi
				done
				echo "B" > /tmp/value
			elif grep -q "3" /tmp/setupvalue
			then
				# #####################
				# M1323 SHELL SCRIPT  #
				# #####################
				
				nano combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)/setup.sh
				echo "B" > /tmp/value
			elif grep -q "4" /tmp/setupvalue
			then
				# ####################
				# M1324 REMOVE SETUP #
				# ####################
				
				dialog --backtitle "[M1324] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > REMOVE" --title "REMOVE SETUP" --yesno "Are you sure to delete this setup?" 5 40
				
				response=$?
					
				if [ $response = 1 ]
				then
					echo "B" > /tmp/value
				elif [ $response = 0 ]
				then
					rm -rf combine/$(sed -n "$(</tmp/selectedsetup)p" /tmp/combine)
					dialog --backtitle "[M1325] EASYEPG SIMPLE XMLTV GRABBER > XML FILE CREATION > REMOVE" --title "REMOVE SETUP" --msgbox "Setup successfully deleted!" 5 40
					echo "C" > /tmp/value
				else
					echo "B" > /tmp/value
				fi
			else
				echo "C" > /tmp/value
			fi
		done
	else
		echo "C" > /tmp/value
	fi
fi
