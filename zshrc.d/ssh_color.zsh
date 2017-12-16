#!/bin/bash

ssh_color_string_replace() {
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

ssh-change-title() {
  # sets the title
  printf "\033]0;$*\007"
}

ssh-color-convert-rgb(){
  local hexColor=${1}

  local rColor=$(printf "%d" "0x${hexColor:0:2}00")
  local gColor=$(printf "%d" "0x${hexColor:2:2}00")
  local bColor=$(printf "%d" "0x${hexColor:4:2}00")

  echo "${rColor}, ${gColor}, ${bColor}"
}

ssh-change-color() {
  local hexColor=${1}

  if [[ -z ${SSH_COLOR+x} ]]; then
    if [[ "$TERM" = "screen"* ]] && [[ -n "$TMUX" ]] ; then
      tmux select-pane -P "bg=#${color}"
    elif [[ ${TERM_PROGRAM} == "Apple_Terminal" ]] ; then
      color=$(ssh-color-convert-rgb ${hexColor})
      osascript -e "tell application \"Terminal\"
        set background color of current settings of selected tab of front window to {${color}}
      end tell"
    elif [[ ${TERM_PROGRAM} == "iTerm.app" ]] ; then
      color=$(ssh-color-convert-rgb ${hexColor})
      osascript -e "tell application \"iTerm\"
        set background color of current session of front window to {${color}}
      end tell"
    else
      printf "\033]11;#${hexColor}\007"
    fi
  fi
}

ssh-color-get-dest () {
  # bcDEeFIiLQRSWwp are all flags for openssh that can take two arguments
  # -e 's/-[^ bcDEeFIilLQRSWwp]*[bcDEeFIilLQRSWwp]\ [^ ]*//g' \
  local part=$(echo $@|sed \
  -e 's/^/  /' \
  -e 's/$/  /' \
  -e 's/\ -[^ b]*b\ [^ ]*/ /g' \
  -e 's/\ -[^ c]*c\ [^ ]*/ /g' \
  -e 's/\ -[^ D]*D\ [^ ]*/ /g' \
  -e 's/\ -[^ e]*e\ [^ ]*/ /g' \
  -e 's/\ -[^ E]*E\ [^ ]*/ /g' \
  -e 's/\ -[^ F]*F\ [^ ]*/ /g' \
  -e 's/\ -[^ i]*i\ [^ ]*/ /g' \
  -e 's/\ -[^ I]*I\ [^ ]*/ /g' \
  -e 's/\ -[^ l]*l\ [^ ]*/ /g' \
  -e 's/\ -[^ L]*L\ [^ ]*/ /g' \
  -e 's/\ -[^ p]*p\ [^ ]*/ /g' \
  -e 's/\ -[^ Q]*Q\ [^ ]*/ /g' \
  -e 's/\ -[^ R]*R\ [^ ]*/ /g' \
  -e 's/\ -[^ S]*S\ [^ ]*/ /g' \
  -e 's/\ -[^ w]*w\ [^ ]*/ /g' \
  -e 's/\ -[^ W]*W\ [^ ]*/ /g' \
  -e 's/ -[^ ]*$//g' \
  -e 's/.*@//g' \
  -e 's/^ *//g' \
  -e 's/\ .*$//g' \
  )

  echo "${part}"
}


ssh-color-get-host-ip() {
  local dest=$1

  local host=""
  local ip=""

  local ipv4='^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})$'
  local ipv6='^([0-9a-fA-F:]*)$'

  if [[ ${dest} =~ ${ipv4} ]]; then
    ip=${dest}
    host=$(dig +short -x ${dest}|head -n1)
  elif [[ ${dest} =~ ${ipv6} ]] ; then
    ip=${dest}
    host=$(dig +short -x ${dest}|head -n1)
  else
    ip=$(dig +short ${dest}|head -n1)
    host=${dest}
  fi

  echo ${host} ${ip}
}

ssh-color-compress-color() {
  local input=${1}
  local hexColor=

  hexColor+=$(ssh_color_string_replace ${input[1]})
  hexColor+=${input[2]}
  hexColor+=$(ssh_color_string_replace ${input[3]})
  hexColor+=${input[4]}
  hexColor+=$(ssh_color_string_replace ${input[5]})
  hexColor+=${input[6]}

  echo ${hexColor}
}

ssh-color-reset() {
  ssh-change-title " localhost "
  ssh-change-color 000000
}

ssh-color() {
  if [[ $# -lt 1 ]]; then
    print "you have to specify a host to connect to"
    exit 1
  fi

  # trap on ctrl-c
  trap ssh-color-reset INT

  local dest=$(ssh-color-get-dest $*)

  local ip=
  local host=

  read host ip <<(ssh-color-get-host-ip ${dest})

  local hash=$(echo ${host} ${ip}|openssl md5|awk '{print $NF}')

  local hexHash=$(echo ${hash:0:6})

  local hexColor=$(ssh-color-compress-color ${hexHash})

  # echo debugging ${hash} ${hexHash} ${hexColor} ${host} ${ip} ${rColor} ${gColor} ${bColor}

  [[ -z ${ip} ]]&&ssh-change-title ${host}||ssh-change-title "${host} - ${ip}"

  ssh-change-color ${hexColor} 

  ${SSH_BINARY} $*
  local retCode=$?

  ssh-change-title " localhost "
  ssh-change-color 000000
  
  trap - SIGINT
  return ${retCode}
}

SSH_BINARY=$(type -a ssh|awk '!/alias/ && !/function/ {print $NF}'|head -n1)
compdef _ssh ssh-color=ssh
alias ssh=ssh-color
ssh-color-reset
