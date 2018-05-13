if [ $# = 0 ]; then
   echo Usage: backup files
   exit 1
fi
FILE=$1
if [[ ! "$FILE" =~ ^/ ]]; then
   FILE=`pwd`/$FILE
fi
if [ ! -e $FILE ]; then
   echo An error occurred. $FILE does not exist.
   exit 1
fi

if [ ! -e ~/.backup ]; then
    mkdir ~/.backup
fi
cd ~/.backup
SPLIT=`echo $FILE | tr '/' ' '`
DIR=(`echo $SPLIT`)
for ((i=0; i<${#DIR[@]}-1; i++)) {
   if [ ! -e ${DIR[$i]} ]; then
      mkdir ${DIR[$i]}
   fi
   cd ${DIR[$i]}
}
DATE=`date '+%Y%m%d_%H%M%S'`
cp $FILE ~/.backup${FILE}_${DATE}
ls
