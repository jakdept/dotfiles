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
    [Bb])
    echo '3'
    ;;
    [Cc])
    echo '4'
    ;;
    [Dd])
    echo '5'
    ;;
    [Ee])
    echo '6'
    ;;
    [Ff])
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
  local parts=("$@[@]")

echo first element is $@[1] and on the array it is $parts[1]

  local pos=1
  while [[ ${pos} -lt "${#parts[@]}" ]] ; do
    case "${parts[${pos}]}" in
      -*[bcDEeFIiLQRSWwp])
      # these are multi-argument flags - they can have a space after them or no
        echo double flag ${parts[${pos}]} out of ${parts[*]}
      local multi_flags='^\-.*[bcDEeFIiLQRSWwp]\ +\-'
      local nextTwo="${parts[${pos}]} ${parts[${pos}+1]}"
      if [[ ${nextTwo} =~ "${multi_flags}" ]]; then
        # if there is a space between this arg and the next, skip twice
        parts=(${parts:2})
      else
        parts=(${parts:1})
      fi
      unset multi_flags
      unset nextTwo
      ;;
      -*)
        echo single flag at ${parts[${pos}]} out of ${parts[*]}
        parts=(${parts:1})
      ;;
      *)
        echo looking at ${parts[${pos}]} out of ${parts[*]}
        ((pos++))
      ;;
    esac
  done

  echo "out of case statement and the remaining parts are $parts[*]"

  return 0
  unset pos
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
