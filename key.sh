#!/bin/bash
set -e
PROJECT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

hitchrun() {
    podman run --privileged -it --rm \
        -v $PROJECT_DIR:/src \
        -v hitchrunpy-hitch-container:/gen \
        -v ~/.ssh/id_rsa:/root/.ssh/id_rsa \
        -v ~/.ssh/id_rsa.pub:/root/.ssh/id_rsa.pub \
        --workdir /src \
        hitchrunpy-hitch \
        $1
}

case "$1" in
    "clean")
        if podman volume exists hitchrunpy-hitch-container; then
            podman volume rm hitchrunpy-hitch-container
        fi
        if podman image exists hitchrunpy-hitch; then
            podman image rm -f hitchrunpy-hitch
        fi
        ;;
    "make")
        echo "building ci container..."
        if ! podman volume exists hitchrunpy-hitch-container; then
            podman volume create hitchrunpy-hitch-container
        fi
        podman build -f hitch/Dockerfile-hitch -t hitchrunpy-hitch $PROJECT_DIR
        ;;
    "bump")
        CURRENT_VERSION=`cat VERSION`
        echo $2 > VERSION
        git add .
        git commit -m "RELEASE: Version $CURRENT_VERSION -> $2"
        git tag -a $2 -m "Version $1"
        echo "Hit enter to push..."
        read
        git push --follow-tags
    "bash")
        hitchrun "bash"
        ;;
    "--help")
        echo "Commands:"
        echo "./run.sh make     - build docker containers."
        ;;
    *)
        hitchrun "/venv/bin/python hitch/key.py $1 $2 $3 $4 $5 $6 $7 $8 $9"
        ;; 
esac

exit