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

