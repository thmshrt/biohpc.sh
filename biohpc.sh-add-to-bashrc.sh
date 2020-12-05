echo "#BEGIN biohpc.sh customization" >> $HOME/.bashrc

# add in biohpc.sh-format.sh
echo "function biohpc.sh-format-sh {" >> $HOME/.bashrc
cat ./biohpc.sh-format-sh.sh >> $HOME/.bashrc
echo "}" >> $HOME/.bashrc

# add in biohpc.sh-build-explicit.sh
echo "function biohpc.sh-build-explicit {" >> $HOME/.bashrc
cat ./biohpc.sh-build-explicit.sh >> $HOME/.bashrc
echo "}" >> $HOME/.bashrc

# add in biohpc.sh-build-for-user.sh
echo "function biohpc.sh-build-for-user {" >> $HOME/.bashrc
cat ./biohpc.sh-build-for-user.sh >> $HOME/.bashrc
echo "}" >> $HOME/.bashrc

# add in biohpc.sh-tag-docker.io.sh
echo "function biohpc.sh-tag-docker.io {" >> $HOME/.bashrc
cat ./biohpc.sh-tag-docker.io.sh >> $HOME/.bashrc
echo "}" >> $HOME/.bashrc

echo "#END biohpc.sh customization" >> $HOME/.bashrc

