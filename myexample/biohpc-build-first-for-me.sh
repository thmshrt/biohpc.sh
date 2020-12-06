docker1 build \
	-t first-for-me:latest \
	--file first-for-me.Dockerfile \
	--build-arg uid=$(id --user) \
	cd /workdir/$USER/myexample/
