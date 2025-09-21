#!/usr/bin/env bash

usage () {
    cat<<HELP
Usage: $(basename "$0") [OPTION]... [FILE PATTERN]...
Backup android phones.

  -d,--dest-directory    Base destination directory for backup. Defaults to "."
  -p,--phone             Select Phone 1p1, 1p2, 1p5, all. Default to "all"
  -h,--help              Displays this help

If a set of file patterns are specified only those will be synced over to the 
destination directory in the specified sequence. If not pattern is specified all
the files in /sdcard will be backed up.

HELP
}

POSITIONAL=()
bdir="."
phone="all"

while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -p|--phone)
            phone="$2"
            shift # past argument
            shift # past value
            ;;
        -d|--dest-directory)
            bdir="$2"
            shift # past argument
            shift # past value
            ;;
        -h|--help)
            usage
            exit
            ;;
        *)    # unknown option
            POSITIONAL+=("$1") # save it in an array for later
            shift # past argument
            ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

#if [[ -n $1 ]]; then
#    echo "Last line of file specified as non-opt/last argument:"
#    tail -1 "$1"
#fi

backup_phone() {
    #rsync -ravzc --progress --exclude '*cache*' $1:/sdcard/DCIM* $2/
    for var in "$2[@]"
    do 
        echo $var
    done
}

echo "bdir=" $bdir
echo "phone=" $phone
echo "positional=" ${POSITIONAL[@]}

case $phone in
    all)
        backup_phone "1p1" "${bdir}/oneplusone" "${POSITIONAL[@]}"
        backup_phone "1p2" "${bdir}/oneplustwo" "${POSITIONAL[@]}"
        backup_phone "1p5" "${bdir}/oneplusfive" "${POSITIONAL[@]}"
        backup_phone "christina-phone" "${bdir}/christina-phone" "${POSITIONAL[@]}"
        ;;
    1p1)
        backup_phone "1p1" "${bdir}/oneplusone" "${POSITIONAL[@]}"
        ;;
    1p2)
        backup_phone "1p2" "${bdir}/oneplustwo" "${POSITIONAL[@]}"
        ;;
    1p5)
        backup_phone "1p5" "${bdir}/oneplusfive" "${POSITIONAL[@]}"
        ;;
    christina-phone)
        backup_phone "1p5" "${bdir}/christina-phone" "${POSITIONAL[@]}"
        ;;
esac

