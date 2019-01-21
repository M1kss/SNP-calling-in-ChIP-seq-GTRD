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

while [ "`echo $1 | cut -c1`" = "-" ]
do
    case "$1" in
	-Table) table=$2
		TABLEPATH=${table%/*}
		TABLENAME=$(GETNAME $table)
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

        *)
                echo "There is no option $1"
		break
            ;;
	esac
done
if $withmacs||$withsissrs||$withcpics||$withgem; then
	python3 Annotate.py $table $macs $sissrs $cpics $gem $withmacs $withsissrs $withcpics $withgem "$TABLEPATH/${TABLENAME}_annotated.txt"
	rm $table

else
	echo "There is no any caller data"
fi

exit 0

