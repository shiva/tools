# recursive git commands

rgit() {
  for f in $(find . -maxdepth 2 -mindepth 1  -type d -name .git | awk -F"/.git$" '{print $1}');  do
    echo
    echo "......(cd $f && git $*)....."
    echo
    (cd $f && git $*)
  done
}

