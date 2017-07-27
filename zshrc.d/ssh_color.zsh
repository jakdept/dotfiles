#!/bin/bash

host_color_string_replace() {
  if [ -z ${1} ]; then
    return 2
  fi

  case ${1} in
    4|8|C|c)
    echo '0'
    ;;
    5|9|d|D)
    echo '1'
    ;;
    6|A|a|e|E)
    echo '2'
    ;;
    7|B|b|F|f)
    echo '3'
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
  local part=$(echo $@|sed \
  -e 's/-[^ bcDEeFIiLQRSWwp]*[bcDEeFIiLQRSWwp]\ [^ ]*\ //g' \
  -e 's/-[^ ]*\ //g' \
  -e 's/.*@//g' \
  -e 's/\ .*$//g')

  local host=""
  local ip=""

  local ipv4='^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})$'
  local ipv6='^([0-9a-fA-F:]*)$'

  if [[ ${part} =~ ${ipv4} ]]; then
    ip=${part}
    host=$(dig +short -x ${part}|head -n1)
  elif [[ ${part} =~ ${ipv6} ]] ; then
    ip=${part}
    host=$(dig +short -x ${part}|head -n1)
  else
    ip=$(dig +short ${part}|head -n1)
    host=${part}
  fi

  local hash=$(echo ${host} ${ip}|openssl md5|awk '{print $NF}')

  local hexHash=$(echo ${hash}|awk '{print substr($0, 0, 6)}')

  local hexColor=""
  hexColor+=$(host_color_string_replace ${hexHash[1]})
  hexColor+=${hexHash[2]}
  hexColor+=$(host_color_string_replace ${hexHash[3]})
  hexColor+=${hexHash[4]}
  hexColor+=$(host_color_string_replace ${hexHash[5]})
  hexColor+=${hexHash[6]}

  local rColor=$(echo ${hexColor}|awk '{printf "%d", "0x" substr($0, 0, 2)}')
  local gColor=$(echo ${hexColor}|awk '{printf "%d", "0x" substr($0, 2, 2)}')
  local bColor=$(echo ${hexColor}|awk '{printf "%d", "0x" substr($0, 4, 2)}')

  rColor=$((${rColor} * 64))
  gColor=$((${gColor} * 64))
  bColor=$((${bColor} * 64))

  echo ${part} ${host} ${ip} ${hash} ${hexColor} ${rColor} ${gColor} ${bColor}

  printf "\033]0;${host} - ${ip}\007"

  if [[ "$TERM" = "screen"* ]] && [[ -n "$TMUX" ]] ; then
    tmux select-pane -P "bg=#${color}"
  elif [[ ${TERM_PROGRAM} -eq "Apple_Terminal" ]] ; then
    osascript -e "tell application \"Terminal\"
      set targetWindow to selected tab of front window
      set background color of targetWindow to { ${rColor}, ${gColor}, ${bColor} }
      end tell"
  elif [[ ${TERM_PROGRAM} -eq "iTerm.app" ]] ; then
  else
    echo changing color
    printf "\033]11;#${color}\007"
  fi

}
