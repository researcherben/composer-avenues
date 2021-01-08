# install Semantic MediaWiki extension to existing MediaWiki

Options:
* Normally the Semantic MediaWiki extension is installed using [Composer](https://getcomposer.org/), as per
https://www.semantic-mediawiki.org/wiki/Help:Installation
* If [Composer](https://getcomposer.org/download/) is not available on the MediaWiki server, Composer can be run off-line on a separate server to create an "IndividualFileRelease". Then the IFR is uploaded to the MediaWiki server
* Build [Composer from source](https://github.com/composer/composer) on the MW server; also upload each of the dependent extensions as git repos. To get the dependent git repos,
   * manually resolve each dependency and manually download each repo
   * use a Python recursive function to crawl the packagist API

Whatever route you take to getting SMW, there's a separate [repo for SMW in MW](https://github.com/researcherben/mediawiki-in-docker)

## IFR route

The normal installation process  
https://www.semantic-mediawiki.org/wiki/Help:Installation  
refers to this subpage  
https://www.semantic-mediawiki.org/wiki/Help:Installation/Using_Tarball_(without_shell_access)  
which depends on  
https://www.semantic-mediawiki.org/wiki/Help:Individual_file_release   
which uses a shell script    
https://raw.githubusercontent.com/SemanticMediaWiki/IndividualFileRelease/master/IndividualFileRelease.sh   
( from https://github.com/SemanticMediaWiki/IndividualFileRelease )    
which relies on Composer (line 47) to build an Individual File Release.   




# how Composer finds packages

https://stackoverflow.com/questions/16203122/where-do-php-composer-packages-come-from

how to specify local paths for Composer: https://getcomposer.org/doc/05-repositories.md#path


## packages

* https://packagist.org/packages/mediawiki/semantic-result-formats
* https://packagist.org/packages/mediawiki/semantic-media-wiki


The following packages are not needed by SMW but look interesting and are stand-alone (no dependencies)
* https://packagist.org/packages/mediawiki/mermaid

See also https://github.com/ProfessionalWiki/SemanticBundle
