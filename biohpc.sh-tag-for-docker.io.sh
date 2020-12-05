tag=$1

# arg checks
if [[ \
      $tag = '' || $tag = '--help' \
    ]];
then
    echo 'usage:' 
    echo '	biohpc.sh-tag-for-docker.io <tag>'
    echo ''
    echo 'args:'
    echo '	<tag>        is the name of the tag to retag'
    echo '	             default: none, user is required to supply this'
    echo ''
    echo 'example:'
    echo '	tag=editors:latest'
    echo '	. biohpc.sh-tag-for-docker.io.sh $tag'
    return 1
fi

newtag=docker.io/$(basename $tag)

printf \ "\
biohpc.sh-tag-for-docker.io.sh: \n\
\t%-15s:%30s\n\
\t%-15s:%30s\n" \
       tag $tag \
       newtag $newtag

docker1 tag \
     $tag \
     $newtag

# # example: minimum behavior
# tag=thmshrt/editors
# . biohpc.sh-tag-for-user.sh $tag
