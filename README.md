# NGINX + ACME.sh

Lightweight Docker image for NGINX with ACME support

## Usage

### Testing

    # Just for testing
    docker run \
        --rm -it \
        --net host \
        --name nginx-test \
        --publish 80:80/tcp \
        fialakarel/nginx

### Production

    # Create directory structure first
    mkdir -p /root/nginx/etc/nginx/certs
    mkdir -p /root/nginx/etc/nginx/sites
    
    # Run production version
    docker run \
        --detach \
        --restart always \
        --name nginx \
        --publish 80:80/tcp \
        --publish 443:443/tcp \
        --link gitlab:gitlab \
        --volume /etc/localtime:/etc/localtime:ro \
        --volume /etc/machine_id:/etc/machine_id:ro \
        --volume /root/nginx/etc/nginx/sites:/etc/nginx/sites:ro \
        --volume /root/nginx/etc/nginx/certs:/etc/nginx/certs:rw \
        --volume /root/nginx/var/www/static.example.com:/var/www/static.example.com:ro \
        fialakarel/nginx

### How to generate certificates

    # domain name
    export certfile="example.com"
    
    # generate new certificates
    docker exec -it nginx \
        /root/.acme.sh/acme.sh \
            --issue --keylength 4096 \
            --domain ${certfile} \
            --domain www.${certfile} \
            --domain static.${certfile} \
            --webroot /etc/nginx/certs/webroot/${certfile} \
            --certpath /etc/nginx/certs/${certfile}.crt \
            --keypath /etc/nginx/certs/${certfile}.key \
            --capath /etc/nginx/certs/ca-${certfile}.crt \
            --fullchainpath /etc/nginx/certs/${certfile}.pem \
            --reloadcmd "nginx -s reload"
    
    # restart nginx container
    docker restart nginx

#### How to automatically renew certificates

See `generate-certs-sample` for more information and use the following CRON job example.

    # Renew certificates
    0 1 1 * * /bin/bash /root/bin/generate-certs
