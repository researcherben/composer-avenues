After playing with IFR for a long while, I realized the intent of IFR is
for a web host that has something like CentOS + PHP. 


step 1: create IFR within a container

    docker build -t mediawiki_ifr -f Dockerfile.create_ifr

step 2: get .tar from image onto host

    docker run --rm --entrypoint cat mediawiki_ifr /var/tmp/ifr.tar > ifr_host.tar

citation: https://stackoverflow.com/a/34093828/1164295


step 3: create MW container

    docker build -f Dockerfile.mw_with_ifr -t mw_with_ifr .

first_compose: #build_mediawiki
        rm -rf db images stack_new.yml
        mkdir db
        mkdir images
        cat stack.yml | sed 's/.*\.\/LocalSettings.php.*//g'  > stack_new.yml
        docker-compose --file stack_new.yml  up --force-recreate


#    docker run -it -v`pwd`:/scratch --rm mw_with_ifr:latest /bin/bash


