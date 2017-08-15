# list open ssh sockets
ssh_list() {
  ls ~/.ssh/.master-*|xargs -L1 basename|sed 's/\.master-//g'
}