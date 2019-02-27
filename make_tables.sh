#!/bin/bash
source ./Config.cfg

GETNAME(){
	local var=$1
	local varpath=${var%/*}
	[ "$varpath" != "$var" ] && local vartmp="${var:${#varpath}}"
		echo ${vartmp%.*}
}

withmacs=false
withsissrs=false
withcpics=false
withgem=false
macs=-1
sissrs=-1
cpics=-1
gem=-1
VCFctrl=-1

while [ "`echo $1 | cut -c1`" = "-" ]
do
    case "$1" in
	-Out) OUT=$2
		shift 2;;

	-Ref) REFERENCE=$2
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

	-VCFexp) VCFexp=$2
		EXPNAME=$( GETNAME $VCFexp )
		shift 2;;

	-VCFctrl) VCFctrl=$2
		shift 2;;

	*)
		echo "There is no option $1"
		break;;

    esac
done


FA=$REFERENCE/"genome-norm.fasta"
FD=$REFERENCE/"genome-norm.dict"

if [ $VCFctrl != -1 ]; then

	$python3 make_table_single.py $VCFexp $VCFctrl "$OUT${EXPNAME}_table_11.txt" "$OUT${EXPNAME}_table_01.txt" "$OUT${EXPNAME}_table_10.txt"

	if [ $? != 0 ]; then
		echo "Failed to make table from vcf"
			exit 1
	fi

	cat "$OUT${EXPNAME}_table_01.txt" "$OUT${EXPNAME}_table_10.txt" "$OUT${EXPNAME}_table_11.txt" | bedtools sort -i > "$OUT${EXPNAME}_table_pre.txt"

	if [ $? != 0 ]; then
		echo "Failed to merge tables"
		exit 1
	fi

	$python3 collect_table.py "$OUT${EXPNAME}_table_pre.txt" "$OUT${EXPNAME}_table.txt"

	if [ $? != 0 ]; then
		echo "Failed to filter homozigous SNPs"
		exit 1
	fi
else

	$python3 Make_tables_no_ctrl.py "$OUT${EXPNAME}.vcf" "$OUT${EXPNAME}_table.txt"

fi

if [ $withgem ]; then
	$Bedtools sort -i $gem > "$gem.sorted"
	if [ $? != 0 ]; then
		echo "Failed to sort gem peaks"
		exit 1
	fi
fi

if [ $withmacs ]; then
	$Bedtools sort -i $macs > "$macs.sorted"
	if [ $? != 0 ]; then
		echo "Failed to sort macs peaks"
		exit 1
	fi
fi

if [ $withsissrs ]; then
	$Bedtools sort -i $sissrs > "$sissrs.sorted"
	if [ $? != 0 ]; then
		echo "Failed to sort sissrs peaks"
		exit 1
	fi
fi

if [ $withcpics ]; then
	$Bedtools sort -i $cpics > "$cpics.sorted"
	if [ $? != 0 ]; then
		echo "Failed to sort cpics peaks"
		exit 1
	fi
fi

$python3 Annotate.py "$OUT${EXPNAME}_table.txt" "$macs.sorted" "$sissrs.sorted" "$cpics.sorted" "$gem.sorted" $withmacs $withsissrs $withcpics $withgem "$OUT${EXPNAME}_table_annotated.txt"

rm "$OUT${EXPNAME}_table.txt"
rm "$OUT${EXPNAME}_table_annotated.txt.m.txt"
rm "$OUT${EXPNAME}_table_annotated.txt.c.txt"
rm "$OUT${EXPNAME}_table_annotated.txt.s.txt"

if [ $withgem ]; then
	rm "$gem.sorted"
fi

if [ $withcpics ]; then
	rm "$cpics.sorted"
fi

if [ $withmacs ]; then
	rm "$macs.sorted"
fi

if [ $withsissrs ]; then
	rm "$sisrs.sorted"
fi

rm "$OUT${EXPNAME}_table_pre.txt"
rm "$OUT${EXPNAME}_table_10.txt"
rm "$OUT${EXPNAME}_table_11.txt"
rm "$OUT${EXPNAME}_table_01.txt"

exit 0
