export GOPATH=$PROJECTS/go # set my go code directory
export PATH="$GOPATH/bin:$PATH" # add my binary to the front of my path
export PATH=$PATH:/usr/local/go/bin # add the go system binary path
export CDPATH=$CDPATH:.:$GOPATH/src
