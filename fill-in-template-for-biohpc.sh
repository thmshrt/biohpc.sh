image=$1
user=`id | sed -r "s/uid=.+\((.+)\) gid.+/\1/"`
uid=`id --user`
groups=`id --groups | sed 's/ /,/g'`

# param checks
if [[ $image = '' ]];
then
    echo param image must not be empty
    return 1
fi

# ensure the name is safe
image_safe=`echo $image | sed 's/\//_/g'`

# create directory if it does not exist
if [[ ! -d $image_safe-$user ]];
then
    mkdir ./$image_safe-$user
fi

# dockerfile
cat template/template.Dockerfile \
    | sed -e "s/<image>/$image/g" \
    | sed -e "s/<user>/$user/g" \
    | sed -e "s/<uid>/$uid/g" \
    | sed -e "s/<groups>/$groups/g" \
	  > ./$image_safe-$user/$image_safe-$user.Dockerfile

# build.sh
cat template/build.sh \
    | sed -e "s/<image>/$image_safe/g" \
    | sed -e "s/<user>/$user/g" \
    | sed -e 's/sudo docker /docker /g' \
    | sed -e 's/docker image /docker /g' \
    | sed -e 's/docker /docker1 /g' \
    | sed -e 's/--tag/-t/g' \
	  > ./$image_safe-$user/build.sh

# instantiate.sh
cat template/instantiate.sh \
    | sed -e "s/<image>/$image_safe/g" \
    | sed -e 's/sudo docker /docker /g' \
    | sed -e 's/docker image /docker /g' \
    | sed -e 's/docker /docker1 /g' \
    | sed -e 's/--tag/-t/g' \
	  > ./$image_safe-$user/instantiate.sh
