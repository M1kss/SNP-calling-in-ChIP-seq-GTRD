#!/bin/bash

source ./Config.cfg

GETNAME(){
	local var=$1
	local varpath=${var%/*}
	[ "$varpath" != "$var" ] && local vartmp="${var:${#varpath}}"
		echo ${vartmp%.*}
}

while [ "`echo $1 | cut -c1`" = "-" ]
do
    case "$1" in
	-Out) OUT=$2
		shift 2;;

	-Ref) REFERENCE=$2
		shift 2;;

	-Table) TABLE=$2
		EXPNAME=$( GETNAME $TABLE )
		shift 2;;
	-PWM) PWM=$2
		shift 2;;

	*)
		echo "There is no option $1"
		break;;

    esac
done


FA=$REFERENCE/"genome-norm.fasta"
FD=$REFERENCE/"genome-norm.dict"

$python3 extract_ape_data.py $TABLE $FA "${OUT}${EXPNAME}_ape_data.txt"

if [ $? != 0 ]; then
    echo "Failed to extract 50 adjacent nucleotides"
    exit 1
fi

$Java -cp ape.jar ru.autosome.perfectosape.SNPScan $PWM "${OUT}${EXPNAME}_ape_data.txt" -P 1 -F 1 > "${OUT}${EXPNAME}_ape.txt"

if [ $? != 0 ]; then
    echo "Failed perfectos-ape"
    exit 1
fi

$python3 adjust_table.py $TABLE "${OUT}${EXPNAME}_ape.txt" "${OUT}${EXPNAME}_table_fc.txt"

if [ $? != 0 ]; then
    echo "Failed to add fc to the table"
    exit 1
fi

rm "${OUT}${EXPNAME}_ape_data.txt"
rm "${OUT}${EXPNAME}_ape.txt"
