coinflip () {
	if [[ $# -ge 3 ]]; then
		echo "too many arguments\n";
		return 0;
	elif [[ $# -ge 2 ]]; then
		heads=$1
		tails=$2
	elif [[ $# -ge 1 ]]; then
		heads=$1
		tails="not $1"
	else
		heads="heads";
		tails="tails"; 
	fi
	if [ $RANDOM -ge 16384 ]; then
		echo $heads;
	else 
		echo $tails; 
	fi
}
