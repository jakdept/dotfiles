#!/bin/sh

if [ "$(uname -s)" == "Darwin" ]
then
	BOOTSTRAP_TAR="bootstrap-trunk-x86_64-20161011.tar.gz"
	BOOTSTRAP_SHA="09d6649027ce12cadf35a47fcc5ce1192f40e3b2"

	# Download the bootstrap kit to the current directory.
	curl -O https://pkgsrc.joyent.com/packages/Darwin/bootstrap/${BOOTSTRAP_TAR}

	# Verify the SHA1 checksum.
	echo "${BOOTSTRAP_SHA}  ${BOOTSTRAP_TAR}" >check-shasum
	shasum -c check-shasum

	# Install bootstrap kit to /opt/pkg
	sudo tar -zxpf ${BOOTSTRAP_TAR} -C /

	# Reload PATH/MANPATH (pkgsrc installs /etc/paths.d/10-pkgsrc for new sessions)
	eval $(/usr/libexec/path_helper)

	sudo pkgin -y install git
elif ["$(uname -s)" == "Linux" ]
then
	sudo apt-get -y install git
else
then
	echo "unsupported system"
	exit 1
fi

git clone https://git.liquidweb.com/jhayhurst/dotfiles.git ~/dotfiles

exec ~/dotfiles/scripts/install