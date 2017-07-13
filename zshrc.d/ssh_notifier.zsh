#!/bin/zsh

host_color() {
	emulate -LR zsh

  local -x host=""

  if [[ $# -lt 2 ]]; then
    print "you have to specify a host to connect to"
    exit 1
  fi

  # pop off the ssh command on the start
  local parts=${$@[2,$#]}
  local pos=1

  while [[ ${pos} -lt $#parts  ]] ; do
    case $parts[${pos}] in
    ^-*[b|c|D|E|e|F|I|i|L|Q|R|S|W|w|p])
      # these are multi-argument flags - they can have a space after them or no
      if [[ $parts[${pos}] ~= ^-.*?[b|c|D|E|e|F|I|i|L|Q|R|S|W|w|p]\ [^\ ] ]]; then
        # if there is a space between this arg and the next, skip twice
        ((pos++))
      fi
      ;;
    ^-*)
      ;;
    *)
      # add that position in the array to the host slice
      host+=($parts[${pos}])
      ;;
    esac
    ((pos++))
  done

  unset pos
  unset parts

  host=$host[1]
  if [[ $host[1] ~= ^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) ]]; then
    if [[ $(dig +short -x $match[1]) != "" ]]; then
      # if there's a ptr record, set that to the hostname
      host=$(dig +short -x $match[1])
    else
      host=$match[1]
    fi
  elif host ~= ^([0-9a-fA-F:]*); then
    if [[ $(dig +short -x $match[1]) != "" ]]; then
      # if there's a ptr record, set that to the hostname
      host=$(dig +short -x $match[1])
    else
      host=$match[1]
    fi
  fi

  color=$(echo ${host}|openssl md5|awk '{print toupper(substr($2, 0, 6));}')

}