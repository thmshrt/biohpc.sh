tag=$1

# arg checks
if [[ \
      $tag = '' || $tag = '--help' \
    ]];
then
    echo 'usage:' 
    echo '	tag-for-docker.io <tag>'
    echo ''
    echo 'args:'
    echo '	<tag>        is the name of the tag to retag'
    echo '	             default: none, user is required to supply this'
    echo ''
    echo 'example:'
    echo '	tag=editors:latest'
    echo '	. tag-for-docker.io.sh $tag'
    return 1
fi

newtag=docker.io/$(basename $tag)

printf \ "\
tag-for-docker.io.sh: \n\
\t%-15s:%30s\n\
\t%-15s:%30s\n" \
       tag $tag \
       newtag $newtag

sudo docker image tag \
     $tag \
     $newtag

# # example: minimum behavior
# tag=thmshrt/editors
# . build-for-user.sh $tag
