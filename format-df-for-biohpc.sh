# inputs
dockerfile_in=$1
dockerfile_out=$2

# param checks
if [[ $dockerfile_in = '' ]];
then
    echo param dockerfile_in must not be empty
    exit
fi

# set dockerfile_out if non provided
if [[ $dockerfile_out = '' ]];
then
    dockerfile_out=biohpc-$dockerfile_in
fi

# docstring
echo -e \
    "converting $dockerfile_in to biohpc valid dockerfile\n \
     and writing converted file out to $dockerfile_out"

# body
cat $dockerfile_in \
    | sed -r "s/FROM ([[:graph:]]*)/FROM biohpc_$USER\/\1/" \
    > $dockerfile_out
