#export PATH=$PATH:/usr/local/go/bin # add the go system binary path
export GOPATH=${HOME}/go
export PATH="$GOPATH/bin:$PATH" # add my binary to the front of my path
export CDPATH=$CDPATH:$GOPATH/src
