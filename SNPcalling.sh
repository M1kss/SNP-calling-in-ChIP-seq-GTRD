#!/bin/bash

WG=0
while [ "`echo $1 | cut -c1`" = "-" ]
do
    case "$1" in
        -Out) OUT=$2
        	shift 2;;
		echo "$Out"
        -Ref) REFERENCE=$2
        	shift 2;;
	-Exp) EXP=$2
		EXPPATH=${EXP%/*}
		[ "$EXPPATH" != "$EXP" ] && TMP="${EXP:${#EXPPATH}}"
		EXPNAME=${TMP%.*}
		echo "$EXPPATH"
        	shift 2;;
	-Ctrl) CTRL=$2
		CTRLPATH=${CTRL%/*}
		[ "$CTRLPATH" != "$CTRL" ] && TMP="${CTRL:${#CTRLPATH}}"
		CTRLNAME=${TMP%.*}
              	shift 2;;
	-Peaks) PEAKS=$2
              	shift 2;;
	-VCF) VCF=$2
              	shift 2;;
	-WG) WG=1
		shift 1;;
        *)
                echo "There is no option $1"
		break
            ;;
	esac
done

FA=REFERENCE/"hg38-norm.fasta"
FD=REFERENCE/"hg38-norm.dict"

bash pre-process.sh $EXPNAME \
	$EXPPATH\
	$PEAKS \
	$OUT \
	$VCF \
	$FA \
	$FD \
	0
wait

bash pre-process.sh $CTRLNAME \
	$CTRLPATH
	$PEAKS \
	$OUT \
	$REFERENCE \
	$VCF \
	$FA \
	$FD \
	$WG

wait

bash make_tables.sh $BAMNAME $CTRLNAME \
	"$OUT/$BAMNAME.vcf" \
	"$OUT/${CTRLNAME}.vcf" \
	$OUT \
	$REFERENCE \
	$FA

exit 0
