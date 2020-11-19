#!/bin/sh

#Using new set of docker commands
# Docker unused volume prune - https://docs.docker.com/engine/reference/commandline/volume_prune/
#docker volume prune -f
#docker system prune -a -f --filter "until=24h"


#Below command will remove:
#        - all stopped containers
#        - all networks not used by at least one container
#        - all volumes not used by at least one container
#        - all dangling images
#        - all build cache

docker system prune -f --volumes

# Reference Url::: https://github.com/docker/cli/issues/625

# keep last build for each image from the repository
for diru in `docker images --format "{{.Repository}}" | sort | uniq`; do
    for dimr in `docker images --format "{{.ID}};{{.Repository}}:{{.Tag}};'{{.CreatedAt}}'" --filter reference="$diru" | sed -r "s/\s+/~/g" | tail -n+2`; do
        img_tag=`echo $dimr | cut -d";" -f2`;
        echo "Image/Repository Name fetched is $img_tag" >&2;
        docker rmi $img_tag;
    done;
done
