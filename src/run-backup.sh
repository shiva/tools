#!/usr/bin/env bash

usage="$(basename "$0") [-h] [-p 1p1|1p2|1p5|all] [-d <backup dir>]"
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
        -d|--directory)
            bdir="$2"
            shift # past argument
            shift # past value
            ;;
        -h|--help)
            echo $usage
            exit
            ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 "$1"
fi

backup_phone() {
    rsync -ravzc --progress --exclude '*cache*' $1:~/SDCard/* $2/
}

echo "bdir=" $bdir
echo "phone=" $phone

case $phone in
    all)
        backup_phone "1p1" "${bdir}/oneplusone"
        backup_phone "1p2" "${bdir}/oneplustwo"
        backup_phone "1p5" "${bdir}/oneplusfive"
        ;;
    1p1)
        backup_phone "1p1" "${bdir}/oneplusone"
        ;;
    1p2)
        backup_phone "1p2" "${bdir}/oneplustwo"
        ;;
    1p5)
        backup_phone "1p5" "${bdir}/oneplusfive"
        ;;
esac

