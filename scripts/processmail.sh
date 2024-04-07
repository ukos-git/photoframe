#!/bin/bash

set -e

# NEWMAILDIR received new maildir
# TMPPROCDIR tmp dir for processing new attachments
# MEDIA      destination dir for media files
# MEDIAMETA  meta-data file for media
# MAXPCTUSG  maximum allow percentage of diskspace

NEWMAILDIR=/home/pi/mail.mbox/new
TMPPROCDIR=/home/pi/app/temp
MEDIA=/home/pi/app/photoframe/media
MEDIAMETA=/home/pi/app/photoframe/media/meta.yml
STATUSFILE=/home/pi/app/processmail.sts
MAXPCTUSG=95
APPLEMOVEXT="*mov*"
IMGLIST="*jpg*jpeg*png*"

LC_CTYPE="POSIX"

# create files/folders if not exists
if [ ! -e ${MEDIAMETA} ]; then
  touch ${MEDIAMETA}
fi
if [ ! -e ${TMPPROCDIR} ]; then
  mkdir -p ${TMPPROCDIR}
fi

# log status
status=`date +"%F at %T"`

# retrieve new mail
getmailresult=$(getmail --delete --all  2>&1 >/dev/null)
gmresult=$?

# if e-mail retrieved successfully
if [ $gmresult -eq 0 -a ! -z "$(ls -A ${NEWMAILDIR})" ] ;
then
  imgcount=0
  # for each new received e-mail
  for file in ${NEWMAILDIR}/*
  do
    # extract short message
    shortmessage=`mu view "${file}" | grep "^Subject" | sed 's/Subject: \(.*\)$/\1/'`
    # Escape double quotes
    shortmessage="${shortmessage//\"/\\\"}"
    echo "Subject: $shortmessage" >&2
    # extract supported attachments
    if mu extract --overwrite --save-attachments --target-dir=${TMPPROCDIR} "${file}"
    then
      # process all attachments, move all attachments to livetracks dir with timestamp filename 
      for attach in $(find "$TMPPROCDIR" -type f -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.mov' -o -iname '*.mp4')
      do
        imgcount=$(($imgcount + 1))
        extension="${attach##*.}"
        # change extension of .mov files to .mp4
        if  echo $APPLEMOVEXT | grep -iq $extension ; then extension="mp4" ; fi
        medianame=$(date +%Y%m%d%H%M%S-%N).${extension}
        # fix orientation for images sent by smartphones
        if echo $IMGLIST | grep -iq $extension ;
        then
        	convert -auto-orient "${attach}" "${MEDIA}/${medianame}"
        	rm -f "${attach}"
        else
            mv "${attach}" "${MEDIA}/${medianame}"
        fi
        echo "${medianame}: \"${shortmessage}\"" >> ${MEDIAMETA}
      done
      rm -f "${file}"
     fi
  done

  status="${status} success ${imgcount} new images retrieved"

  if [ $imgcount -gt 0 ] ;
  then
    sudo systemctl restart lightdm.service
  fi
else
  if [ $gmresult -eq 0 ] ;
  then
    status="${status} success (no new mail)"
  else
    status="${status} failed ($getmailresult)"
  fi
fi

echo $status > $STATUSFILE
