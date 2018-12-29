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
		break
            ;;
	esac
done

source ./Config.cfg

java $JavaParameters -jar $PICARD \
	NormalizeFasta \
	I=REF \
	O="$OUT/genome-norm.fasta"

samtools faidx "$OUT/genome-norm.fasta"

java $JavaParameters -jar $PICARD \
	CreateSequenceDictionary \
	R="$OUT/genome-norm.fasta"\
	O="$OUT/genome-norm.dict"