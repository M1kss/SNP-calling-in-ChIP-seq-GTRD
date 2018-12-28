while [ "`echo $1 | cut -c1`" = "-" ]
do
    case "$1" in
        -Out) OUT=$2
        	shift 2;;
		
        -macs) macs=$2
		macsPATH=${macs%/*}
		[ "$macsPATH" != "$macs" ] && T="${macs:${#macsPATH}}"
		NAME=${T%.*}
        	shift 2;;

	-sissrs) sissrs=$2
        	shift 2;;

	-cpics) cpics=$2
              	shift 2;;

	-gem) gem=$2
              	shift 2;;

        *)
                echo "There is no option $1"
		break
            ;;
	esac
done


python3 IntervalsToBed.py $macs "macs" $NAME $OUT
python3 IntervalsToBed.py $sissrs "sissrs" $NAME $OUT
python3 IntervalsToBed.py $gem "gem" $NAME $OUT
python3 IntervalsToBed.py $cpics "cpics" $NAME $OUT

cat $OUT/$NAME".cpics.bed" $OUT/$NAME".gem.bed" $OUT/$NAME".sissrs.bed" $OUT/$NAME".macs.bed" > $OUT/$NAME".unmerged.bed"

rm $OUT/$NAME".cpics.bed" $OUT/$NAME".gem.bed" $OUT/$NAME".sissrs.bed" $OUT/$NAME".macs.bed"

bedtools sort -i $OUT/$NAME".unmerged.bed" > $OUT/$NAME".unmerged.sorted.bed"

rm $OUT/$NAME".unmerged.bed"

bedtools merge -i $OUT/$NAME".unmerged.sorted.bed" > $OUT/$NAME".bed"

rm $OUT/$NAME".unmerged.sorted.bed"
