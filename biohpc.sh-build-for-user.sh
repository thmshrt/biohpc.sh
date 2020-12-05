tag=$1
user=$2
filepath=$3
uid=$(id --user $user)
gid=$(id --group $user)
gids=$(id --groups $user)
group_names=$(id --groups --name $user)

# arg checks
if [[ \
      $tag = '' || $tag = '--help' \
    ]];
then
    echo 'usage:' 
    echo '	biohpc.sh-build-for-user <tag> <user> <filepath>'
    echo ''
    echo 'args:'
    echo '	<tag>        is the tag to give to the image'
    echo '	             default: none, user is required to supply this'
    echo '	<user>       is existing user whos id you want to replicate in container'
    echo '	             default: $(whoami)'
    echo '	<filepath>   is the path of the dockerfile'
    echo '	             default: ./Dockerfile'
    echo ''
    echo 'example: minimum behavior'
    echo '	tag=image_for_user:latest'
    echo '	biohpc.sh-build-for-user.sh $tag'
    echo ''
    echo 'example: passing arguments explicity'
    echo '	tag=image_for_$user:latest'
    echo '	user=$(whoami);'
    echo '	filepath=./Dockerfile;'
    echo '	biohpc.sh-build-for-user.sh $tag $user $dockerfile'
    return 1
fi

if [[ $user = '' ]];
then
    user=$(whoami)
fi

if [[ $filepath = '' ]];
then
    dockerfile_name=Dockerfile
    dockerfile_dir=$(readlink --canonicalize ./)
else
    temp=$filepath
    dockerfile_name=$(basename $temp)
    dockerfile_dir=$(readlink --canonicalize $(dirname $temp))
fi


printf \ "\
build-for-user.sh: \n\
\t%-15s:%30s\n\
\t%-15s:%30s\n\
\t%-15s:%30s\n\
\t%-15s:%30s\n\
\t%-15s:%30s\n\
\t%-15s:%30s\n\
\t%-15s:%30s\n" \
       uid $uid \
       gid $gid \
       gids $gids \
       group_names $group_names \
       dockerfile_name $dockerfile_name \
       dockerfile_path $dockerfile_dir \
       tag $tag

docker1 build \
     -t $tag \
     --file $dockerfile_name \
     --build-arg uid=$uid \
     --build-arg gid=$gid \
     --build-arg gids=$gids \
     --build-arg group_names=$group_names \
     $dockerfile_dir

# # example: minimum behavior
# tag=image_for_user:latest
# . biohpc.sh-build-for-user.sh $tag $user

# # example: passing arguments explicity
# user=$(whoami);
# tag=image_for_$user:latest
# dockerfile_name=Dockerfile;
# . biohpc.sh-build-for-user.sh $tag $user $dockerfile
