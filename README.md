# install Semantic MediaWiki extension to existing MediaWiki

Normally the Semantic MediaWiki extension is installed using Composer, as per
https://www.semantic-mediawiki.org/wiki/Help:Installation

When composer is not available, an "IndividualFileRelease" is available. 

## context

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
