while getopts “a:b:c:?” argv
do
     case $argv in
         a)
             VAR1=$OPTARG
             ;;
         b)
             VAR2=$OPTARG
             ;;
         c)
             VAR3=$OPTARG
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

echo $VAR1
echo $VAR2
echo $VAR3
