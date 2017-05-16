chkrbl () {

	emulate -LR zsh

	ip_rbls=( zen.spamhaus.org
		bl.spamcop.net
	)

	if [[ $# -ge 2 ]]; then
		print "too many arguments"
	elif [[ $# -eq 1 ]]; then
		# check to see if it's an IP
		echo $1| grep -E '^([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)$' > /dev/null
		if [[ $? = 0 ]]; then
			# we were given an IP

			IP_reversed=$(echo $1|perl -pe 's/^([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)/$4.$3.$2.$1/g')

			for rbl in ${ip_rbls[*]}; do echo checking ${rbl}	: ${IP_reversed}.${rbl}	: $(dig +short ${IP_reversed}.${rbl}); done
		fi
	else
		print "usage: run a check for an IP or domain in rbl's"
		print "takes: an IP or domain"
	fi
}
