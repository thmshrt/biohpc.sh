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
    | sed -E "s/<template>/$image_safe-$user/g" \
    | sed -E "s/<user>/$user/g" \
    | sed -E "s/<uid>/$uid/g" \
    | sed -E "s/<groups>/$groups/g" \
    | sed -E "s/<image>/$image_safe/g" \
	  > ./$image_safe-$user/$image_safe-$user.Dockerfile

# build.sh
cat template/build.sh \
    | sed -E "s/<template>/$image_safe-$user/g" \
    | sed -E "s/<user>/$user/g" \
    | sed -E "s/<uid>/$uid/g" \
    | sed -E "s/<groups>/$groups/g" \
    | sed -E "s/<image>/$image_safe/g" \
	  > ./$image_safe-$user/build.sh

# instantiate.sh
cat template/instantiate.sh \
    | sed -E "s/<template>/$image_safe-$user/g" \
    | sed -E "s/<user>/$user/g" \
    | sed -E "s/<uid>/$uid/g" \
    | sed -E "s/<groups>/$groups/g" \
    | sed -E "s/<image>/$image_safe/g" \
    | sed -E 's/sudo docker /docker /g' \
    | sed -E 's/docker image_safe /docker /g' \
    | sed -E 's/docker /docker1 /g' \
    | sed -E 's/--tag/-t/g' \
	  > ./$image_safe-$user/instantiate.sh
