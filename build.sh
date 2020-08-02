# note: asm6f must be on the PATH.
bases=(base.nes base-bisqwit.nes)
configs=(STANDARD BISQWIT)
outs=(standard bisqwit)
folders=("standard/" "bisqwit/")

export="cv2-controls"

if [ -d "$export" ]
then
    rm -r $export
fi
mkdir $export
cp included-readme.txt $export/README.txt

if [ ! -d "nes" ]
then
    mkdir "nes"
fi

for i in {0..1}
do
    BASE="${bases[$i]}"
    CONFIG="${configs[$i]}"
    SRC="patch.asm"
    TAG="${outs[$i]}"
    if [ $TAG != "standard" ]
    then
        OUT="cv2-controls-$TAG"
    else
        OUT="cv2-controls"
    fi
    folder="${folders[$i]}"
    
    if [ ! -f "$BASE" ]
    then
        echo "Base ROM $BASE not found -- skipping."
        continue
    fi
    
    echo
    echo "Producing hacks for $BASE"
    
    mkdir "$export/$folder"
        
    outfile="$OUT"
    
    echo "------------------------------------------"
    echo "generating patch ($outfile) from $BASE"
    chmod a-w "$BASE"
    echo "INCNES \"$BASE\"" > inc-base.asm
    which asm6f > /dev/null
    if [ $? != 0 ]
    then
        echo "asm6f is not on the PATH."
        continue
    fi
    printf 'base size 0x%x\n' `stat --printf="%s" "$BASE"`
    asm6f -c -n -i "-d$CONFIG" "-dUSEBASE" "$SRC" "$outfile.nes"
    
    if [ $? != 0 ]
    then
        exit
    fi
    
    printf 'out size 0x%x\n' `stat --printf="%s" "$outfile.nes"`
    
    if [ $? != 0 ]
    then
        continue
    fi
    
    #continue
    if ! [ -f "$outfile.ips" ]
    then
        echo
        echo "Failed to create $outfile.ips"
        continue
    fi
    echo
    
    # apply ips patch
    chmod a+x flips/flips-linux
    
    if [ -f patch.nes ]
    then
      rm patch.nes
    fi
    
    flips/flips-linux --apply "$outfile.ips" "$BASE" patch.nes
    if ! [ -f "patch.nes" ]
    then
        echo "Failed to apply patch $i."
        continue
    fi
    echo "patch generated."
    md5sum "$outfile.nes"
    
    cmp "$outfile.nes" patch.nes
    if [ $? != 0 ]
    then
        continue
    fi
    
    mv "$outfile.nes" nes/
    
    if [ -f patch.nes ]
    then
      rm patch.nes
    fi
    
    mv $outfile.ips "$export/$folder/"
done

echo "============================================"
echo "Assembling export."

if [ -f CV2-controls.zip ]
then
  rm cv2-controls.zip 2>&1
fi
zip -r cv2-controls.zip $export/*