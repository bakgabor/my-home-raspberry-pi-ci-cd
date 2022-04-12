echo "create config to the port $PORT"
echo "server {
    listen $PORT;

    if (\$project = '') {
       set \$project \"site\";
    }

    root \"/var/www/$PROJECT_FOLDER/backend/public\";

    error_log /var/log/nginx/0.error.log;
    access_log /var/log/nginx/0.access.log;

    #more_set_headers -s '400 401 402 403 404 405' \"Access-Control-Allow-Origin: *\";

    gzip             on;
    gzip_min_length  1000;
    gzip_proxied     expired no-cache no-store private auth;
    gzip_types       text/plain application/xml text/css application/x-javascript text/javascript application/javascript;
    gzip_disable     \"msie6\";

    location / {
        add_header Access-Control-Allow-Origin *;
        add_header 'Access-Control-Allow-Methods' 'GET, PUT, POST, OPTIONS, DELETE, PATCH, COPY';
        # try to serve file directly, fallback to index.php
        try_files \$uri /index.php\$is_args\$args;

        if (\$request_method = OPTIONS ) {
            add_header Access-Control-Allow-Origin *;
            add_header Access-Control-Allow-Methods \"GET, PUT, POST, OPTIONS, DELETE, PATCH, COPY\";
            add_header Access-Control-Allow-Headers \"Authorization, Content-Type\";
            add_header Access-Control-Allow-Credentials \"true\";
            add_header Content-Length 0;
            add_header Content-Type text/plain;
            return 200;
        }
    }

    location @rewriteapp {
        rewrite ^(.*)$ /index.php/\$1 last;
    }

    location ~ ^/(index)\.php(/|$) {
        add_header Access-Control-Allow-Origin * always;
        add_header 'Access-Control-Allow-Methods' 'GET, PUT, POST, OPTIONS, DELETE, PATCH, COPY';
        fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        # When you are using symlinks to link the document root to the
        # current version of your application, you should pass the real
        # application path instead of the path to the symlink to PHP
        # FPM.
        # Otherwise, PHP's OPcache may not properly detect changes to
        # your PHP files (see https://github.com/zendtech/ZendOptimizerPlus/issues/126
        # for more information).
        fastcgi_param  SCRIPT_FILENAME  \$realpath_root\$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT \$realpath_root;
        #fastcgi_param SYMFONY__DOMAIN__NAME \$project;
    }
}" > ./install-files/backend_nginx_config
