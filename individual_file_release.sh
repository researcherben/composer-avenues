#!/bin/sh

# inspired by 
# https://github.com/SemanticMediaWiki/IndividualFileRelease

set -eux

# This shell script allows you to create an individual file release in case you have no command
# line access to your webspace.

# Variables - recommended setup - may be updated to your needs before running the script
installdirectory=/scratch
softwaredirectory=mediawiki
mediawiki=REL1_31
semanticmediawiki=^3.2

# Commands
echo
echo "Creating an individual file release"
echo
echo "Cloning and checking out ${mediawiki} MediaWiki:"
echo
cd ${installdirectory}
#git clone https://gerrit.wikimedia.org/r/p/mediawiki/core.git ${softwaredirectory} --branch ${mediawiki} --depth 20
mkdir -p ${softwaredirectory}
cd ${softwaredirectory}
#git checkout origin/${mediawiki}
echo "Done."
echo
echo "Creating 'composer.local.json' file:"
cat <<EOF >composer.local.json
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
echo "Done."
echo
echo "Installing MediaWiki dependencies as well as predefined"
echo "semantic extensions including its required dependencies:"
echo
composer update --no-dev --prefer-source
echo "Done."
echo

cd ${installdirectory}


# https://stackoverflow.com/a/13032768/1164295
find ${softwaredirectory} -type d -name ".git" -exec rm -rf {} \;
find ${softwaredirectory} -type d -name ".github" -exec rm -rf {} \;

find ${softwaredirectory} -type f -name .git* -exec rm -rf {} \;

echo "The file release may now be moved to your webspace."
