#!/bin/zsh

openssl () {
	docker run --rm -i svagi/openssl "$@"
}

osc() {
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
}

osc_kill() {
  [[ $(docker ps -a|grep osc|wc -l) -gt 0 ]] && {
    docker kill osc &>/dev/null || true
    docker rm osc
  }
}

docker_cleanup() {
  #docker ps -aq | xargs docker rm
  docker ps --filter status=exited -q | xargs docker rm -v
  docker ps --filter status=dead -q | xargs docker rm -v
  docker images --filter dangling=true -q | xargs docker rmi
}