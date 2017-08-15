# list open ssh sockets
ssh_list() {
  ls ~/.ssh/.master-* 2>/dev/null|xargs -L1 basename|sed \
    -e 's/\.master-//g' \
    -e 's/:/ -p/g' \
    -e 's/^/ssh /g' \
}