#!/bin/bash  

# 20150527 - Altered processmail.sh script to only process files in TMPPROCDIR

# TMPPROCDIR tmp dir for processing new attachments
# MEDIA      destination dir for media files
# MEDIAMETA  meta-data file for media
# MAXPCTUSG  maximum allow percentage of diskspace

TMPPROCDIR=/home/pi/localmediatmp
MEDIA=/home/pi/pp_home/media
MEDIAMETA=/home/pi/pp_home/media-metadata
MAXPCTUSG=95
APPLEMOVEXT="*mov*"
IMGLIST="*jpg*jpeg*png*"

# assure minimal free disk space
cp --force ${MEDIAMETA} ${MEDIAMETA}.TMP

	while [ ${MAXPCTUSG} -lt $(df -h  ${MEDIA} | awk '{ print $5 }' | tail -1 | cut -d'%' -f1) ]
	do
	  removefile=$(ls -1 ${MEDIA} | sort | head -1)
	  if [ ! -z "${removefile}" ] ;
	  then 
		rm "${MEDIA}/$removefile"
		cat ${MEDIAMETA}.TMP | grep -v "$removefile" > ${MEDIAMETA}.TMP
	  fi
	done

cp --force ${MEDIAMETA}.TMP ${MEDIAMETA}

# log status
status=`date +"%F at %T"`

echo $status > /var/tmp/processmedia.sts

# if e-mail retrieved successfully
cp --force ${MEDIAMETA} ${MEDIAMETA}.TMP

imgcount=0

	if [ $? -eq 0 -a ! -z "$(ls -A $TMPPROCDIR)" ] ;
	then
	# process all attachments, move all attachments to livetracks dir with timestamp filename 
		for attach in ${TMPPROCDIR}/*
		do
		imgcount=$(($imgcount + 1))
		
		filename="${attach##*/}"
		filename="${filename%.*}"
		filename=${filename// /_}
		echo $filename > /var/tmp/processmedia.sts
		
		extension="${attach##*.}"
			# change extension of .mov files to .mp4
			if  echo $APPLEMOVEXT | grep -iq $extension ; then extension="mp4" ; fi
		medianame=$filename"-"$(date +%s-%N).${extension}

		#medianame=$(date +%Y%m%d%H%M%S-%N).${extension}

			# fix orientation for images sent by smartphones
			if echo $IMGLIST | grep -iq $extension ;
			then
			convert -auto-orient "${attach}" "${MEDIA}/${medianame}"
			rm -f "${attach}"
			else
			mv "${attach}" "${MEDIA}/${medianame}"
			fi

		echo ${medianame} ${shortmessage} >> ${MEDIAMETA}.TMP
		done

	rm -f $file
	fi

  status="${status} success ${imgcount} new images retrieved"

  cp --force ${MEDIAMETA}.TMP ${MEDIAMETA}
  	
  	if [ $imgcount -gt 0 ] ;
  	then
  	/home/pi/processmail/rebuild_media.sh
  	sudo /etc/init.d/lightdm restart
  	fi
  	
echo $status > /var/tmp/processmedia.sts

