rcndig () {

	emulate -LR zsh

	rcn_nodes=(	rcn-b2s1-06.liquidweb.com
			rcn-b2s1-07.liquidweb.com
			rcn-b2s1-08.liquidweb.com
			rcn-b2s1-09.liquidweb.com
			rcn-b2s1-10.liquidweb.com
			rcn-b2s2-04.liquidweb.com
			rcn-b2s2-05.liquidweb.com
			rcn-b2s2-06.liquidweb.com
			rcn-b2s3-03.liquidweb.com
			rcn-b2s3-04.liquidweb.com
			rcn-b3s4-01.liquidweb.com
			rcn-b3s4-02.liquidweb.com
			rcn-b3s4-03.liquidweb.com
			rcn-b3s4-04.liquidweb.com
			rcn-b3s4-05.liquidweb.com
			rcn-b3s4-06.liquidweb.com
			rcn-b3s5-01.liquidweb.com
			rcn-b3s5-02.liquidweb.com
			rcn-b3s5-04.liquidweb.com
			rcn-b3s7-01.liquidweb.com
			rcn-b3s7-02.liquidweb.com
			rcn-b3s7-03.liquidweb.com
			rcn-b3s7-04.liquidweb.com
			rcn-b3s8-01.liquidweb.com
			rcn-b3s8-02.liquidweb.com
			rcn-b3s8-03.liquidweb.com
			rcn-b3s8-04.liquidweb.com
			rcn-b3s8-05.liquidweb.com
			rcn-b3s8-06.liquidweb.com
			rcn-b3s8-07.liquidweb.com
			rcn-b3s8-08.liquidweb.com
			rcn-b3s8-09.liquidweb.com
			rcn-b3s8-10.liquidweb.com
			rcn-b3s8-11.liquidweb.com
			rcn-b3s8-12.liquidweb.com
			rcn-b3s9-01.liquidweb.com
			rcn-b3s9-02.liquidweb.com
			rcn-b4s1-01.liquidweb.com
			rcn-b4s1-02.liquidweb.com
			rcn-b5s6-01.liquidweb.com
			rcn-b5s6-02.liquidweb.com
	)

	if [[ $# -ge 3 ]]; then
		print "too many arguments"
	elif [[ $# -eq 2 ]]; then
		for node in $rcn_nodes; do echo $node : `dig +short $1 $2 \@$node`; done
		echo my resolver : $(dig +short $1 $2 )
		echo google : $(dig +short $1 $2 \@8.8.8.8 )
	elif [[ $# -eq 1 ]]; then
		for node in ${rcn_nodes[*]}; do echo $node : `dig +short $1 \@$node`; done
		echo my resolver : $(dig +short $1 )
		echo google : $(dig +short $1 \@8.8.8.8 )
	else
		print "usage: run dig against all RCN nodes"
		print "takes: [flag] location"
	fi
}
