docker1 container run \
	--interactive --tty \
	--volume `pwd`:/home/ubuntu/currentdir \
	biohpc_$USER/first:latest
