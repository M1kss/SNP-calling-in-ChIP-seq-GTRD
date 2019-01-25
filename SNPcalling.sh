#!/bin/bash
source ./Config.cfg
GETNAME(){
	local var=$1
	local varpath=${var%/*}
	[ "$varpath" != "$var" ] && local vartmp="${var:${#varpath}}"
		echo ${vartmp%.*}
}

WGC=false
WGE=false
WITHCTRL=false
withmacs=false
withsissrs=false
withcpics=false
withgem=false
macs=-1
sissrs=-1
cpics=-1
gem=-1


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
	-macs) withmacs=true
		macs=$2
		NAMEM=$(GETNAME $macs)
        	shift 2;;

	-sissrs) withsissrs=true
		sissrs=$2
		NAMES=$( GETNAME $sissrs)
        	shift 2;;

	-cpics) withcpics=true
		cpics=$2
		NAMEC=$( GETNAME $cpics)
              	shift 2;;

	-gem) withgem=true
		gem=$2
		NAMEG=$( GETNAME $gem)
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
	$OUT \
	$VCF \
	$FA \
	$FD \
	$WGE

if [ $? != 0 ]; then
    echo "Failed to pre-process exp"
    exit 1
fi

if $WITHCTRL; then
	bash pre-process.sh $CTRLNAME \
		$CTRLPATH \
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
	$python3 Make_tables_no_ctrl.py "$OUT/${EXPNAME}.vcf" "$OUT/${EXPNAME}_table.txt"
	
	if [ $? != 0 ]; then
    		echo "Failed to make tables"
    		exit 1
	fi
fi

bam_size=0

bam_size=$(($bam_size+$(wc -c <"$OUT/${EXPNAME}_formated.bam")))
bam_size=$(($bam_size+$(wc -c <"$OUT/${EXPNAME}_ready.bam")))
bam_size=$(($bam_size+$(wc -c <"$OUT/${EXPNAME}_chop.bam")))
bam_size=$(($bam_size+$(wc -c <"$OUT/${EXPNAME}_final.bam")))

rm "$OUT/${EXPNAME}_final.bam"
rm "$OUT/${EXPNAME}_final.bai"
rm "$OUT/${EXPNAME}_chop.bam"
rm "$OUT/${EXPNAME}_ready.bam"
rm "$OUT/${EXPNAME}_formated.bam"

if $WITHCTRL; then
    bam_size=$(($bam_size+$(wc -c <"$OUT/${CTRLNAME}_formated.bam")))
    bam_size=$(($bam_size+$(wc -c <"$OUT/${CTRLNAME}_ready.bam")))
    bam_size=$(($bam_size+$(wc -c <"$OUT/${CTRLNAME}_chop.bam")))
    bam_size=$(($bam_size+$(wc -c <"$OUT/${CTRLNAME}_final.bam")))

	rm "$OUT/${CTRLNAME}_final.bam"
	rm "$OUT/${CTRLNAME}_final.bai"
	rm "$OUT/${CTRLNAME}_chop.bam"
	rm "$OUT/${CTRLNAME}_ready.bam"
	rm "$OUT/${CTRLNAME}_formated.bam"
fi

echo "Total intermediate .bam size: $bam_size"



$python3 Annotate.py "$OUT/${EXPNAME}_table.txt" $macs $sissrs $cpics $gem $withmacs $withsissrs $withcpics $withgem "$OUT/${EXPNAME}_table_annotated.txt"

rm "$OUT/${EXPNAME}_table.txt"
rm "$TABLEPATH/${TABLENAME}_table_annotated.txt.m.txt"
rm "$TABLEPATH/${TABLENAME}_table_annotated.txt.c.txt"
rm "$TABLEPATH/${TABLENAME}_table_annotated.txt.s.txt"

exit 0

