#!/bin/sh

# inspired by
# https://github.com/SemanticMediaWiki/IndividualFileRelease

set -eux

# This shell script allows you to create an individual file release in case you have no command
# line access to your webspace.

# Variables - recommended setup - may be updated to your needs before running the script
installdirectory=/scratch
softwaredirectory=ifr
mediawiki=REL1_31
semanticmediawiki=^3.2

# Commands
echo "Creating an individual file release"

cd ${installdirectory}
rm -rf ${softwaredirectory}
mkdir -p ${softwaredirectory}
cd ${softwaredirectory}


echo "Creating 'composer.json' file:"
cat <<EOF >composer.json
{
	"require": {
		"mediawiki/semantic-media-wiki": "${semanticmediawiki}"
	},
	"config": {
		"preferred-install": "source",
		"optimize-autoloader": true
	}
}
EOF
echo "Installing MediaWiki dependencies as well as predefined"
echo "semantic extensions including required dependencies:"
composer update --verbose --no-dev --prefer-source

# https://stackoverflow.com/a/13032768/1164295
find . -type d -name ".git" -exec rm -rf {} \;
find . -type d -name ".github" -exec rm -rf {} \;
find . -type f -name .git* -exec rm -rf {} \;

cd ${installdirectory}
tar cvf ifr.tar ifr/

echo "The file release may now be moved to your webspace."
