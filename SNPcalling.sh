#!/bin/bash


WGC=false
WGE=false
WITHCTRL=false

while [ "`echo $1 | cut -c1`" = "-" ]
do
    case "$1" in
        -Out) OUT=$2
        	shift 2;;
		
        -Ref) REFERENCE=$2
        	shift 2;;
	-Exp) EXP=$2
		EXPPATH=${EXP%/*}
		[ "$EXPPATH" != "$EXP" ] && TMP="${EXP:${#EXPPATH}}"
		EXPNAME=${TMP%.*}
        	shift 2;;
	-Ctrl) CTRL=$2
		WITHCTRL=true
		CTRLPATH=${CTRL%/*}
		[ "$CTRLPATH" != "$CTRL" ] && T="${CTRL:${#CTRLPATH}}"
		CTRLNAME=${T%.*}
              	shift 2;;
	-Peaks) PEAKS=$2
              	shift 2;;
	-VCF) VCF=$2
              	shift 2;;
	-WGE) WGE=true
		shift 1;;
	-WGC) WGC=true
		shift 1;;
        *)
                echo "There is no option $1"
		break
            ;;
	esac
done

FA=$REFERENCE/"genome-norm.fasta"
FD=$REFERENCE/"genome-norm.dict"

bash pre-process.sh $EXPNAME \
	$EXPPATH \
	$PEAKS \
	$OUT \
	$VCF \
	$FA \
	$FD \
	$WGE

if [ $? != 0 ]; then
    echo "Failed to pre-process exp"
    exit 1
fi
if [$WITHCTRL]; then
	bash pre-process.sh $CTRLNAME \
		$CTRLPATH \
		$PEAKS \
		$OUT \
		$VCF \
		$FA \
		$FD \
		$WGC

		if [ $? != 0 ]; then
    			echo "Failed to pre-process ctrl"
    			exit 1
		fi

	bash make_tables.sh $EXPNAME $CTRLNAME \
		"$OUT/$EXPNAME.vcf" \
		"$OUT/${CTRLNAME}.vcf" \
		$OUT \
		$FA
	

	if [ $? != 0 ]; then
    		echo "Failed to make tables"
    		exit 1
	fi
else
	python3 make_table_no_ctrl.py "$OUT/${EXPNAME}.vcf" "%OUT/${EXPNAME}_table.txt"
	
	if [ $? != 0 ]; then
    		echo "Failed to make tables"
    		exit 1
	fi
fi
rm "$OUT/${EXPNAME}_final.bam"
rm "$OUT/${CTRLNAME}_final.bam"
rm "$OUT/${EXPNAME}_final.bai"
rm "$OUT/${CTRLNAME}_final.bai"

exit 0
