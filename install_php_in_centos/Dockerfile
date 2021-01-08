FROM centos:7

# from https://www.cyberciti.biz/faq/how-to-install-php-7-2-on-centos-7-rhel-7/
RUN yum -y install epel-release && \
    yum-config-manager --enable remi-php72 && \
    yum -y update && \
    yum -y install php php-common php-cli git vim whch && \
    yum clean all


WORKDIR /opt/

RUN git clone https://github.com/composer/composer.git

# from https://packagist.org/packages/mediawiki/semantic-media-wiki
#git clone https://github.com/SemanticMediaWiki/SemanticMediaWiki.git

# https://php-download.com/package/mediawiki/semantic-media-wiki
# https://php-download.com/package/mediawiki/semantic-cite
# https://php-download.com/package/mediawiki/semantic-glossary
