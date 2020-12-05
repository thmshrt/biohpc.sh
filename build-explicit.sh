tag=$1
uid=$2
gid=$3
gids=$4
group_names=$5
dockerfile=$6

# arg checks
if [[ \
      $tag = '--help' || $tag = '' \
	  || $uid = '' || $gid = '' \
	  || $gids = '' || $group_names = '' \
	  || $dockerfile = '' \
    ]];
then
    echo 'usage:' 
    echo '	build-explicit.sh <tag> <uid> <gid> <gids> <group_names> <dockerfile>'
    echo ''
    echo 'args:'
    echo '	<tag>         is the tag to give the dockerfile'
    echo '	<uid>         is value you want id --user to evaluate to'
    echo '	<gid>         is value you want id --gid to evaluate to'
    echo '	<gids>        is value you want id --groups to evaluate to'
    echo '	<group_names> is value you want id --groups --name to evaluate to'
    echo '	<dockerfile>  is the name of the dockerfile in this directory'
    echo ''
    echo 'example:'
    echo '	tag=demo_docker_args:latest;'
    echo '	uid=1001;'
    echo '	gid=1001;'
    echo '	gids=1001,1002;'
    echo '	group_names=newbuntu,new2buntu;'
    echo '	dockerfile=Dockerfile;'
    echo '	build-explicit.sh $tag $uid $gid $gids $group_names $dockerfile'
    return 1
fi

# echo
printf \ "\
build-explicit.sh: \n\
\t%-12s:%30s\n\
\t%-12s:%30s\n\
\t%-12s:%30s\n\
\t%-12s:%30s\n\
\t%-12s:%30s\n\
\t%-12s:%30s\n" \
       tag $tag \
       uid $uid \
       gid $gid \
       gids $gids \
       group_names $group_names \
       dockerfile $dockerfile 

sudo docker image build \
     --tag $tag \
     --build-arg uid=$uid \
     --build-arg gid=$gid \
     --build-arg gids=$gids \
     --build-arg group_names=$group_names \
     --file $dockerfile \
    `pwd`

# # easy run
# tag=build-explicit:latest;
# uid=1001;
# gid=1001;
# gids=1001,1002;
# group_names=newbuntu,new2buntu;
# dockerfile=Dockerfile;
# . build-explicit.sh $tag $uid $gid $gids $group_names $dockerfile 
