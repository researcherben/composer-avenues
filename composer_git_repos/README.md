step 1: download latest Composer release from
https://github.com/composer/composer/releases/tag/1.10.19

step 2: set up MediaWiki inside Docker

step 3:
cd /var/www/html/extensions
git clone https://gerrit.wikimedia.org/r/p/mediawiki/extensions/SemanticMediaWiki.git


step xx
enableSemantics('localhost');

step xx+1
php maintenance/update.php
