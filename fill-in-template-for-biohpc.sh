image=$1
user=`id | sed -r "s/uid=.+\((.+)\) gid.+/\1/"`
uid=`id --user`
groups=`id --groups | sed 's/ /,/g'`

# create directory if it does not exist
if [[ ! -d $image-$user ]];
then
    mkdir ./$image-$user
fi

# dockerfile
cat template/template.Dockerfile \
    | sed -E "s/<template>/$image-$user/g" \
    | sed -E "s/<user>/$user/g" \
    | sed -E "s/<uid>/$uid/g" \
    | sed -E "s/<groups>/$groups/g" \
    | sed -E "s/<image>/$image/g" \
	  > ./$image-$user/$image-$user.Dockerfile

# build.sh
cat template/build.sh \
    | sed -E "s/<template>/$image-$user/g" \
    | sed -E "s/<user>/$user/g" \
    | sed -E "s/<uid>/$uid/g" \
    | sed -E "s/<groups>/$groups/g" \
    | sed -E "s/<image>/$image/g" \
	  > ./$image-$user/build.sh

# instantiate.sh
cat template/instantiate.sh \
    | sed -E "s/<template>/$image-$user/g" \
    | sed -E "s/<user>/$user/g" \
    | sed -E "s/<uid>/$uid/g" \
    | sed -E "s/<groups>/$groups/g" \
    | sed -E "s/<image>/$image/g" \
    | sed -E 's/sudo docker /docker /g' \
    | sed -E 's/docker image /docker /g' \
    | sed -E 's/docker /docker1 /g' \
    | sed -E 's/--tag/-t/g' \
	  > ./$image-$user/instantiate.sh
