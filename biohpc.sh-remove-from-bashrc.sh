# make sure that #BEGIN and #END exist
start_index=$(\
cat $HOME/.bashrc \
    | grep --line-number "#BEGIN biohpc.sh customization" \
    | sed -rn 's/(^[0-9]+).*/\1/p'
)

end_index=$(\
cat $HOME/.bashrc \
    | grep --line-number "#END biohpc.sh customization" \
    | sed -rn 's/(^[0-9]+).*/\1/p'
)

if [[ $start_index = '' || $end_index = '' ]];
then
    echo params start_index, end_index must satisfy \$v != ''
    return 1
fi

# make sure there are exactly 1 of each #BEGIN and #END 
collapsed_start=$(echo $start_index | sed 's/ /,/g')
collapsed_end=$(echo $end_index | sed 's/ /,/g')
if [[ $start_index != $collapsed_start || $end_index != $collapsed_end ]];
then
    echo params start_index, end_index must be single values
    return 1
fi

# create temp file
cat $HOME/.bashrc \
    | awk -e "NR<$start_index || NR>$end_index {print}" \
    > $HOME/temp_bashrc

# move temp file
rm $HOME/.bashrc
mv $HOME/temp_bashrc $HOME/.bashrc



