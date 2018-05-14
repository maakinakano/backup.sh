if [ $# = 0 ]; then
   echo Compare files [date_from [date_to]]
   exit 1
fi
FILE=$1
if [[ ! "$FILE" =~ ^/ ]]; then
   FILE=`pwd`/$FILE
   fi
cd ~/.backup
SPLIT=`echo $FILE | tr '/' ' '`
DIR=(`echo $SPLIT`)
for ((i=0; i<${#DIR[@]}-1; i++)) {
   if [ ! -e ${DIR[$i]} ]; then
      echo Backup file not exist.
      exit 1
   fi
   cd ${DIR[$i]}
}

while :
do
    LS=`ls ${DIR[${#DIR[@]}-1]}*`
    BACKUPS=(`echo $LS`)
    for ((i=0; i<${#BACKUPS[@]}; i++)) {
        SPLIT=`echo ${BACKUPS[$i]} | tr '_' ' '`
        SPLIT=(`echo $SPLIT`)
        LEN=${#SPLIT[@]}
        if [ $LEN -gt 2 ]; then
        YMD=${SPLIT[LEN-2]}
        HMS=${SPLIT[LEN-1]}
        echo [$i] ${YMD:0:4}-${YMD:4:2}-${YMD:6:2} ${HMS:0:2}:${HMS:2:2}:${HMS:4:2}
        fi
    }
    read -p " > " COM ARG1 ARG2
    case "$COM" in
    "cat" )
        if [[ ! $ARG1 =~ ^[0-9]*$ ]]; then
            echo illegal argument.
        elif [ ! $ARG1 -lt ${#BACKUPS[@]} ]; then
            echo argument range is [0-$((${#BACKUPS[@]}-1))].
        else
            cat ${BACKUPS[$ARG1]}
            echo
            echo ------------------------
        fi;;
    "less" )
        if [[ ! $ARG1 =~ ^[0-9]*$ ]]; then
            echo illegal argument.
        elif [ ! $ARG1 -lt ${#BACKUPS[@]} ]; then
            echo argument range is [0-$((${#BACKUPS[@]}-1))].
        else
            less ${BACKUPS[$ARG1]}
        fi;;
    "diff" )
        if [[ ! $ARG1 =~ ^[0-9]*$ ]] || [[ ! $ARG2 =~ ^[0-9]*$ ]]; then
            echo illegal arguments.
        elif [ ! $ARG1 -lt ${#BACKUPS[@]} ] || [ ! $ARG2 -lt ${#BACKUPS[@]} ]; then
            echo argument range is [0-$((${#BACKUPS[@]}-1))].
        else
            diff -y -W 100 ${BACKUPS[$ARG1]} ${BACKUPS[$ARG2]}
            echo
            echo ------------------------
        fi;;
    "rm" )
        if [[ ! $ARG1 =~ ^[0-9]*$ ]]; then
            echo illegal argument.
        elif [ ! $ARG1 -lt ${#BACKUPS[@]} ]; then
            echo argument range is [0-$((${#BACKUPS[@]}-1))].
        else
            read -p " would you remove ${BACKUPS[$ARG1]}? [Y/n]:" YN
            case "$YN" in "Y" ) rm -fr ${BACKUPS[$ARG1]};; esac
        fi;;
    "q"|"quit"|"exit" )
        exit;;
    * )
        echo unknow command.;;
    esac
    echo
    echo
done
