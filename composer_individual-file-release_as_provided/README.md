step 1: create IFR within a container

docker build -t mediawiki_ifr -f Dockerfile.create_ifr
docker run --rm --entrypoint cat mediawiki_ifr /var/tmp/ifr.tar > ifr_host.tar


step 2: create MW container

docker run -it -v`pwd`:/scratch --rm mediawiki_ifr:latest /bin/bash
