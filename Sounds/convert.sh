#!/bin/sh

#Remove whitespace from filenames
find . -type f -name "* *" -exec bash -c 'mv "$0" "${0// /_}"' {} \;

#Convert audio files to .ogg format
converter(){
    for f in $(find $PWD -name '*.mp3' -or -name '*.aac' -or -name '*.flac' -or -name '*.wav')
    do
        if test -f "$f" 
        then
            ffmpeg -i "$f" -acodec libvorbis "${f%.*}.ogg"
            if test -f "${f%.*}.ogg"
            then
                rm "$f"
            else
                echo "$f failed to convert to ${f%.*}.ogg" >> $PWD/log
            fi
            
        fi
    done
}

#Normalize audio as .aac format
normalizer(){
    for f in $(find $PWD -name '*.ogg')
    do
        if test -f "$f"
        then
            ffmpeg-normalize "$f" -o "${f%.*}.aac" -c:a aac -b:a 192k
            if test -f "${f%.*}.aac"
            then
                rm "$f"
            else
                echo "$f failed to normalize and convert to ${f%.*}.aac" >> $PWD/log
            fi
        fi
    done
}

converter
normalizer
converter
