# inputs
bashscript_in=$1
bashscript_out=$2

# param checks
if [[ $bashscript_in = '' ]];
then
    echo param bashscript_in must not be empty
    exit
fi

# set default if bashscript_out not provided
if [[ $bashscript_out = '' ]];
then
    bashscript_out=biohpc-$bashscript_in
fi


# docstring
echo -e \
    "converting $dockefile_in to biohpc valid bashscript\n \
     and writing converted file out to $bashscript_out"

# body
cat $bashscript_in \
    | sed -E 's/sudo docker /docker /g' \
    | sed -E 's/docker image /docker /g' \
    | sed -E 's/docker /docker1 /g' \
    | sed -E 's/--tag/-t/g' \
    > $bashscript_out
