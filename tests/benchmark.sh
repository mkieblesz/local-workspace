function displaytime {
    local T=$1
    local H=$((T/60/60))
    local M=$((T/60%60))
    local S=$((T%60))
    (( $H > 0 )) && printf '%d hours ' $H
    (( $M > 0 )) && printf '%d minutes ' $M
    (( $S > 0 )) && printf '%d seconds' $S
}