#!/bin/bash

while [ "`echo $1 | cut -c1`" = "-" ]
do
    case "$1" in
        -RefFolder) OUT=$2
        	shift 2;;

	    -RefGenome) REF=$2
        	shift 2;;
        *)
                echo "There is no option $1"
                exit 1
		break
            ;;
	esac
done

source ./Config.cfg

java $JavaParameters -jar $PICARD \
	NormalizeFasta \
	I=$REF \
	O="$OUT/genome-norm.fasta"

if [ $? != 0 ]; then
    echo "Failed to normalize fasta"
    exit 1
fi

samtools faidx "$OUT/genome-norm.fasta"

if [ $? != 0 ]; then
    echo "Failed to index fasta"
    exit 1
fi

java $JavaParameters -jar $PICARD \
	CreateSequenceDictionary \
	R="$OUT/genome-norm.fasta"\
	O="$OUT/genome-norm.dict"

if [ $? != 0 ]; then
    echo "Failed to create sequence dictionary"
    exit 1
fi
