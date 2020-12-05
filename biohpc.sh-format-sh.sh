# inputs
bashscript_in=$1
bashscript_out=$2

# arg checks
if [[ \
      $bashscript_in = '' || $bashscript_in = '--help' \
    ]];
then
    echo 'usage:' 
    echo '	biohpc.sh-format.sh <bashscript_in> <bashscript_out>'
    echo ''
    echo 'args:'
    echo '	<bashscript_in>    path to bashscript on biohc to be sanitize'
    echo '	                   default: none, user is required to supply this'
    echo '	<bashscript_out>   path to write out to'
    echo '	                   default: appends biohpc- as prefix to bashscript_in'
    echo ''
    echo 'example: minimam'
    echo '	bashscript_in=tag-docker.io.sh'
    echo '	. tag-docker.io.sh $bashscript_in'
    return 1
fi

bashscript_in_full=$(readlink --canonicalize $bashscript_in)
bashscript_in_base=$(basename $bashscript_in_full)
bashscript_in_dir=$(dirname $bashscript_in_full)

# set default if bashscript_out not provided
if [[ $bashscript_out = '' ]];
then
    bashscript_out=./biohpc.sh-$bashscript_in_base
fi

# docstring
printf "\
call biohpc.sh-format-sh
\t%-20s:%-40s \n\
\t%-20s:%s \n\
" \
bashscript_in $bashscript_in \
bashscript_out $bashscript_out

# body
cat $bashscript_in \
    | sed -E 's/sudo docker /docker /g' \
    | sed -E 's/docker image /docker /g' \
    | sed -E 's/docker /docker1 /g' \
    | sed -E 's/--tag/-t/g' \
	  > $bashscript_out
