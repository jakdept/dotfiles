#!/bin/bash

host_color_string_replace() {
  if [ -z ${1} ]; then
    return 2
  fi

  case ${1} in
    8)
    echo '0'
    ;;
    9)
    echo '1'
    ;;
    A|a)
    echo '2'
    ;;
    B|b)
    echo '3'
    ;;
    C|c)
    echo '4'
    ;;
    D|d)
    echo '5'
    ;;
    E|e)
    echo '6'
    ;;
    F|f)
    echo '7'
    ;;
    *)
    echo "${1}"
    ;;
  esac

}

host_color() {
  if [[ $# -lt 1 ]]; then
    print "you have to specify a host to connect to"
    exit 1
  fi

  # pop off the ssh command on the start
  local parts=$@
  local pos=1
  while [[ ${pos} -lt "${#parts[@]}" ]] ; do
    case "$parts[${pos}]" in
      ^-*[b|c|D|E|e|F|I|i|L|Q|R|S|W|w|p])
      # these are multi-argument flags - they can have a space after them or no
      local multi_flags='^\-.*?(b|c|D|E|e|F|I|i|L|Q|R|S|W|w|p)\ +-'
      if [[ $parts[${pos}] =~ ${multi_flags} ]]; then
        # if there is a space between this arg and the next, skip twice
        shift ${parts}
        shift ${parts}
      fi
      ;;
      ^-*)
        shift ${parts}
      ;;
      *)
        ((pos++))
      ;;
    esac
  done

  unset pos
  unset parts
  local -x host=""

  host=$parts[1]
  local ipv4='^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})'
  local ipv6='^([0-9a-fA-F:]*)'

  if [[ ${host} =~ ${ipv4} ]]; then
    if [[ $(dig +short -x $match[1]) != "" ]]; then
      # if there's a ptr record, set that to the hostname
      host=$(dig +short -x $match[1])
    else
      host=$match[1]
    fi
  elif [[ ${host} =~ ${ipv6} ]] ; then
    if [[ $(dig +short -x $match[1]) != "" ]]; then
      # if there's a ptr record, set that to the hostname
      host=$(dig +short -x $match[1])
    else
      host=$match[1]
    fi
  fi

  local hash=$(echo ${host}|openssl md5|awk '{print $2}')

  local -x ret_val

  local color=$(host_color_string_replace ${hash:0:1})
  color+=${hash:1:2}
  color+=$(host_color_string_replace ${hash:2:3})
  color+=${hash:3:4}
  color+=$(host_color_string_replace ${hash:5:6})
  color+=${hash:6:7}

  echo ${host}
  echo ${color}
}
