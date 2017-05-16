#!/bin/zsh

#osc_enter() {
#  docker exec -it osc /bin/bash
#}



osc_init() {
  # kill the image if it is running
  osc_kill

  # move to the osc folder
  mkdir -p ~/osc
  cd ~/osc
  
  # launch code
  code .
  
  # start the container
docker run -it --name=osc \
          -v "$(pwd):/root" \
          -w "/root" \
          jaltek/docker-opensuse-osc-client /bin/bash
#  docker create --name=osc \
#          -v "$(pwd):/root" \
#          jaltek/docker-opensuse-osc-client /bin/bash
#  docker start osc
}



osc_kill() {
  [[ $(docker ps -a|grep osc|wc -l) -gt 0 ]] && {
    docker kill osc &>/dev/null || true
    docker rm osc
  }
}
