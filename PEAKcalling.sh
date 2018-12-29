GETNAME(){
local var=$1
local varpath=${var%/*}
[ "$varpath" != "$var" ] && local vartmp="${var:${#varpath}}"
echo ${vartmp%.*}
}

while [ "`echo $1 | cut -c1`" = "-" ]
do
    case "$1" in
        -Out) OUTFILE=$2
		OUT=${OUTFILE%/*}
        	shift 2;;
		
        -macs) macs=$2
		NAMEM=$( GETNAME $macs)
        	shift 2;;

	-sissrs) sissrs=$2
		NAMES=$( GETNAME $sissrs)
        	shift 2;;

	-cpics) cpics=$2
		NAMEC=$( GETNAME $cpics)
              	shift 2;;

	-gem) gem=$2
		NAMEG=$( GETNAME $gem)
              	shift 2;;

        *)
                echo "There is no option $1"
		break
            ;;
	esac
done


python3 IntervalsToBed.py $macs "macs" $NAMEM $OUT
python3 IntervalsToBed.py $sissrs "sissrs" $NAMES $OUT
python3 IntervalsToBed.py $gem "gem" $NAMEG $OUT
python3 IntervalsToBed.py $cpics "cpics" $NAMEC $OUT

cat $OUT/$NAMEC".cpics.bed" $OUT/$NAMEG".gem.bed" $OUT/$NAMES".sissrs.bed" $OUT/$NAMEM".macs.bed" > $OUTFILE".unmerged.bed"

rm $OUT/$NAMEC".cpics.bed" $OUT/$NAMEG".gem.bed" $OUT/$NAMES".sissrs.bed" $OUT/$NAMEM".macs.bed"

bedtools sort -i $OUTFILE".unmerged.bed" > $OUTFILE".unmerged.sorted.bed"

rm $OUTFILE".unmerged.bed"

bedtools merge -i $OUTFILE".unmerged.sorted.bed" > $OUTFILE".bed"

rm $OUTFILE".unmerged.sorted.bed"
