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

if [ $? != 0 ]; then
    echo "Failed to convert macs peaks"
    exit 1
fi

python3 IntervalsToBed.py $sissrs "sissrs" $NAMES $OUT

if [ $? != 0 ]; then
    echo "Failed to convert sissrs peaks"
    exit 1
fi

python3 IntervalsToBed.py $gem "gem" $NAMEG $OUT

if [ $? != 0 ]; then
    echo "Failed to convert gem peaks"
    exit 1
fi

python3 IntervalsToBed.py $cpics "cpics" $NAMEC $OUT

if [ $? != 0 ]; then
    echo "Failed to convert cpics peaks"
    exit 1
fi

cat $OUT/$NAMEC".cpics.bed" $OUT/$NAMEG".gem.bed" $OUT/$NAMES".sissrs.bed" $OUT/$NAMEM".macs.bed" > $OUTFILE".unmerged.bed"

rm $OUT/$NAMEC".cpics.bed" $OUT/$NAMEG".gem.bed" $OUT/$NAMES".sissrs.bed" $OUT/$NAMEM".macs.bed"

if [ $? != 0 ]; then
    echo "Failed to cat peaks"
    exit 1
fi

bedtools sort -i $OUTFILE".unmerged.bed" > $OUTFILE".unmerged.sorted.bed"

if [ $? != 0 ]; then
    echo "Failed to bedtools.sort peaks"
    exit 1
fi

rm $OUTFILE".unmerged.bed"

bedtools merge -i $OUTFILE".unmerged.sorted.bed" > $OUTFILE".bed"

if [ $? != 0 ]; then
    echo "Failed to bedtools.merge peaks"
    exit 1
fi

rm $OUTFILE".unmerged.sorted.bed"

exit 0